using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.IO;

namespace ReportingSystemV2
{
    public partial class SiteMaster : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;

        protected void Page_Init(object sender, EventArgs e)
        {
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;
        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check user has access
            // Get the users roles
            UserManager manager = new UserManager();
            var rm = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            CustomDataContext db = new CustomDataContext();

            

            if (!string.IsNullOrWhiteSpace(Context.User.Identity.Name))
            {
                // Get the current page
                string currentPage = Path.GetFileName(Request.PhysicalPath);
                string currentDirectory = Path.GetDirectoryName(Request.PhysicalPath).Split('\\').Last();

                if (!currentPage.Contains(".aspx") && !Directory.Exists("~/" + currentPage))
                {
                    currentPage = currentPage + ".aspx";
                }

                // Get user and assigned roles
                var userId = Context.User.Identity.GetUserId();
                var assignedRoles = manager.GetRoles(userId);

                // Get the user
                ApplicationUser u = manager.FindById(userId);

                // Update the users last time of activity
                u.LastActivity = DateTime.Now;
                manager.Update(u);

                // Check if the user has sites associated
                if (string.IsNullOrWhiteSpace(u.SiteAccessArray) && (currentPage != "CustomErrorMsg.aspx" || currentDirectory != "Admin"))
                {
                    Page.Title = "No Sites";
                    Response.Redirect("~/ErrorPages/CustomErrorMsg.aspx?m=" + "NoSites");
                    return;
                }

                // Get users role Ids
                var roleIdsList = new List<string> { };
                foreach (var role in assignedRoles)
                {
                    var r = rm.FindByName(role.ToString());
                    roleIdsList.Add(r.Id);
                }

                // Get the pages associated with the roles
                string[] assigned = db.GetPagesInRolesByIds(roleIdsList).Select(x => x.FilePageName).ToArray();
                var assigedLower = assigned.Select(s => s.ToLowerInvariant()).ToArray();

                if (Array.IndexOf(assigedLower, currentPage.ToLower()) < 0)
                {
                    Page.Title = "401";

                    Response.Redirect("~/ErrorPages/Page401.aspx?p=" + currentPage);
                    return;
                }

                // Should the user be trying to access this site
                if (Request.QueryString["id"] != null)
                {
                   if (!u.SiteAccessArray.Contains(Request.QueryString["id"]))
                   {
                       Page.Title = "Restricted Site";
                       Response.Redirect("~/ErrorPages/CustomErrorMsg.aspx?m=" + "SiteRestricted");
                       return;
                   }
                }

            }
        }

        protected void Unnamed_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Context.GetOwinContext().Authentication.SignOut();
        }

        protected void IsUserAdminOrSysAdmin()
        {
            UserManager manager = new UserManager();

            var assignedRoles = manager.GetRoles(Context.User.Identity.GetUserId());

            if (assignedRoles.Contains("Admin") || assignedRoles.Contains("SysAdmin") || assignedRoles.Contains("Gravity"))
            {
               
            }
            else
            {
                
            }
        }

    }

}