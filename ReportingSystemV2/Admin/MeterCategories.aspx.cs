using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class MeterCategories : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindMeterCategories();
            }        
        }

        protected void BindMeterCategories()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                MeterCategoriesGrid.DataSource = (from s in RsDc.EnergyMeters_Types_Categories orderby s.Category_Name select s);
                MeterCategoriesGrid.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (MeterCategoriesGrid.Rows.Count > 0)
            {
                // CSS Header Sytle
                MeterCategoriesGrid.UseAccessibleHeader = true;
                MeterCategoriesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void lbAddMeterCat_Click(object sender, EventArgs e)
        {
            tbMeterCategory.Text = "";

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addMeterCatModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddMeterCatModalScript", sb.ToString(), false);
        }

        protected void MeterCategoriesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int CatId = Convert.ToInt32(MeterCategoriesGrid.DataKeys[index].Value);

            if (e.CommandName == "DeleteMeterCat")
            {
                DeleteMeterCat_alert_placeholder.InnerHtml = "";
                hf_MeterCatId_Delete.Value = CatId.ToString();

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteMeterCatModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteMeterCatModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditMeterCat")
            {
                EditMeterCat_alert_placeholder.InnerHtml = "";
                hf_MeterCatId_Edit.Value = CatId.ToString();

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var meterCat = (from s in RsDc.EnergyMeters_Types_Categories where s.Id == CatId select s).SingleOrDefault();

                    if (meterCat != null)
                    {
                        tbEditMeterCategory.Text = meterCat.Category_Name;
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editMeterCatModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditMeterCatModalScript", sb.ToString(), false);

            }
        }

        protected void btnAddMeterCategory_Click(object sender, EventArgs e)
        {
            AddMeterCat_alert_placeholder.InnerHtml = "";

            if (tbMeterCategory.Text != "")
            {
                if (db.updateOrInsertMeterCategory(tbMeterCategory.Text))
                {
                    AddMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The meter category has been saved!");
                    LogMe.LogUserMessage(string.Format("Meter category created, Type: {0}", tbMeterCategory.Text));
                    BindMeterCategories();
                }
                else
                {
                    AddMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter category could not be saved, please try again!");
                }
            }
            else
            {
                AddMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter category name must be populated, please try again!");
            }
        }

        protected void btnEditMeterCategory_Click(object sender, EventArgs e)
        {
            EditMeterCat_alert_placeholder.InnerHtml = "";

            if (tbEditMeterCategory.Text != "")
            {
                if (db.updateOrInsertMeterCategory(tbEditMeterCategory.Text, Convert.ToInt32(hf_MeterCatId_Edit.Value)))
                {
                    EditMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The meter category has been updated!");
                    LogMe.LogUserMessage(string.Format("Meter category modified, Id: {0}", Convert.ToInt32(hf_MeterCatId_Edit.Value)));
                    BindMeterCategories();
                }
                else
                {
                    EditMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter category could not be updated, please try again!");
                }
            }
            else
            {
                EditMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter category must be populated, please try again!");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (db.deleteMeterCategory(Convert.ToInt32(hf_MeterCatId_Delete.Value)))
            {
                DeleteMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The meter category has been deleted!");
                LogMe.LogUserMessage(string.Format("Meter category deleted, Id: {0}", Convert.ToInt32(hf_MeterCatId_Delete.Value)));
                BindMeterCategories();
            }
            else
            {
                DeleteMeterCat_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the meter category, please ensure that it is not in use and try again!");
            }
        }
    }
}