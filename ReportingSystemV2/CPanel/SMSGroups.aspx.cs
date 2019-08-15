using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.CPanel
{
    public partial class SMSGroups : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bindSMSGroups();                   
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (gridSMSGroups.Rows.Count > 0)
            {
                // CSS Header Sytle
                gridSMSGroups.UseAccessibleHeader = true;
                gridSMSGroups.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void bindSMSGroups()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                gridSMSGroups.DataSource = (from s in RsDc.sms_Mappings orderby s.SMS_Group select s);
                gridSMSGroups.DataBind();
            }
        }

        protected void gridSMSGroups_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int SMSGroupId = Convert.ToInt32(gridSMSGroups.DataKeys[index].Value);

            if (e.CommandName == "DeleteSMSGroup" && Shared.canUserAccessFunction("SMSDeleteGroup"))
            {
                // Assign User Id
                hf_SMSGroupId_Delete.Value = SMSGroupId.ToString();

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditSMSGroup" && Shared.canUserAccessFunction("SMSEditGroup"))
            {
                // Assign User Id
                hf_SMSGroupId_Edit.Value = SMSGroupId.ToString();

                // Get current vals
                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var SMSGroup = (from s in RsDc.sms_Mappings where s.id == SMSGroupId select s).SingleOrDefault();

                    if (SMSGroup != null)
                    {
                        tbSMSGroupName.Text = SMSGroup.SMS_Group.ToString();
                        tbSMSGroupRec.Text = SMSGroup.SMS_Recipient.ToString();
                    }
                    else
                    {
                        tbSMSGroupName.Text = "";
                        tbSMSGroupRec.Text = "";
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditModalScript", sb.ToString(), false);
            }

        }

        protected void btnAddSMSGroup_Click(object sender, EventArgs e)
        {
            if (db.insertSMSGroup(tbNewSMSGroupName.Text, tbNewSMSGroupRec.Text))
            {
                AddSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The sms group has been created!");
                LogMe.LogUserMessage(string.Format("A new SMS group has been created. Group name:{0}, Recipient:{1}", tbNewSMSGroupName.Text, tbNewSMSGroupRec.Text));
            }
            else
            {
                AddSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The sms group could not be created, please try again!");
            }
            bindSMSGroups();
        }

        protected void lbAddSMSGroup_Click(object sender, EventArgs e)
        {
            if (Shared.canUserAccessFunction("SMSAddGroup"))
            {
                tbNewSMSGroupName.Text = "";
                tbNewSMSGroupRec.Text = "";

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#addSMSModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddSMSModalScript", sb.ToString(), false);
            }
        }

        protected void SaveSMSGroupDetails_Click(object sender, EventArgs e)
        {
            EditSMSGroup_alert_placeholder.InnerHtml = "";
            int SMSGroupId = Convert.ToInt32(hf_SMSGroupId_Edit.Value);

            if (db.updateSMSGroup(SMSGroupId, tbSMSGroupName.Text, tbSMSGroupRec.Text))
            {
                EditSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The sms group has been updated!");
                LogMe.LogUserMessage(string.Format("SMS Group Id:{0} has been updated. Group name:{1}, Recipient:{2}", SMSGroupId, tbSMSGroupName.Text, tbSMSGroupRec.Text));
                bindSMSGroups();
            }
            else
            {
                EditSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The sms group could not be updated, please try again!");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            DeleteSMSGroup_alert_placeholder.InnerHtml = "";
            int SMSGroupId = Convert.ToInt32(hf_SMSGroupId_Delete.Value);

            if (!db.isSMSGroupInUse(SMSGroupId))
            {
                // Not in use, ok to delete
                if (db.deleteSMSGroup(SMSGroupId))
                {
                    // Deleted
                    DeleteSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The sms group has been deleted!");
                    LogMe.LogUserMessage(string.Format("SMS Group Id:{0} has been deleted.", SMSGroupId));
                    bindSMSGroups();
                }
                else
                {
                    // Failed to delete
                    DeleteSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the sms group, please try again!");
                }
            }
            else
            {
                // Group in use, cannot delete
                DeleteSMSGroup_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "You cannot delete the sms group as it is in use!");
                LogMe.LogUserMessage(string.Format("SMS Group Id:{0} could not be deleted as it is in use.", SMSGroupId));

            }
        }
    }
}