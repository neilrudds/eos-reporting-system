using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;

namespace ReportingSystemV2.Reporting
{
    public partial class GensetStartupTime : System.Web.UI.Page
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
                        BindStartupTimes();
                        bindStartupSummary();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('alert-warning', 'Oops!', 'Please select a site..');", true);
                }

                showStartupDetail(false);
            }
        }

        protected void report_DateChanged(object sender, EventArgs e)
        {
            BindStartupTimes();
            bindStartupSummary();

            showStartupDetail(false);
        }

        #region Overview

        protected void BindStartupTimes()
        {
            ReportingBase f = (ReportingBase)Page.Master;
            //Hide the downtime ID
            gridStartupTimes.Columns[1].Visible = false;

            CustomDataContext db = new CustomDataContext();

            gridStartupTimes.DataSource = db.ed_LoadTimes_GetById(f.IdLocation, f.startDate, f.endDate.AddHours(23).AddMinutes(59).AddSeconds(59));
            gridStartupTimes.DataBind();

            if(gridStartupTimes.Rows.Count != 0)
            {
                //CSS Header Sytle
                gridStartupTimes.UseAccessibleHeader = true;
                gridStartupTimes.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void bindStartupSummary()
        {
            int totalStartups = 0;
            int totalStartupTime = 0;
            int[] durations = new int[gridStartupTimes.Rows.Count];

            // Loop Grid
            foreach (GridViewRow row in gridStartupTimes.Rows)
            {
                CheckBox cbx = new CheckBox();
                cbx = row.Cells[5].FindControl("chkExclude") as CheckBox;

                if (!cbx.Checked)
                {
                    int duration = Convert.ToInt32(row.Cells[4].Text);
                    totalStartups += 1;
                    totalStartupTime += duration;

                    // Add duration to array
                    durations[totalStartups - 1] = duration;
                }
            }

            // Remove 0's from array
            durations = durations.Where(val => val != 0).ToArray();

            if (totalStartups != 0)
            {
                lblAverageStart.Text = (totalStartupTime / totalStartups).ToString();
                lblNumStarts.Text = totalStartups.ToString();
                lblMaxStart.Text = durations.Max().ToString();
                lblMinStart.Text = durations.Min().ToString();
            }
            else
            {
                lblAverageStart.Text = "0";
                lblNumStarts.Text = "0";
                lblMaxStart.Text = "0";
                lblMinStart.Text = "0";
            }
            

            StartupSummaryDiv.Visible = true;
        }

        protected void gridStartupTimes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddl = new DropDownList();
                ddl = e.Row.FindControl("ddlStartupExempt") as DropDownList;
                Label lbl = e.Row.FindControl("lblStartupExempt") as Label;
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

        protected void gridStartupTimes_SelectedIndexChanged(object sender, EventArgs e)
        {
            // User selected a startup, show its details
            bindStartupDetail();
            showStartupDetail(true);
        }

        protected void ddlStartupExempt_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow gvrow = (GridViewRow)ddl.NamingContainer;

            int startup_id = Convert.ToInt32(gridStartupTimes.DataKeys[gvrow.RowIndex].Value);

            bool? value = new bool?();
            if (ddl.SelectedValue.ToString() == "1")
            {
                value = true;
                LogMe.LogUserMessage(string.Format("Startup ID:{0}, set to Exempt.", startup_id));
            }
            else if (ddl.SelectedValue.ToString() == "0")
            {
                value = false;
                LogMe.LogUserMessage(string.Format("Startup ID:{0}, set to Non-Exempt.", startup_id));
            }
            else
            {
                LogMe.LogUserMessage(string.Format("Startup ID:{0}, set to Unverified.", startup_id));
            }

            RsDc.ed_LoadTimes_UpdateIsExemptById(startup_id, value);

            BindStartupTimes();
        }

        protected void chkExclude_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            GridViewRow gvrow = (GridViewRow)chk.NamingContainer;

            int startup_id = Convert.ToInt32(gridStartupTimes.DataKeys[gvrow.RowIndex].Value);

            RsDc.ed_LoadTimes_UpdateIsExcludedById(startup_id, chk.Checked);

            if (chk.Checked)
            {
                LogMe.LogUserMessage(string.Format("Startup ID:{0}, has been Excluded.", startup_id));
            }
            else
            {
                LogMe.LogUserMessage(string.Format("Startup ID:{0}, has been Included.", startup_id));
            }

            BindStartupTimes();
            bindStartupSummary();
        }

        protected void showStartupDetail(bool show)
        {
            StartupDiv.Visible = !show;
            StartupSummaryDiv.Visible = !show;

            detailDiv.Visible = show;
            notesDiv.Visible = show;
            startupValueDiv.Visible = show;
        }

        #endregion

        #region Details

        protected void bindStartupDetail()
        {
            int id_location = int.Parse(gridStartupTimes.SelectedDataKey[1].ToString());
            DateTime startUp = DateTime.Parse(gridStartupTimes.SelectedDataKey[4].ToString());
            DateTime fullLoad = DateTime.Parse(gridStartupTimes.SelectedDataKey[5].ToString());
            int startUpId = int.Parse(gridStartupTimes.SelectedDataKey[0].ToString());
            int adjust = int.Parse(ddlAdjust.SelectedValue);

            DB db = new DB();

            gridStartupDetail.DataSource = db.getAllReasonForLoadTimeAppend(id_location, startUp, fullLoad, adjust, startUpId);
            gridStartupDetail.DataBind();

            //CSS Header Sytle
            gridStartupDetail.UseAccessibleHeader = true;
            gridStartupDetail.HeaderRow.TableSection = TableRowSection.TableHeader;

            //Notes
            bindStartUpNotes(startUpId);
            bindStartupDetailsSummary(startUpId);
        }

        protected void bindStartupDetailsSummary(int id)
        {
            gridStartUpRecalc.DataSource = (from s in RsDc.LoadTimes where s.ID == id select s).ToList();
            gridStartUpRecalc.DataBind();

            //CSS Header Sytle
            gridStartUpRecalc.UseAccessibleHeader = true;
            gridStartUpRecalc.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void bindStartUpNotes(int id)
        {
            var query = (from s in RsDc.LoadTimes where s.ID == id select s.Details).Single();
            if (query != null)
            {
                tbNotes.Text = query.ToString();
            }
        }

        protected void gridStartupDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[2].Text == "Hst 2nd Run Signal")
                {
                    e.Row.CssClass = "info";
                }
                else if (e.Row.Cells[2].Text == "Hst STOR Full Load")
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
            foreach (GridViewRow row in gridStartupDetail.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    // Set the last parameter to True 
                    // to register for event validation. 
                    row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridStartupDetail, "Up$" + row.RowIndex, true);
                }
            }
            base.Render(writer);
        }

        protected void gridStartupDetail_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Back")
            {
                // Return to the Downtime View
                // Hide the details
                showStartupDetail(false);
                
                //CSS Header Sytle
                gridStartupTimes.UseAccessibleHeader = true;
                gridStartupTimes.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
            else if (e.CommandName == "Up")
            {
                // Get the select row index
                int rowIndex = Convert.ToInt32(e.CommandArgument.ToString());

                // Get the user selected new details
                int startup_id = Convert.ToInt32(gridStartupDetail.DataKeys[rowIndex].Value);
                DateTime newDT = Convert.ToDateTime(gridStartupDetail.Rows[rowIndex].Cells[1].Text);
                string reason = gridStartupDetail.Rows[rowIndex].Cells[2].Text;

                // Get the original details from db.
                var orig = (from t in RsDc.ed_LoadTime_GetUpDownTimes(startup_id)
                            select new { DtStart = t.DtStart, DtFullLoad = t.DtFullLoad }).SingleOrDefault();

                DateTime startDT = Convert.ToDateTime(orig.DtStart);
                DateTime fullDT = Convert.ToDateTime(orig.DtFullLoad);

                if (newDT >= startDT)
                {
                    int totalmins = Convert.ToInt32((newDT - startDT).TotalMinutes);
                    // Update the DB
                    RsDc.ed_LoadTimes_Update(startup_id, newDT, totalmins, reason, false);
                    LogMe.LogUserMessage(string.Format("Startup ID:{0}, Full load time has been updated. Reason:{1}, Uptime:{2}.", startup_id, reason, newDT.ToString()));
                    // Highlight & Refresh times
                    gridStartupDetail.Rows[rowIndex].CssClass = "info";
                    bindStartupDetailsSummary(startup_id);
                    bindStartupDetail();
                    showStartupDetail(true);
                }
                else
                {
                    // User Feedback Error
                }
            }
        }

        protected void lnkReset_Click(object sender, EventArgs e)
        {
            int startUpId = Convert.ToInt32(gridStartupDetail.DataKeys[0].Value);

            RsDc.ed_LoadTimes_Reset(startUpId);
            LogMe.LogUserMessage(string.Format("StartUp ID:{0}, has been Reset.", startUpId));
            bindStartupDetailsSummary(startUpId);
            bindStartupDetail();
            showStartupDetail(true);
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            showStartupDetail(false);

            //CSS Header Sytle
            gridStartupTimes.UseAccessibleHeader = true;
            gridStartupTimes.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void ddlAdjust_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindStartupDetail();
            showStartupDetail(true);
        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            int startUpId = int.Parse(gridStartupTimes.SelectedDataKey[0].ToString());

            RsDc.ed_LoadTimes_UpdateDetailsById(startUpId, tbNotes.Text);
            LogMe.LogUserMessage(string.Format("StartUp ID:{0}, Notes have been updated '{1}'.", startUpId, tbNotes.Text));
        }

        #endregion

    }
}