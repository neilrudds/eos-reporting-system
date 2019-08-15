using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.AspNet.Identity.EntityFramework;
using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity.Core.Objects;
using System.Data.Entity;

namespace ReportingSystemV2.Admin
{
    public partial class Admin1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    
                    var Generators = (from g in RsDc.HL_Locations where g.GENSETNAME != "UNNAMED" select g).Count();
                    var GenPending = (from p in RsDc.HL_Locations where p.GENSETNAME == "UNNAMED" select p).Count();
                    var Sites = (from s in RsDc.HL_Locations where s.GENSETNAME != "UNNAMED" group s by s.SITENAME into uniqueSites select uniqueSites.FirstOrDefault()).Count();

                    var Blackboxes = (from b in RsDc.Blackboxes select b).Count();

                    var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));
                    var users = UserManager.Users.Select(u => u).Count();
                    
                    var usersLocked = UserManager.Users.Where(u => u.LockoutEnabled == true).Select(u => u).Count();
                    var usersOnline = UserManager.Users.Where(u => u.LastActivity >= DbFunctions.AddMinutes(DateTime.Now, -15)).Select(u => u).Count();

                    var ComapColumns = (from c in RsDc.ComAp_Headers select c).Count();
                    var PendingApprovals = (from p in RsDc.ComAp_Wildcards where p.Approved == null || p.Approved == false select p).Count();

                    lblGenerators.Text = Generators.ToString();
                    lblGeneratorsSetup.Text = GenPending.ToString();
                    lblSites.Text = Sites.ToString();
                    lblBlackboxes.Text = Blackboxes.ToString();

                    lblTotalUsers.Text = users.ToString();
                    lblUsersLockedOut.Text = usersLocked.ToString();
                    lblUsersOnline.Text = usersOnline.ToString();

                    lblColumn.Text = ComapColumns.ToString();
                    lblMapsPending.Text = PendingApprovals.ToString();

                }
            }
        }
    }
}