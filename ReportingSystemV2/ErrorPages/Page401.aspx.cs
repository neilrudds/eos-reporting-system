using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2
{
    public partial class Page401 : System.Web.UI.Page
    {
        protected string PageAddress
        {
            get;
            private set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Render Page Name
            var message = Request.QueryString["p"];
            if (message != null)
            {
                // Strip the query string from action
                Form.Action = ResolveUrl("~/ErrorPages/Page401");

                PageAddress = message;
                pageAddress.Visible = !String.IsNullOrEmpty(PageAddress);
            }
        }
    }
}