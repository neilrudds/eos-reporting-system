using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Globalization;

namespace ReportingSystemV2.Reporting
{
    public partial class GensetAvailability : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        protected void Page_PreInit(object sender, EventArgs e)
        {
            Master.reportDateChanged += new EventHandler(report_DateChanged);
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;

            if (!Page.IsPostBack)
            {
                if (f.IdLocation != 0)
                {
                    if (f.endDate < f.startDate)
                    {
                        Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('alert-warning', 'Oops!', 'Please select a valid date range..');", true);
                    }
                    else
                    {
                        BindAvailabilityTimes();
                        bindAvailabilitySummary();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('alert-warning', 'Oops!', 'Please select a site..');", true);
                }

                showAvailabilityDetail(false);
            }
        }

        protected void report_DateChanged(object sender, EventArgs e)
        {
            BindAvailabilityTimes();
            bindAvailabilitySummary();

            showAvailabilityDetail(false);
        }

        #region Overview

        protected void BindAvailabilityTimes()
        {
            ReportingBase f = (ReportingBase)Page.Master;
            //Hide the downtime ID
            gridAvailabilityTimes.Columns[1].Visible = false;

            CustomDataContext db = new CustomDataContext();

            gridAvailabilityTimes.DataSource = db.ed_Availability_GetById(f.IdLocation, f.startDate, f.endDate.AddHours(23).AddMinutes(59).AddSeconds(59));
            gridAvailabilityTimes.DataBind();

            if(gridAvailabilityTimes.Rows.Count != 0)
            {
                //CSS Header Sytle
                gridAvailabilityTimes.UseAccessibleHeader = true;
                gridAvailabilityTimes.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void bindAvailabilitySummary()
        {
            ReportingBase f = (ReportingBase)Page.Master;

            // Binds the summary at the top of the page for the user to see the availability at a glance
            TimeSpan tsGrossHours = (f.endDate.AddDays(1) - f.startDate);

            int? minsUnavailable = RsDc.GeneratorAvailabilities
                                  .Where(a => a.DtUnavailable >= f.startDate && a.DtUnavailable < f.endDate.AddHours(23).AddMinutes(59).AddSeconds(59) && a.IdLocation == f.IdLocation)
                                  .Sum(a => (int?)a.TimeDifference);

            double dblMinsAvalilable = 0.0;
            if (minsUnavailable != null)
            {
                dblMinsAvalilable = (double)minsUnavailable;
            }

            lblSumGrossHrs.Text = tsGrossHours.TotalHours.ToString();

            int totalExempts = 0;
            int totalNonExempts = 0;

            // Loop Grid
            foreach (GridViewRow row in gridAvailabilityTimes.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.Cells[5].FindControl("ddlAvailabilityExempt") as DropDownList;

                CheckBox cbx = new CheckBox();
                cbx = row.Cells[6].FindControl("chkExclude") as CheckBox;

                if (!cbx.Checked)
                {
                    if (ddl.SelectedValue == "1")
                    {
                        totalExempts += Convert.ToInt32(row.Cells[4].Text);
                    }
                    else
                    {
                        totalNonExempts += Convert.ToInt32(row.Cells[4].Text);
                    }
                }
            }

            TimeSpan tsTotalExempts = new TimeSpan(0, totalExempts, 0);
            TimeSpan tsTotalNonExempts = new TimeSpan(0, totalNonExempts, 0);

            lblSumTotExempts.Text = ((tsTotalExempts.Days * 24 + tsTotalExempts.Hours).ToString().PadLeft(4, '0') + ":" + tsTotalExempts.Minutes.ToString().PadLeft(2, '0'));
            lblSumTotNonExempts.Text = ((tsTotalNonExempts.Days * 24 + tsTotalNonExempts.Hours).ToString().PadLeft(4, '0') + ":" + tsTotalNonExempts.Minutes.ToString().PadLeft(2, '0'));

            double AvaliableMins = (tsGrossHours.TotalMinutes - dblMinsAvalilable) + tsTotalExempts.TotalMinutes;
            TimeSpan tsAvailable = new TimeSpan(0, Convert.ToInt32(AvaliableMins), 0);
            lblSumhrsAvailableHours.Text = ((tsAvailable.Days * 24 + tsAvailable.Hours).ToString().PadLeft(4, '0') + ":" + tsAvailable.Minutes.ToString().PadLeft(2, '0'));

            lblAvailability.Text = ((tsAvailable.TotalMinutes / tsGrossHours.TotalMinutes)).ToString("P", CultureInfo.InvariantCulture);

            AvailabilitySummaryDiv.Visible = true;
        }

        protected void gridAvailabilityTimes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddl = new DropDownList();
                ddl = e.Row.FindControl("ddlAvailabilityExempt") as DropDownList;
                Label lbl = e.Row.FindControl("lblAvailabilityExempt") as Label;
                switch (lbl.Text)
                {
                    case "True":
                        ddl.SelectedValue = "1";
                        break;
                    case "False":
                        ddl.SelectedValue = "0";
                        break;
                    default:
                        ddl.SelectedValue = "-1";
                        break;
                }
            }
        }

