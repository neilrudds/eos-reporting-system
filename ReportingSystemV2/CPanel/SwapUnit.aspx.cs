using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.CPanel
{
    public partial class SwapUnit : System.Web.UI.Page
    {
        CustomDataContext db = new CustomDataContext();
         
        protected void Page_Load(object sender, EventArgs e)
        {
            BindSiteNames();
        }

        protected void BindSiteNames()
        {
            using (db)
            {
                //bind to unique sites to droplist
                ddlExistingSites.DataSource = from p in db.GetTable<HL_Location>()
                                              orderby p.SITENAME
                                              group p by p.SITENAME into uniqueSites
                                              select uniqueSites.FirstOrDefault();

                ddlExistingSites.DataTextField = "SITENAME";
                ddlExistingSites.DataValueField = "ID";
                ddlExistingSites.DataBind();
                ddlExistingSites.Items.Insert(0, new ListItem("Please Select", "-1"));
            }
        }

        #region UI Updates

        protected void ddlExistingSites_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            if (ddl.SelectedIndex != 0)
            {
                tbExistingSerial.Text = (from p in db.HL_Locations
                                         where p.ID == Convert.ToInt32(ddl.SelectedValue)
                                         select p.BLACKBOX_SN).FirstOrDefault();
            }
        }

        #endregion
    }
}