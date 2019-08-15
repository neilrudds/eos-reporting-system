using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class ContractTypes : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindContractTypes();
            }   
        }

        protected void BindContractTypes()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                ContractTypesGrid.DataSource = (from s in RsDc.ContractTypes orderby s.Contract_Type select s);
                ContractTypesGrid.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (ContractTypesGrid.Rows.Count > 0)
            {
                // CSS Header Sytle
                ContractTypesGrid.UseAccessibleHeader = true;
                ContractTypesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void lbAddContractType_Click(object sender, EventArgs e)
        {
            tbContractType.Text = "";

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addContractModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddContractModalScript", sb.ToString(), false);
        }

        protected void ContractTypesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int ContractId = Convert.ToInt32(ContractTypesGrid.DataKeys[index].Value);

            if (e.CommandName == "DeleteContract")
            {
                DeleteContract_alert_placeholder.InnerHtml = "";
                hf_ContractTypeId_Delete.Value = ContractId.ToString();

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteContractModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteContractModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditContract")
            {
                EditContract_alert_placeholder.InnerHtml = "";
                hf_ContractTypeId_Edit.Value = ContractId.ToString();

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var contractType = (from s in RsDc.ContractTypes where s.ID == ContractId select s).SingleOrDefault();

                    if (contractType != null)
                    {
                        tbEditContractType.Text = contractType.Contract_Type;
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editContractModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditContractModalScript", sb.ToString(), false);

            }
        }

        protected void btnAddContractType_Click(object sender, EventArgs e)
        {
            AddContract_alert_placeholder.InnerHtml = "";

            if (tbContractType.Text != "")
            {
                if (db.updateOrInsertContractType(tbContractType.Text))
                {
                    AddContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The contract type has been saved!");
                    LogMe.LogUserMessage(string.Format("Contract type created, Type: {0}", tbContractType.Text));
                    BindContractTypes();
                }
                else
                {
                    AddContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The contract type could not be saved, please try again!");
                }
            }
            else
            {
                AddContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The contract type must be populated, please try again!");
            }
        }

        protected void btnEditContract_Click(object sender, EventArgs e)
        {
            EditContract_alert_placeholder.InnerHtml = "";

            if (tbEditContractType.Text != "")
            {
                if (db.updateOrInsertContractType(tbEditContractType.Text, Convert.ToInt32(hf_ContractTypeId_Edit.Value)))
                {
                    EditContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The contract type has been updated!");
                    LogMe.LogUserMessage(string.Format("Contract type modified, Id: {0}", Convert.ToInt32(hf_ContractTypeId_Edit.Value)));
                    BindContractTypes();
                }
                else
                {
                    EditContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The contract type could not be updated, please try again!");
                }
            }
            else
            {
                EditContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The contract type must be populated, please try again!");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (db.deleteContractType(Convert.ToInt32(hf_ContractTypeId_Delete.Value)))
            {
                DeleteContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The contract type has been deleted!");
                LogMe.LogUserMessage(string.Format("Gas type deleted, Id: {0}", Convert.ToInt32(hf_ContractTypeId_Delete.Value)));
                BindContractTypes();
            }
            else
            {
                DeleteContract_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the contract type, please ensure that it is not in use and try again!");
            }
        }
    }
}