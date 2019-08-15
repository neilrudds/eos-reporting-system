using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class GasTypes : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGasTypes();
            }   
        }

        protected void BindGasTypes()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                GasTypesGrid.DataSource = (from s in RsDc.GasTypes orderby s.Gas_Type select s);
                GasTypesGrid.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (GasTypesGrid.Rows.Count > 0)
            {
                //CSS Header Sytle
                GasTypesGrid.UseAccessibleHeader = true;
                GasTypesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void lbAddGasType_Click(object sender, EventArgs e)
        {
            tbGasType.Text = "";

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addGasModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddGasModalScript", sb.ToString(), false);
        }

        protected void GasTypesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int GasId = Convert.ToInt32(GasTypesGrid.DataKeys[index].Value);

            if (e.CommandName == "DeleteGas")
            {
                DeleteGas_alert_placeholder.InnerHtml = "";
                hf_GasTypeId_Delete.Value = GasId.ToString();

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteGasModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteGasModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditGas")
            {
                EditGas_alert_placeholder.InnerHtml = "";
                hf_GasTypeId_Edit.Value = GasId.ToString();

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var gasType = (from s in RsDc.GasTypes where s.ID == GasId select s).SingleOrDefault();

                    if (gasType != null)
                    {
                        tbEditGasType.Text = gasType.Gas_Type;
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editGasModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditGasModalScript", sb.ToString(), false);

            }
        }

        protected void btnAddGasType_Click(object sender, EventArgs e)
        {
            AddGas_alert_placeholder.InnerHtml = "";

            if (tbGasType.Text != "")
            {
                if (db.updateOrInsertGasType(tbGasType.Text))
                {
                    AddGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The gas type has been saved!");
                    LogMe.LogUserMessage(string.Format("Gas type created, Type: {0}", tbGasType.Text));
                    BindGasTypes();
                }
                else
                {
                    AddGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The gas type could not be saved, please try again!");
                }
            }
            else
            {
                AddGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The gas type must be populated, please try again!");
            }
        }

        protected void btnEditGas_Click(object sender, EventArgs e)
        {
            EditGas_alert_placeholder.InnerHtml = "";

            if (tbEditGasType.Text != "")
            {
                if (db.updateOrInsertGasType(tbEditGasType.Text, Convert.ToInt32(hf_GasTypeId_Edit.Value)))
                {
                    EditGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The gas type has been updated!");
                    LogMe.LogUserMessage(string.Format("Gas type modified, Id: {0}", Convert.ToInt32(hf_GasTypeId_Edit.Value)));
                    BindGasTypes();
                }
                else
                {
                    EditGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The gas type could not be updated, please try again!");
                }
            }
            else
            {
                EditGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The gas type must be populated, please try again!");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (db.deleteGasType(Convert.ToInt32(hf_GasTypeId_Delete.Value)))
            {
                DeleteGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The gas type has been deleted!");
                LogMe.LogUserMessage(string.Format("Gas type deleted, Id: {0}", Convert.ToInt32(hf_GasTypeId_Delete.Value)));
                BindGasTypes();
            }
            else
            {
                DeleteGas_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the gas type, please ensure that it is not in use and try again!");
            }
        }
    }
}