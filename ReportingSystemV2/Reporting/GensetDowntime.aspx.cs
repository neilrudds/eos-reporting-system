using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Reporting
{
    public partial class GensetDowntime : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Attach to UserControl Event
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
                        Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('edina-warning', 'Oops!', 'Please select a valid date range..');", true);
                    }
                    else
                    {
                        BindDowntime();
                        bindDowntimeSummary();
                    }
                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('edina-warning', 'Oops!', 'Please select a site..');", true);
                }

                showDowntimeDetail(false);
            }
        }

        private void report_DateChanged(object sender, EventArgs e)
        {
            // If the user changes the date lets update the table
            BindDowntime();
            bindDowntimeSummary();

            showDowntimeDetail(false);
        }

        #region Overview

        protected void BindDowntime()
        {
            // Binds the downtime to the gv
            // Hide the downtime ID
            ReportingBase f = (ReportingBase)Page.Master;
            gridDowntime.Columns[1].Visible = false;

            gridDowntime.DataSource = db.getDowntime_SplitTimes(f.IdLocation, f.startDate, f.endDate.AddHours(23).AddMinutes(59).AddSeconds(59));
            gridDowntime.DataBind();

            if (gridDowntime.Rows.Count > 0)
            {
                // CSS Header Sytle
                gridDowntime.UseAccessibleHeader = true;
                gridDowntime.HeaderRow.TableSection = TableRowSection.TableHeader;
            }          
        }

        protected void bindDowntimeSummary()
        {
            ReportingBase f = (ReportingBase)Page.Master;

            // Binds the summary at the top of the page for the user to see the downtime at a glance
            decimal hrsRun = 0;
            TimeSpan tsGrossHours = (f.endDate.AddDays(1) - f.startDate);

            if (f.startDate.Date == f.endDate.Date)
            {
                hrsRun = db.GetActualHoursRun(f.IdLocation, f.startDate, f.endDate);
            }
            else
            {
                hrsRun = db.GetActualHoursRun(f.IdLocation, f.startDate, f.endDate);
            }

            lblSumGrossHrs.Text = tsGrossHours.TotalHours.ToString();
            lblSumRunHours.Text = hrsRun.ToString();

            int totalExempts = 0;
            int totalNonExempts = 0;

            // Loop Grid
            foreach (GridViewRow row in gridDowntime.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.Cells[5].FindControl("ddlDowntimeExempt") as DropDownList;

                CheckBox cbx = new CheckBox();
                cbx = row.Cells[6].FindControl("chkDowntimeExclude") as CheckBox;

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

            TimeSpan tsHrsRun = new TimeSpan((int)hrsRun, 0, 0);
            lblSumDifference.Text = (tsGrossHours.TotalMinutes - (tsHrsRun.TotalMinutes + tsTotalExempts.TotalMinutes + tsTotalNonExempts.TotalMinutes)).ToString();

            DowntimeSummaryDiv.Visible = true;
        }

        protected void gridDowntime_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Once data is loaded into the gv apply the ddl's for the shutdowns
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlDowntimeExempt");
                //ddl.SelectedIndexChanged += new EventHandler(ddlDowntimeExempt_SelectedIndexChanged);
                //ddl.AutoPostBack = true;

                Label lbl = (Label)e.Row.FindControl("lblDowntimeExempt");
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

        protected void gridDowntime_SelectedIndexChanged(object sender, EventArgs e)
        {
            // User selected a shutdown, show its details
            bindDowntimeDetail();
            showDowntimeDetail(true);
        }

        protected void ddlDowntimeExempt_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Applies the values selected in the exempt DDL to the database value
            DropDownList ddl = (DropDownList)sender;
            GridViewRow gvrow = (GridViewRow)ddl.NamingContainer;

            int exempt_id = int.Parse(gridDowntime.DataKeys[gvrow.RowIndex].Value.ToString());

            bool? value = new bool?();
            if (ddl.SelectedValue.ToString() == "1")
            {
                value = true;
                LogMe.LogUserMessage(string.Format("Exempt ID:{0}, set to Exempt.", exempt_id));
            }
            else if (ddl.SelectedValue.ToString() == "0")
            {
                value = false;
                LogMe.LogUserMessage(string.Format("Exempt ID:{0}, set to Non-Exempt.", exempt_id));
            }
            else
            {
                value = null;
                LogMe.LogUserMessage(string.Format("Exempt ID:{0}, set to Unverified.", exempt_id));
            }

            RsDc.ed_Exempts_UpdateIsExemptById(exempt_id, value);

            
            // Update the gv
            BindDowntime();
        }

        protected void chkDowntimeExclude_CheckedChanged(object sender, EventArgs e)
        {
            // When the Exclude checkbox is changed, update the Db
            CheckBox chk = (CheckBox)sender;
            GridViewRow gvrow = (GridViewRow)chk.NamingContainer;

            int exempt_id = int.Parse(gridDowntime.DataKeys[gvrow.RowIndex].Value.ToString());

            RsDc.ed_Exempts_UpdateIsExcludedById(exempt_id, chk.Checked);
            if (chk.Checked)
            {
                LogMe.LogUserMessage(string.Format("Exempt ID:{0}, has been Excluded.", exempt_id));
            }
            else
            {
                LogMe.LogUserMessage(string.Format("Exempt ID:{0}, has been Included.", exempt_id));
            }
            
            BindDowntime();
            bindDowntimeSummary();
        }
    
        protected void showDowntimeDetail(bool show)
        {
            // Shows or Hides a specific shutdowns detail
            downtimeDiv.Visible = !show;
            DowntimeSummaryDiv.Visible = !show;
            lbOpenAddDowntimeDiv.Visible = !show;

            detailDiv.Visible = show;
            notesDiv.Visible = show;
            downtimeValueDiv.Visible = show;
        }

        #endregion

        #region Details

        protected void bindDowntimeDetail()
        {
            // Bind the detail for the selected shutdown
            // Get the values from the gv's datakeys
            int id_location = int.Parse(gridDowntime.SelectedDataKey[1].ToString());
            DateTime dtdown = DateTime.Parse(gridDowntime.SelectedDataKey[4].ToString());
            DateTime dtup = DateTime.Parse(gridDowntime.SelectedDataKey[5].ToString());
            int exempt_id = int.Parse(gridDowntime.SelectedDataKey[0].ToString());
            int adjust = int.Parse(ddlAdjust.SelectedValue);

            // Get the detail & apply
            DB db = new DB();

            // Recalc table
            bindDowntimeDetailsSummary(exempt_id);

            // Events between downtime
            gridDowntimeDetail.DataSource = db.getAllReasonForDownTimeAppend(id_location, dtdown, dtup, adjust, exempt_id);
            gridDowntimeDetail.DataBind();

            //CSS Header Sytle

            gridDowntimeDetail.UseAccessibleHeader = true;
            gridDowntimeDetail.HeaderRow.TableSection = TableRowSection.TableHeader;

            //Notes
            bindDowntimeNotes(exempt_id);

        }

        protected void bindDowntimeDetailsSummary(int id)
        {
            gridDowntimeRecalc.DataSource = (from s in RsDc.Exempts where s.ID == id select s).ToList();
            gridDowntimeRecalc.DataBind();

            //CSS Header Sytle
            gridDowntimeRecalc.UseAccessibleHeader = true;
            gridDowntimeRecalc.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void bindDowntimeNotes(int id)
        {
            var query = (from s in RsDc.Exempts where s.ID == id select s.Details).Single();
            if (query != null)
            {
                tbNotes.Text = query.ToString();
            }
        }

        protected void gridDowntimeDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Get the uptime form the Downtime Calc table
            if (gridDowntimeRecalc.Rows.Count > 0)
            {
                string searchValue = gridDowntimeRecalc.Rows[0].Cells[1].Text; // Get the current uptime

                foreach (GridViewRow row in gridDowntimeDetail.Rows)
                {
                    if ((row.Cells[1].Text.Equals(searchValue)) && (row.Cells[2].Text != "GCB closed")) // Highlight the row if its not the original
                    {
                        row.CssClass = "info";
                    }
                }
            }

            // Highlights the GCB Open & GCB Closed Events
            // Also enables the mouse over highlight & click functionality
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[2].Text == "GCB opened")
                {
                    e.Row.CssClass = "danger";
                }
                else if (e.Row.Cells[2].Text == "GCB closed")
                {
                    e.Row.CssClass = "success";
                }
                else
                {
                    e.Row.CssClass = "";
                    e.Row.Attributes.Add("style", "cursor:pointer;");
                    e.Row.Attributes.Add("onclick", "this.style.backgroundColor='orange';");
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor='#d9edf7'");
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=''");
                }
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            // Trigger an event when a row is clicked
            foreach (GridViewRow row in gridDowntimeDetail.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    // Set the last parameter to True 
                    // to register for event validation. 
                    row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridDowntimeDetail, "Up$" + row.RowIndex, true);
                }
            }
            base.Render(writer);
        }

        protected void gridDowntimeDetail_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Handles what will happen when a selected row is clicked
            // But first - is this a request to go back?

            if (e.CommandName == "Back")
            {
                // Return to the Downtime View
                // Hide the details
                showDowntimeDetail(false);

                BindDowntime();
                bindDowntimeDetail();

                //CSS Header Sytle
                gridDowntime.UseAccessibleHeader = true;
                gridDowntime.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
            else if(e.CommandName == "Up")
            {
                // Get the selected row index
                int rowIndex = Convert.ToInt32(e.CommandArgument.ToString());

                // Get the user selected new details
                int exempt_id = Convert.ToInt32(gridDowntimeDetail.DataKeys[rowIndex].Value);
                DateTime newUp = DateTime.ParseExact(gridDowntimeDetail.Rows[rowIndex].Cells[1].Text, "dd/MM/yyyy HH:mm:ss.fff", CultureInfo.InvariantCulture);
                string reason = gridDowntimeDetail.Rows[rowIndex].Cells[2].Text;

                // Get the original details from db.
                var orig = (from t in RsDc.ed_Exempts_GetUpDownTimes(exempt_id)
                            select new { DtDown = t.DTDOWN, DtUp = t.DTUP }).SingleOrDefault();

                DateTime Down = Convert.ToDateTime(orig.DtDown);
                //DateTime Up = Convert.ToDateTime(orig.DtUp);

                if (newUp >= Down)
                {
                    int totalmins = Convert.ToInt32((newUp - Down).TotalMinutes);
                    // Update the DB
                    RsDc.ed_Exempts_Update(exempt_id, newUp, totalmins, reason, false);
                    LogMe.LogUserMessage(string.Format("Exempt ID:{0}, Uptime has been updated. Reason:{1}, Uptime:{2}.", exempt_id, reason, newUp.ToString()));
                    // Highlight & Refresh times
                    gridDowntimeDetail.Rows[rowIndex].CssClass = "info";
                    bindDowntimeDetailsSummary(exempt_id);
                    bindDowntimeDetail();
                    showDowntimeDetail(true);
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('success', 'Success!', 'The record has been updated!');", true);
                }
                else
                {
                    // User Feedback Error
                }
            }
        }

        protected void lnkReset_Click(object sender, EventArgs e)
        {
            // Reset the shutdown values back to there defaults
            int ExemptId = Convert.ToInt32(gridDowntimeDetail.DataKeys[0].Value);

            RsDc.ed_Exempts_Reset(ExemptId);
            LogMe.LogUserMessage(string.Format("Exempt ID:{0}, has been Reset.", ExemptId));
            bindDowntimeDetailsSummary(ExemptId);
            bindDowntimeDetail();
            showDowntimeDetail(true);
            Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('success', 'Success!', 'The record has been reset!');", true);
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            // Return to the Downtime View
            // Hide the details
            showDowntimeDetail(false);

            BindDowntime();
            bindDowntimeDetail();

            //CSS Header Sytle
            gridDowntime.UseAccessibleHeader = true;
            gridDowntime.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void ddlAdjust_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Adjust the viewing window (minutes)
            bindDowntimeDetail();
            showDowntimeDetail(true);
        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            // Save the Note to the Db
            int ExemptId = int.Parse(gridDowntime.SelectedDataKey[0].ToString());

            RsDc.ed_Exempts_UpdateDetailsById(ExemptId, tbNotes.Text);
            LogMe.LogUserMessage(string.Format("Exempt ID:{0}, Notes have been updated '{1}'.", ExemptId, tbNotes.Text));
            Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('success', 'Success!', 'The record has been saved!');", true);
        }

        #endregion

        protected void CusVal_Date_ServerValidate(object source, ServerValidateEventArgs args)
        {
            DateTime d;
            bool Valid = DateTime.TryParseExact(args.Value, "dd/MM/yyyy hh:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out d);
            if (!Valid)
            {
                LogMe.LogSystemError(string.Format("Unable to parse the datetime value: {0}", args.Value));
            }
            args.IsValid = Valid;
        }

        protected void lbOpenAddDowntime_Click(object sender, EventArgs e)
        {
            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addDowntimeModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddDowntimeModalScript", sb.ToString(), false);
        }

        protected void btnSaveDowntime_Click(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;
            DateTime startdate;
            DateTime enddate;

            bool ValidStart = DateTime.TryParseExact(tbstartDate.Text, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out startdate); // 24 Hour
            bool ValidEnd = DateTime.TryParseExact(tbendDate.Text, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out enddate); // 24 Hour

            if (ValidStart && ValidEnd)
            {
                if (RsDc.ed_Exempts_Insert(f.IdLocation, startdate, enddate, tbShutdownReason.Text) == 0)
                {
                    AddDowntime_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The downtime event has been created!");
                    LogMe.LogUserMessage(string.Format("A new downtime event has been created. Reason: {0}, Shutdown: {1}, Startup: {2}", tbShutdownReason.Text, tbstartDate.Text, tbendDate.Text));
                    BindDowntime();
                    bindDowntimeSummary();
                }
                else
                {
                    AddDowntime_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The downtime event could not be created, please try again!");
                }
            }
            else
            {
                LogMe.LogSystemError(string.Format("Unable to parse the datetime values: {0}, {1}", tbstartDate.Text, tbendDate.Text));
                AddDowntime_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The downtime event has invalid times, please try again!");
            }
        }
    }
}