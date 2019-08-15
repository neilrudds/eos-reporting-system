using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class History_Mapping : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bindMapping();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (gridHistoryMap.Rows.Count > 0)
            {
                // CSS Header Sytle
                gridHistoryMap.UseAccessibleHeader = true;
                gridHistoryMap.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void bindMapping()
        {
            using (CustomDataContext CdC = new CustomDataContext())
            {
                gridHistoryMap.DataSource = CdC.ed_ComapWildcard_Get();
                gridHistoryMap.DataBind();
            }
        }

        protected void ddlHeaderName_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Applies the values selected in the Map DDL to the database value
            DropDownList ddl = (DropDownList)sender;
            GridViewRow gvrow = (GridViewRow)ddl.NamingContainer;
            DB db = new DB();

            int MapId = int.Parse(gridHistoryMap.DataKeys[gvrow.RowIndex].Value.ToString());

            if (db.updateMapHeaderId(MapId, Convert.ToInt32(ddl.SelectedValue)))
            {
                LogMe.LogUserMessage(string.Format("Column Map Id:{0}, has been mapped to header Id:{1} ({2}).", MapId, Convert.ToInt32(ddl.SelectedValue), ddl.SelectedItem.Text));
            }

            bindMapping();
        }

        protected void chkLock_CheckedChanged(object sender, EventArgs e)
        {
            // When the approved checkbox is changed, update the Db
            CheckBox chk = (CheckBox)sender;
            GridViewRow gvrow = (GridViewRow)chk.NamingContainer;

            DB db = new DB();

            int MapId = int.Parse(gridHistoryMap.DataKeys[gvrow.RowIndex].Value.ToString());

            if (db.updateMapApprovedFlag(MapId, chk.Checked))
            {
                if (chk.Checked)
                {
                    LogMe.LogUserMessage(string.Format("Column Map Id:{0}, has been approved.", MapId));
                }
                else
                {
                    LogMe.LogUserMessage(string.Format("Column Map Id:{0}, has been un-approved.", MapId));
                }
            }

            bindMapping();
        }

    }
}