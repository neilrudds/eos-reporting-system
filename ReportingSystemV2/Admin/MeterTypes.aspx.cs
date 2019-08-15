using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class MeterTypes : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindMeterTypes();
            }                                 
        }

        protected void BindMeterTypes()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var EnergyMeters = from s in RsDc.EnergyMeters_Types
                                   select new 
                                   {
                                       Id = s.id,
                                       Meter_Type = s.Meter_Type,
                                       Meter_Category = (from x in RsDc.EnergyMeters_Types_Categories where x.Id == s.Meter_Category select x.Category_Name).SingleOrDefault().ToString()
                                   };

                MeterTypesGrid.DataSource = EnergyMeters.OrderBy(x => x.Meter_Type);
                MeterTypesGrid.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (MeterTypesGrid.Rows.Count > 0)
            {
                // CSS Header Sytle
                MeterTypesGrid.UseAccessibleHeader = true;
                MeterTypesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void lbAddMeterType_Click(object sender, EventArgs e)
        {
            tbMeterType.Text = "";

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {

                var Categories = (from x in RsDc.EnergyMeters_Types_Categories select x).ToList();

                ddlAddCategory.DataSource = Categories.OrderBy(x => x.Category_Name);
                ddlAddCategory.DataTextField = "Category_Name";
                ddlAddCategory.DataValueField = "Id";
                ddlAddCategory.DataBind();

                //And add a default when value is NULL
                ddlAddCategory.Items.Insert(0, new ListItem("Please Select", "", true));
            }

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addMeterModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddMeterModalScript", sb.ToString(), false);
        }

        protected void MeterTypesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int MeterId = Convert.ToInt32(MeterTypesGrid.DataKeys[index].Value);

            if (e.CommandName == "DeleteMeter")
            {
                DeleteMeter_alert_placeholder.InnerHtml = "";
                hf_MeterTypeId_Delete.Value = MeterId.ToString();

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deleteMeterModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteMeterModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditMeter")
            {
                EditMeter_alert_placeholder.InnerHtml = "";
                hf_MeterTypeId_Edit.Value = MeterId.ToString();

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var meterType = (from s in RsDc.EnergyMeters_Types where s.id == MeterId select s).SingleOrDefault();

                    if (meterType != null)
                    {
                        tbEditMeterType.Text = meterType.Meter_Type;

                        ddlEditCategory.DataSource = (from y in RsDc.EnergyMeters_Types_Categories select y);
                        ddlEditCategory.DataTextField = "Category_Name";
                        ddlEditCategory.DataValueField = "Id";
                        ddlEditCategory.DataBind();

                        //And add a default when value is NULL
                        ddlAddCategory.Items.Insert(0, new ListItem("Please Select", "", true));

                        ddlEditCategory.SelectedValue = meterType.Meter_Category.ToString();
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editMeterModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditMeterModalScript", sb.ToString(), false);

            }
        }

        protected void btnAddMeterType_Click(object sender, EventArgs e)
        {
            AddMeter_alert_placeholder.InnerHtml = "";

            if (tbMeterType.Text != "")
            {
                if (db.updateOrInsertMeterType(tbMeterType.Text, Convert.ToInt32(ddlAddCategory.SelectedValue)))
                {
                    AddMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The meter type has been saved!");
                    LogMe.LogUserMessage(string.Format("Meter type created, Type: {0}", tbMeterType.Text));
                    BindMeterTypes();
                }
                else
                {
                    AddMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter type could not be saved, please try again!");
                }
            }
            else
            {
                AddMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter type must be populated, please try again!");
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (db.deleteMeterType(Convert.ToInt32(hf_MeterTypeId_Delete.Value)))
            {
                DeleteMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The meter type has been deleted!");
                LogMe.LogUserMessage(string.Format("Meter type deleted, Id: {0}", Convert.ToInt32(hf_MeterTypeId_Delete.Value)));
                BindMeterTypes();
            }
            else
            {
                DeleteMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the meter type, please ensure that it is not in use and try again!");
            }
        }

        protected void btnEditMeter_Click(object sender, EventArgs e)
        {
            EditMeter_alert_placeholder.InnerHtml = "";

            if (tbEditMeterType.Text != "")
            {
                if (db.updateOrInsertMeterType(tbEditMeterType.Text, Convert.ToInt32(ddlEditCategory.SelectedValue), Convert.ToInt32(hf_MeterTypeId_Edit.Value)))
                {
                    EditMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The meter type has been updated!");
                    LogMe.LogUserMessage(string.Format("Meter type modified, Id: {0}, Category Id: {1}", Convert.ToInt32(hf_MeterTypeId_Edit.Value), Convert.ToInt32(ddlEditCategory.SelectedValue)));
                    BindMeterTypes();
                }
                else
                {
                    EditMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter type could not be updated, please try again!");
                }
            }
            else
            {
                EditMeter_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The meter type must be populated, please try again!");
            }
        }
    }
}