        protected void gridAvailabilityTimes_SelectedIndexChanged(object sender, EventArgs e)
        {
            // User selected a startup, show its details
            bindAvailabilityDetail();
            showAvailabilityDetail(true);
        }

        protected void ddlAvailabilityExempt_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow gvrow = (GridViewRow)ddl.NamingContainer;

            int AvailabilityId = Convert.ToInt32(gridAvailabilityTimes.DataKeys[gvrow.RowIndex].Value);

            bool? value = new bool?();
            if (ddl.SelectedValue.ToString() == "1")
            {
                value = true;
                LogMe.LogUserMessage(string.Format("Availability Id:{0}, set to Exempt.", AvailabilityId));
            }
            else if (ddl.SelectedValue.ToString() == "0")
            {
                value = false;
                LogMe.LogUserMessage(string.Format("Availability Id:{0}, set to Non-Exempt.", AvailabilityId));
            }
            else
            {
                LogMe.LogUserMessage(string.Format("Availability ID:{0}, set to Unverified.", AvailabilityId));
            }

            RsDc.ed_Availability_UpdateIsExemptById(AvailabilityId, value);

            BindAvailabilityTimes();
        }

        protected void chkExclude_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            GridViewRow gvrow = (GridViewRow)chk.NamingContainer;

            int AvailabilityId = Convert.ToInt32(gridAvailabilityTimes.DataKeys[gvrow.RowIndex].Value);

            RsDc.ed_Availability_UpdateIsExcludedById(AvailabilityId, chk.Checked);

            if (chk.Checked)
            {
                LogMe.LogUserMessage(string.Format("Availability Id:{0}, has been Excluded.", AvailabilityId));
            }
            else
            {
                LogMe.LogUserMessage(string.Format("Availability Id:{0}, has been Included.", AvailabilityId));
            }

