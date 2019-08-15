using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2
{
    public partial class cpl : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                PopulateUserGeneratorsGrid();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // CSS Header Sytle
            gridUserSites.UseAccessibleHeader = true;
            gridUserSites.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void PopulateUserGeneratorsGrid()
        {
            CustomDataContext db = new CustomDataContext();

            var list = new List<string> { };

            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            // Get the current logged in User and look up the user in ASP.NET Identity
            var currentUser = manager.FindById(User.Identity.GetUserId());

            // Get the site access array to list for query
            list = currentUser.SiteAccessArray.Split(',').ToList();

            var userSites = db.HL_Locations.Where(l => l.GensetEnabled == true)
                                           .Where(l => list.Contains(l.ID.ToString()));

            gridUserSites.DataSource = userSites.OrderBy(s => s.GENSETNAME).ToList();
            gridUserSites.DataBind();
        }

        protected void gridUserSites_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Highlight row text where generator has not updated for 24hrs +
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (DateTime.ParseExact(e.Row.Cells[3].Text, "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture) < DateTime.Now.AddHours(-24))
                {
                    e.Row.CssClass = "info";
                }
            }
        }
    }
}