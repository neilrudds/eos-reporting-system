using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.ErrorPages
{
    public partial class CustomErrorMsg : System.Web.UI.Page
    {
        protected string HeaderMsg
        {
            get;
            private set;
        }

        protected string Message
        {
            get;
            private set;
        }

        protected string PageTitle
        {
            get;
            private set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Render Page Name
            var message = Request.QueryString["m"];
            if (message != null)
            {
                // Strip the query string from action
                Form.Action = ResolveUrl("~/ErrorPages/CustomErrorMsg");
                Message =
                       message == "NoSites" ? "Sorry, your account does not have any associated sites. Please contact the administrator."
                       : message == "SiteRestricted" ? "Sorry, you do not have access to this site. Please contact the administrator."
                       : message == "AccountLockedout" ? "Your account has been locked out. Please try again later. If this is a new account, then you must wait for a system administrator to verify your account."
                       : String.Empty;

                HeaderMsg =
                       message == "NoSites" ? "No Sites."
                       : message == "SiteRestricted" ? "Restricted Site."
                       : message == "AccountLockedout" ? "Account Locked Out."
                       : String.Empty;

                Msg.Visible = !String.IsNullOrEmpty(Message);
                MsgHeader.Visible = !String.IsNullOrEmpty(HeaderMsg);
            }
        }
    }
}