using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class EngineTypes : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindEngines();
            }
        }

        protected void BindEngines()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                EngineTypesGrid.DataSource = (from s in RsDc.EngineTypes orderby s.Description select s);
                EngineTypesGrid.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // CSS Header Sytle
            if (EngineTypesGrid.Rows.Count > 0)
            {
                EngineTypesGrid.UseAccessibleHeader = true;
                EngineTypesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void lbAddEngineType_Click(object sender, EventArgs e)
        {
            AddEngine_alert_placeholder.InnerHtml = "";

            tbMake.Text = "";
            tbModel.Text = "";
            tbCylinders.Text = "";
            tbMaxOutput.Text = "";
            tbDescription.Text = "";

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addEngineModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddEngineModalScript", sb.ToString(), false);
        }

        protected void EngineTypesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int EngineId = Convert.ToInt32(EngineTypesGrid.DataKeys[index].Value);

            if (e.CommandName == "DeleteEngine")
            {
                hf_EngineId_Delete.Value = EngineId.ToString();
                DeleteEngine_alert_placeholder.InnerHtml = "";

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteEngineModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteModalScript", sb.ToString(), false);
            }
            if (e.CommandName == "EditEngine")
            {
                // Assign Id
                hf_EngineId_Edit.Value = EngineId.ToString();
                EditEngine_alert_placeholder.InnerHtml = "";

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var SelectedEngine = (from s in RsDc.EngineTypes where s.ID == EngineId select s).FirstOrDefault();

                    if (SelectedEngine != null)
                    {
                        tbEditMake.Text = SelectedEngine.Make.Trim();
                        tbEditModel.Text = SelectedEngine.Model.Trim();
                        tbEditCylinders.Text = SelectedEngine.Cylinders.ToString();
                        tbEditMaxOutput.Text = SelectedEngine.MaximumOutput.ToString();
                        tbEditDescription.Text = SelectedEngine.Description.Trim();
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editEngineModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditModalScript", sb.ToString(), false);
            }

        }

        protected void btnAddNewEngine_Click(object sender, EventArgs e)
        {
            if (db.updateOrInsertEngineType(tbMake.Text.Trim(), tbModel.Text.Trim(), Convert.ToInt32(tbCylinders.Text), Convert.ToInt32(tbMaxOutput.Text), tbDescription.Text.Trim()))
            {
                AddEngine_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The new engine model has been saved!");
                LogMe.LogUserMessage(string.Format("New engine model created, Description: {0}", tbDescription.Text));
                BindEngines();
            }
            else
            {
                AddEngine_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The new engine model could not be saved, please try again!");
            }
        }

        protected void btnEditEngine_Click(object sender, EventArgs e)
        {
            if (db.updateOrInsertEngineType(tbEditMake.Text, tbEditModel.Text, Convert.ToInt32(tbEditCylinders.Text), Convert.ToInt32(tbEditMaxOutput.Text), tbEditDescription.Text, Convert.ToInt32(hf_EngineId_Edit.Value)))
            {
                EditEngine_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The new engine model has been updated!");
                LogMe.LogUserMessage(string.Format("Engine model modified, Id: {0}", Convert.ToInt32(tbEditCylinders.Text)));
                BindEngines();
            }
            else
            {
                EditEngine_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The new engine model could not be updated, please try again!");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int EngineId = Convert.ToInt32(hf_EngineId_Delete.Value);

            if (db.deleteEngineType(EngineId))
            {
                // Deleted
                DeleteEngine_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The engine type has been deleted!");
                LogMe.LogUserMessage(string.Format("Engine model modified, Id: {0}", Convert.ToInt32(hf_EngineId_Delete.Value)));
                BindEngines();
            }
            else
            {
                // Failed to delete
                DeleteEngine_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the engine type, please try again!");
            }
        }
    }
}