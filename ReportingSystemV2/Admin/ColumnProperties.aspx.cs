using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class ColumnSchema : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindColumnProperties();

                // Handle checkbox clicks
                chkAddIsAvailableInReports.Attributes.Add("onclick", "return radioMe(event)");
                chkAddIsCumulativePlot.Attributes.Add("onclick", "return radioMe(event)");

                chkEditIsAvailableInReports.Attributes.Add("onclick", "return radioMe(event)");
                chkEditIsCumulativePlot.Attributes.Add("onclick", "return radioMe(event)");
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // CSS Header Sytle
            if (ColumnPropertiesGrid.Rows.Count > 0)
            {
                ColumnPropertiesGrid.UseAccessibleHeader = true;
                ColumnPropertiesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void BindColumnProperties()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var Columns = (from s in RsDc.ColumnNames
                               select new
                               {
                                   HeaderId = s.HeaderId,
                                   ColumnName = (from l in RsDc.ComAp_Headers where l.id == s.HeaderId select l.History_Header).FirstOrDefault().ToString(),
                                   ColumnLabel = s.ColumnLabel,
                                   IsInstantaneousPlot = s.IsInstantaneousPlot,
                                   IsCumulativePlot = s.IsCumulativePlot,
                                   IsAvailableInReports = s.IsAvailableInReports,
                                   ColumnUnits = s.ColumnUnits,
                                   ColumnHtmlColor = s.ColumnHtmlColor
                               });

                ColumnPropertiesGrid.DataSource = Columns.OrderBy(x => x.ColumnName);
                ColumnPropertiesGrid.DataBind();
            }
        }

        protected void ColumnPropertiesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            int PropertyHeaderId = Convert.ToInt32(ColumnPropertiesGrid.DataKeys[index].Value);

            if (e.CommandName == "DeleteProperty")
            {
                // Assign Id
                hf_HeaderId_Delete.Value = PropertyHeaderId.ToString();
                DeleteProperty_alert_placeholder.InnerHtml = "";

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#deletePropertyModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "DeleteModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "EditProperty")
            {
                // Assign Id
                hf_HeaderId_Edit.Value = PropertyHeaderId.ToString();
                EditProperty_alert_placeholder.InnerHtml = "";

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var CurrentProperty = (from s in RsDc.ColumnNames where s.HeaderId == PropertyHeaderId select s).FirstOrDefault();

                    if (CurrentProperty != null)
                    {
                        ddlEditColumnName.DataSource = (from y in RsDc.ComAp_Headers select y);
                        ddlEditColumnName.DataTextField = "History_Header";
                        ddlEditColumnName.DataValueField = "id";
                        ddlEditColumnName.DataBind();

                        ddlEditColumnName.SelectedValue = CurrentProperty.HeaderId.ToString();
                        tbEditColumnLabel.Text = CurrentProperty.ColumnLabel;

                        if (CurrentProperty.IsInstantaneousPlot == true) { chkEditIsInstantaneousPlot.Checked = true; } else { chkEditIsInstantaneousPlot.Checked = false; }
                        if (CurrentProperty.IsCumulativePlot == true) { chkEditIsCumulativePlot.Checked = true; } else { chkEditIsCumulativePlot.Checked = false; }
                        if (CurrentProperty.IsAvailableInReports == true) { chkEditIsAvailableInReports.Checked = true; } else { chkEditIsAvailableInReports.Checked = false; }
  
                        tbEditColumnUnits.Text = CurrentProperty.ColumnUnits;
                        tbEditColumnHTMLColor.Text = CurrentProperty.ColumnHtmlColor;
                    }
                }

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#editPropertyModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditModalScript", sb.ToString(), false);
            }
        }

        protected void lbAddProperty_Click(object sender, EventArgs e)
        {
            tbColumnLabel.Text = "";
            tbColumnHTMLColor.Text = "";
            tbColumnUnits.Text = "";
            chkAddIsInstantaneousPlot.Checked = false;
            chkAddIsCumulativePlot.Checked = false;
            chkAddIsAvailableInReports.Checked = false;

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {

                var CurrentlyInUse = (from x in RsDc.ColumnNames select x.HeaderId).ToList();
                var All = (from y in RsDc.ComAp_Headers select y);

                ddlColumnName.DataSource = All.Where(f => !CurrentlyInUse.Contains(f.id) && f.id != 1 && f.id != 2 && f.id != 3).OrderBy(x => x.History_Header); // Not reason, date, time
                ddlColumnName.DataTextField = "History_Header";
                ddlColumnName.DataValueField = "id";
                ddlColumnName.DataBind();

                //And add a default when value is NULL
                ddlColumnName.Items.Insert(0, new ListItem("Please Select", "", true));
            }

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#addPropertyModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "AddPropertyModalScript", sb.ToString(), false);
        }

        protected void btnAddPropertyGroup_Click(object sender, EventArgs e)
        {
            AddProperty_alert_placeholder.InnerHtml = "";
            
            if (ddlColumnName.SelectedValue != "")
            {
                if ((chkAddIsInstantaneousPlot.Checked && !chkAddIsCumulativePlot.Checked) || (!chkAddIsInstantaneousPlot.Checked && chkAddIsCumulativePlot.Checked))
                {
                    if (db.updateOrInsertColumnProperty(Convert.ToInt32(ddlColumnName.SelectedValue), tbColumnLabel.Text, chkAddIsInstantaneousPlot.Checked, chkAddIsCumulativePlot.Checked, chkAddIsAvailableInReports.Checked, tbColumnUnits.Text, tbColumnHTMLColor.Text))
                    {
                        AddProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The column property has been saved!");
                        LogMe.LogUserMessage(string.Format("Column header properties Id: {0} saved.", Convert.ToInt32(hf_HeaderId_Edit.Value)));
                        BindColumnProperties();
                    }
                    else
                    {
                        AddProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The column property could not be saved, please try again!");
                    }
                }
                else
                {
                    AddProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "You must select only one plot type!");
                }
            }
            else
            {
                AddProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "You must select a column header name!");
            }
        }

        protected void ColumnPropertiesGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Highlight html colors in there color
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[6].Text != "")
                {
                    try
                    {
                        System.Drawing.Color col = System.Drawing.ColorTranslator.FromHtml(e.Row.Cells[6].Text);

                        e.Row.Cells[6].ForeColor = col;
                    }
                    catch
                    {
                        // Who cares, I tried.
                    }
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            DeleteProperty_alert_placeholder.InnerHtml = "";
            int PropertyHeaderId = Convert.ToInt32(hf_HeaderId_Delete.Value);

            if (db.deleteColumnProperties(PropertyHeaderId))
            {
                // Deleted
                DeleteProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The column properties have been deleted!");
                LogMe.LogUserMessage(string.Format("Column header properties Id: {0} deleted.", PropertyHeaderId));
                BindColumnProperties();
            }
            else
            {
                // Failed to delete
                DeleteProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "Unable to delete the columns properties, please try again!");
            }
        }

        protected void btnEditProperty_Click(object sender, EventArgs e)
        {
            if ((chkEditIsInstantaneousPlot.Checked && !chkEditIsCumulativePlot.Checked) || (!chkEditIsInstantaneousPlot.Checked && chkEditIsCumulativePlot.Checked))
            {
                if (db.updateOrInsertColumnProperty(Convert.ToInt32(hf_HeaderId_Edit.Value), tbEditColumnLabel.Text, chkEditIsInstantaneousPlot.Checked, chkEditIsCumulativePlot.Checked, chkEditIsAvailableInReports.Checked, tbEditColumnUnits.Text, tbEditColumnHTMLColor.Text))
                {
                    EditProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The column property has been updated!");
                    LogMe.LogUserMessage(string.Format("Column header properties Id: {0} modified.", Convert.ToInt32(hf_HeaderId_Edit.Value)));
                    BindColumnProperties();
                }
                else
                {
                    EditProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The column property could not be updated, please try again!");
                }
            }
            else
            {
                EditProperty_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "You must select only one plot type!");
            }
        }
    }
}