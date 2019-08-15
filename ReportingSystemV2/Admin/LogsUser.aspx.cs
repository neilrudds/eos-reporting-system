using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class LogsUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle date change
            DateRangeSelect.dateChanged += new DateRangeSelect.dateChangedEventHandler(report_DateChanged);

            if (!IsPostBack)
            {
                populateDDL();
                bindUserLog(DateTime.Now, DateTime.Now);
                DateRangeSelect.OverideInitialStartValues(DateTime.Now, DateTime.Now);
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // CSS Header Sytle
            if (GridUsersLog.Rows.Count > 0)
            {
                GridUsersLog.UseAccessibleHeader = true;
                GridUsersLog.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void bindUserLog(DateTime StartDate, DateTime EndDate, string filterUser = "-1")
         {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (filterUser == "-1")
                {
                    GridUsersLog.DataSource = (from s in RsDc.LogUsers
                                               where s.Time_Stamp >= StartDate.Date && s.Time_Stamp < EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                                               orderby s.Time_Stamp descending
                                               select s);
                }
                else
                {
                    GridUsersLog.DataSource = (from s in RsDc.LogUsers
                                               where s.Time_Stamp >= StartDate.Date && s.Time_Stamp < EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                                               && s.UserName == filterUser
                                               orderby s.Time_Stamp descending
                                               select s);
                }
                GridUsersLog.DataBind();
            }
         }

        protected void populateDDL()
        {
            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            var users = UserManager.Users.Select(user => new { User = user.UserName }).ToList();

            ddlFilter.DataTextField = "User";
            ddlFilter.DataValueField = "User";
            ddlFilter.DataSource = users;
            ddlFilter.DataBind();

            // And add a default when value is NULL
            ddlFilter.Items.Insert(0, new ListItem("All Users", "-1", true));
        }

        private void report_DateChanged(object sender, DateChangedEventArgs e)
        {
            bindUserLog(e.startDate, e.endDate, ddlFilter.SelectedValue);
        }

        protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindUserLog(DateRangeSelect.StartDate, DateRangeSelect.EndDate, ddlFilter.SelectedValue);
        }
    }
}