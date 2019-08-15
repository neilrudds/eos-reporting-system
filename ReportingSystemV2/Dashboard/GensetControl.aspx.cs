using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2
{
    public partial class Genset : System.Web.UI.Page
    {
        ReportingSystemDataContext db = new ReportingSystemDataContext();

        public string GensetSerial;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"]);

                    GensetSerial = (from at in db.HL_Locations where at.ID == id select at).Select(a => a.GENSET_SN).Single();

                    lbl_subHeader.InnerHtml = "serial." + GensetSerial;

                    Page.DataBind();
                }
            }
        }
    }
}