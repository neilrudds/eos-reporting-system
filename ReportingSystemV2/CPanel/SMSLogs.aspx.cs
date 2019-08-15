using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2.CPanel
{
    public partial class SMSLogs : System.Web.UI.Page
    {
        DB db = new DB();
        ReportingSystemV2.Models.UserSites userSites = new ReportingSystemV2.Models.UserSites();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle date change
            DateRangeSelect.dateChanged += new DateRangeSelect.dateChangedEventHandler(report_DateChanged);

            if (!IsPostBack)
            {
                populateddlSelectGenerator();
                bindSMSLogs(DateTime.Now, DateTime.Now);
                DateRangeSelect.OverideInitialStartValues(DateTime.Now, DateTime.Now);
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (gridSMSLogs.Rows.Count > 0)
            {
                // CSS Header Sytle
                gridSMSLogs.UseAccessibleHeader = true;
                gridSMSLogs.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        private void report_DateChanged(object sender, DateChangedEventArgs e)
        {
            bindSMSLogs(e.startDate, e.endDate);
        }

        protected void populateddlSelectGenerator()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                ddlSelectGenerator.DataSource = (from s in RsDc.HL_Locations orderby s.GENSETNAME select s)
                    .Where(t => userSites.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));
                ddlSelectGenerator.DataTextField = "GENSETNAME";
                ddlSelectGenerator.DataValueField = "ID";
                ddlSelectGenerator.DataBind();

                // And add a default when value is NULL
                ddlSelectGenerator.Items.Insert(0, new ListItem("All Generators", "-1", true));
            }
        }

        protected void ddlSelectGenerator_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindSMSLogs(DateRangeSelect.StartDate, DateRangeSelect.EndDate);
        }

        protected void bindSMSLogs(DateTime StartDate, DateTime EndDate)
        {
            if (ddlSelectGenerator.SelectedValue == "-1")
            {
                gridSMSLogs.DataSource = db.getSMSLog(StartDate.Date, EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59));
            }
            else
            {
                gridSMSLogs.DataSource = db.getSMSLog(StartDate.Date, EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59), Convert.ToInt32(ddlSelectGenerator.SelectedValue));
            }
            gridSMSLogs.DataBind();
        }

        protected void gridSMSLogs_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Remove the text wrapping for every cell
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }
        }
    }
}