            BindAvailabilityTimes();
            bindAvailabilitySummary();
        }

        protected void showAvailabilityDetail(bool show)
        {
            AvailabilityDiv.Visible = !show;
            AvailabilitySummaryDiv.Visible = !show;

            detailDiv.Visible = show;
            notesDiv.Visible = show;
            startupValueDiv.Visible = show;
        }

        #endregion

        #region Details

        protected void bindAvailabilityDetail()
        {
            int IdLocation = int.Parse(gridAvailabilityTimes.SelectedDataKey[1].ToString());
            DateTime DtUnavailable = DateTime.Parse(gridAvailabilityTimes.SelectedDataKey[4].ToString());
            DateTime DtAvailable = DateTime.Parse(gridAvailabilityTimes.SelectedDataKey[5].ToString());
            int IdAvailability = int.Parse(gridAvailabilityTimes.SelectedDataKey[0].ToString());
            int Adjust = int.Parse(ddlAdjust.SelectedValue);

            DB db = new DB();

            gridAvailabilityDetail.DataSource = db.getAllReasonForAvailabilityAppend(IdLocation, DtUnavailable, DtAvailable, Adjust, IdAvailability);
            gridAvailabilityDetail.DataBind();

            //CSS Header Sytle
            gridAvailabilityDetail.UseAccessibleHeader = true;
            gridAvailabilityDetail.HeaderRow.TableSection = TableRowSection.TableHeader;

            //Notes
            bindAvailabilityNotes(IdAvailability);
            bindAvailabilityDetailsSummary(IdAvailability);
        }

        protected void bindAvailabilityDetailsSummary(int Id)
        {
            gridAvailabilityRecalc.DataSource = (from s in RsDc.GeneratorAvailabilities where s.Id == Id select s).ToList();
            gridAvailabilityRecalc.DataBind();

            //CSS Header Sytle
            gridAvailabilityRecalc.UseAccessibleHeader = true;
            gridAvailabilityRecalc.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void bindAvailabilityNotes(int Id)
        {
            var query = (from s in RsDc.GeneratorAvailabilities where s.Id == Id select s.Details).Single();
            if (query != null)
            {
                tbNotes.Text = query.ToString();
            }
        }

        protected void gridAvailabilityDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[2].Text == "Hst Not Available")
                {
                    e.Row.CssClass = "info";
                }
                else if (e.Row.Cells[2].Text == "Hst Available")
                {
                    e.Row.CssClass = "info";
                }
                else
                {
                    e.Row.CssClass = "";
                    e.Row.Attributes.Add("style", "cursor:pointer;");
                    e.Row.Attributes.Add("onclick", "this.style.backgroundColor='orange';");
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor='#c8e4b6'");
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=''");
                }
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            foreach (GridViewRow row in gridAvailabilityDetail.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    // Set the last parameter to True 
                    // to register for event validation. 
                    row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridAvailabilityDetail, "Up$" + row.RowIndex, true);
                }
            }
            base.Render(writer);
        }

        protected void gridAvailabilityDetail_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Back")
            {
                // Return to the Downtime View
                // Hide the details
                showAvailabilityDetail(false);

                //CSS Header Sytle
                gridAvailabilityTimes.UseAccessibleHeader = true;
                gridAvailabilityTimes.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
            else if (e.CommandName == "Up")
            {
                // Get the select row index
                int rowIndex = Convert.ToInt32(e.CommandArgument.ToString());

                // Get the user selected new details
                int IdAvailability = Convert.ToInt32(gridAvailabilityDetail.DataKeys[rowIndex].Value);
                DateTime newDT = Convert.ToDateTime(gridAvailabilityDetail.Rows[rowIndex].Cells[1].Text);
                string reason = gridAvailabilityDetail.Rows[rowIndex].Cells[2].Text;

                // Get the original details from db.
                var orig = (from t in RsDc.ed_Availability_GetUpDownTimes(IdAvailability)
                            select new { DtUnavailable = t.DtUnavailable, DtAvailable = t.DtAvailable }).SingleOrDefault();

                DateTime dtUnAvailable = Convert.ToDateTime(orig.DtUnavailable);
                DateTime dtAvailable = Convert.ToDateTime(orig.DtAvailable);

                if (newDT >= dtUnAvailable)
                {
                    int totalmins = Convert.ToInt32((newDT - dtUnAvailable).TotalMinutes);
                    // Update the DB
                    RsDc.ed_Availability_Update(IdAvailability, newDT, totalmins, reason, false);
                    LogMe.LogUserMessage(string.Format("Availability Id:{0}, Full load time has been updated. Reason:{1}, Uptime:{2}.", IdAvailability, reason, newDT.ToString()));
                    // Highlight & Refresh times
                    gridAvailabilityDetail.Rows[rowIndex].CssClass = "info";
                    bindAvailabilityDetailsSummary(IdAvailability);
                    bindAvailabilityDetail();
                    showAvailabilityDetail(true);
                }
                else
                {
                    // User Feedback Error
                }
            }
        }

        protected void lnkReset_Click(object sender, EventArgs e)
        {
            int AvailabilityId = Convert.ToInt32(gridAvailabilityDetail.DataKeys[0].Value);

            RsDc.ed_Availability_Reset(AvailabilityId);
            LogMe.LogUserMessage(string.Format("Availability Id:{0}, has been Reset.", AvailabilityId));
            bindAvailabilityDetailsSummary(AvailabilityId);
            bindAvailabilityDetail();
            showAvailabilityDetail(true);
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            showAvailabilityDetail(false);

            //CSS Header Sytle
            gridAvailabilityTimes.UseAccessibleHeader = true;
            gridAvailabilityTimes.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void ddlAdjust_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindAvailabilityDetail();
            showAvailabilityDetail(true);
        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            int AvailabilityId = int.Parse(gridAvailabilityTimes.SelectedDataKey[0].ToString());

            RsDc.ed_Availability_UpdateDetailsById(AvailabilityId, tbNotes.Text);
            LogMe.LogUserMessage(string.Format("Availability Id:{0}, Notes have been updated '{1}'.", AvailabilityId, tbNotes.Text));
        }

        #endregion

    }
}