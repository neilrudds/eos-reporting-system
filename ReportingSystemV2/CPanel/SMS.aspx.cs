using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2.CPanel
{
    public partial class SMS : System.Web.UI.Page
    {
        UserSites userSites = new UserSites();
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    gridSMSSites.DataSource = (from s in RsDc.HL_Locations orderby s.GENSETNAME select s)
                        .Where(t => userSites.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));
                    gridSMSSites.DataBind();                    
                }
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (gridSMSSites.Rows.Count > 0)
            {
                // CSS Header Sytle
                gridSMSSites.UseAccessibleHeader = true;
                gridSMSSites.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void ddlSMSGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow gvr = (GridViewRow)ddl.NamingContainer;
            int LocationId = (int)gridSMSSites.DataKeys[gvr.RowIndex].Value;

            int? SMSGroupId = null;
            if (ddl.SelectedValue != "")
            {
                SMSGroupId = Convert.ToInt32(ddl.SelectedValue);
            }

            // Update
            if (Shared.canUserAccessFunction("SMSEditGeneratorGroup"))
            {
                if (db.updateSMSGroupId(LocationId, SMSGroupId))
                {
                    alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The site sms group has been sucessfully updated.");
                    LogMe.LogUserMessage(string.Format("Generator Id:{0} SMS group has been updated to:{1} ({2}).", LocationId, SMSGroupId, ddl.SelectedItem.Text));
                }
                else
                {
                    alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "The site sms group could not be updated, Please try again!");
                }
            }
        }

        protected void gridUserSites_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    //Populate all dropdown lists
                    DropDownList ddl = (DropDownList)e.Row.Cells[0].FindControl("ddlSMSGroup");

                    ddl.DataSource = (from s in RsDc.sms_Mappings select s);
                    ddl.DataTextField = "SMS_Group";
                    ddl.DataValueField = "id";
                    ddl.DataBind();

                    //And add a default when value is NULL
                    ddl.Items.Insert(0, new ListItem("Please Select", "", true));

                    ddl.Items.FindByValue((e.Row.FindControl("lblSMSGroup") as Label).Text).Selected = true;
                }
            }
        }
    }
}