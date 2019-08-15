using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;

namespace ReportingSystemV2.Account
{
    public partial class Confirm : System.Web.UI.Page
    {
        protected string StatusMessage
        {
            get;
            private set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string code = IdentityHelper.GetCodeFromRequest(Request);
            string userId = IdentityHelper.GetUserIdFromRequest(Request);
            
            if (code != null && userId != null)
            {
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                //var provider = new DpapiDataProtectionProvider("ReportingSystemV2");
                //manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(provider.Create("UserToken"));
                var result = manager.ConfirmEmailAsync(userId, code);
                if (result.Result.Succeeded)
                {
                    successPanel.Visible = true;
                    return;
                }
            }
            successPanel.Visible = false;
            errorPanel.Visible = true;
        }
    }
}