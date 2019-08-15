using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class History_Config : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bindHeaders();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // CSS Header Sytle
            if (gridHistoryHeaders.Rows.Count > 0)
            {
                gridHistoryHeaders.UseAccessibleHeader = true;
                gridHistoryHeaders.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void bindHeaders()
        {
            CustomDataContext CdC = new CustomDataContext();
            gridHistoryHeaders.DataSource = CdC.ed_ComapHeaders_Get();
            gridHistoryHeaders.DataBind();
        }

        protected void lbAddHeader_Click(object sender, EventArgs e)
        {
            tbNewHeaderName.Text = "";
            tbNewHeaderDesc.Text = "";

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addHeaderModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddHeaderModalScript", sb.ToString(), false);
        }

        protected void btnAddHeader_Click(object sender, EventArgs e)
        {
            if (db.insertHistoryHeader(tbNewHeaderName.Text, tbNewHeaderDesc.Text))
            {
                AddHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The history header has been created!");
                LogMe.LogUserMessage(string.Format("A new history header has been created. Header name: {0}, Description: {1}", tbNewHeaderName.Text, tbNewHeaderDesc.Text));
            }
            else
            {
                AddHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The history header could not be created, please try again!");
            }

            bindHeaders();
        }

        protected void gridHistoryHeaders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int HistoryHeaderId = Convert.ToInt32(gridHistoryHeaders.DataKeys[index].Value);

            if (e.CommandName == "DeleteHeader")
            {
                // Assign User Id
                hf_HeaderId_Delete.Value = HistoryHeaderId.ToString();

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditHeader")
            {
                // Assign User Id
                hf_HeaderId_Edit.Value = HistoryHeaderId.ToString();

                // Get current vals
                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var header = (from s in RsDc.ComAp_Headers where s.id == HistoryHeaderId select s).SingleOrDefault();

                    if (header != null)
                    {
                        tbHeaderName.Text = header.History_Header.ToString();
                        tbHeaderDescription.Text = header.History_Description.ToString();
                    }
                    else
                    {
                        tbHeaderName.Text = "";
                        tbHeaderDescription.Text = "";
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

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            DeleteHeader_alert_placeholder.InnerHtml = "";
            int HeaderId = Convert.ToInt32(hf_HeaderId_Delete.Value);

            if (!db.isHistoryHeaderInUse(HeaderId))
            {
                // Not in use, ok to delete
                if (db.deleteHistoryHeader(HeaderId))
                {
                    // Deleted
                    DeleteHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The history header has been deleted!");
                    LogMe.LogUserMessage(string.Format("History Header Id: {0} has been deleted.", HeaderId));
                    bindHeaders();
                }
                else
                {
                    // Failed to delete
                    DeleteHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the history header, please try again!");
                }
            }
            else
            {
                // Group in use, cannot delete
                DeleteHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "You cannot delete the history header as it is in use!");
                LogMe.LogUserMessage(string.Format("History Header Id: {0} could not be deleted as it is in use.", HeaderId));

            }
        }

        protected void SaveEditHeaderDetails_Click(object sender, EventArgs e)
        {
            EditHistoryHeader_alert_placeholder.InnerHtml = "";
            int HeaderId = Convert.ToInt32(hf_HeaderId_Edit.Value);

            if (db.updateHistoryHeader(HeaderId, tbHeaderName.Text, tbHeaderDescription.Text))
            {
                EditHistoryHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The sms group has been updated!");
                LogMe.LogUserMessage(string.Format("History Header Id: {0} has been updated. Name: {1}, Description: {2}", HeaderId, tbHeaderName.Text, tbHeaderDescription.Text));
                bindHeaders();
            }
            else
            {
                EditHistoryHeader_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The history header could not be updated, please try again!");
                LogMe.LogUserMessage(string.Format("History Header Id: {0} could not be updated. Name: {1}, Description: {2}", HeaderId, tbHeaderName.Text, tbHeaderDescription.Text));
            }
        }
    }
}