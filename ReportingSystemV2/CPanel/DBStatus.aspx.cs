using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.CPanel
{
    public partial class DBStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var DBStatus = (from s in RsDc.Update_Controls orderby s.ID descending select s).First();

                    lblDBStatus.Text = String.Format("{0:dd/MM/yyyy HH:mm:ss}", DBStatus.LastUpdate);
                }
            }
        }
    }
}