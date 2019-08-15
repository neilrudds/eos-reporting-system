using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.CPanel
{
    public partial class ManageGenerators : System.Web.UI.Page
    {
        DB db = new DB();

        protected void Page_Load(object sender, EventArgs e)
        {
            GeneratorsGrid_DataBind();
        }

        protected void GeneratorsGrid_DataBind()
        {

            ReportingSystemDataContext db = new ReportingSystemDataContext();

            var query = from g in db.HL_Locations
                        orderby g.GENSETNAME
                        select new
                        {
                            Id = g.ID,
                            Generator = g.GENSETNAME,
                            Site = g.SITENAME,
                            Serial = g.GENSET_SN
                        };

            GeneratorsGrid.DataSource = query;
            GeneratorsGrid.DataBind();

            //CSS Header Sytle
            GeneratorsGrid.UseAccessibleHeader = true;
            GeneratorsGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void GeneratorsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            //GridViewRow row = (GridViewRow)GeneratorsGrid.Rows[index];
            int LocationId = Convert.ToInt32(GeneratorsGrid.DataKeys[index].Value);

            if (e.CommandName == "EditGenerator" && Shared.canUserAccessFunction("GeneratorEditUnit"))
            {
                populateGeneratorDetails(LocationId);
            }
            else if (e.CommandName == "EditContractInfo" && Shared.canUserAccessFunction("GeneratorEditContract"))
            {
                populateContract(LocationId);
            }
            else if (e.CommandName == "EditReportOptions" && Shared.canUserAccessFunction("GeneratorEditReport"))
            {
                populateReportOptions(LocationId);
            }
            else if (e.CommandName == "EditPerformance" && Shared.canUserAccessFunction("GeneratorEditPerformance"))
            {
                populatePerformance(LocationId);
            }
            else if (e.CommandName == "EditInsturments" && Shared.canUserAccessFunction("GeneratorEditMetering"))
            {
                populateInsturments(LocationId);
            }
            
        }

        #region Generator

        protected void populateGeneratorDetails(int IdLocation)
        {
            EditGeneratorModal_alert_placeholder.InnerHtml = "";
            hf_IdLocation_EditGenerator.Value = IdLocation.ToString();

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Generator Model
                ddlEngineModels.DataSource = from m in RsDc.GetTable<EngineType>()
                                             orderby m.Description
                                             select m;

                ddlEngineModels.DataTextField = "Description";
                ddlEngineModels.DataValueField = "ID";
                ddlEngineModels.DataBind();
                ddlEngineModels.Items.Insert(0, new ListItem("Please Select", "-1", true));

                // Generator Gas Type
                ddlGasTypes.DataSource = from g in RsDc.GetTable<GasType>()
                                             orderby g.Gas_Type
                                             select g;

                ddlGasTypes.DataTextField = "Gas_Type";
                ddlGasTypes.DataValueField = "ID";
                ddlGasTypes.DataBind();
                ddlGasTypes.Items.Insert(0, new ListItem("Please Select", "-1", true));

                // Site Name
                var site = (from g in RsDc.HL_Locations
                            where g.ID == IdLocation
                            select g).SingleOrDefault();

                // Gas Type
                var gas = (from s in RsDc.HL_Locations
                           join g in RsDc.GasTypes_Mappings on s.ID equals g.ID_Location
                           where s.ID == IdLocation
                           select g).FirstOrDefault();

                // Set Values
                if (site != null)
                {
                    lblGeneratorName.Text = site.GENSETNAME.ToString();
                    lblGeneratorSerial.Text = site.GENSET_SN.ToString();
                    tbGeneratorName.Text = site.GENSETNAME.ToString();
                    tbSiteName.Text = site.SITENAME.ToString();
                    
                    // Engine Model
                    if (site.ID_EngineType != null)
                    {
                        ddlEngineModels.SelectedValue = site.ID_EngineType.ToString();
                    }

                    // Gas Type
                    if (gas != null)
                    {
                        ddlGasTypes.SelectedValue = gas.ID_GasType.ToString();
                    }                  
                }

                // Site Location
                var location = (from l in RsDc.GensetLocations
                                where l.ID_Location == IdLocation
                                select l).SingleOrDefault();

                if (location != null)
                {
                    tbLocation.Text = location.Latitude.ToString() + "," + location.Longitude.ToString();
                    tbLocationDesc.Text = location.Description.ToString();
                }
                else
                {
                    tbLocation.Text = "";
                    tbLocationDesc.Text = "";
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Warning!", "The location data has not been defined!");
                }
            }

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#EditGeneratorModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditGeneratorModalScript", sb.ToString(), false);
        }

        protected void SaveGeneratorDetails_Click(object sender, EventArgs e)
        {
            // Update the site
            bool detailsOk = db.updateGeneratorDetails(Convert.ToInt32(hf_IdLocation_EditGenerator.Value), tbGeneratorName.Text, tbSiteName.Text);

            // Parse and update the location if present
            bool GeoOk = true;
            if (tbLocation.Text != "")
            {
                try
                {
                    string[] GeoLoc = tbLocation.Text.Split(',');
                    db.updateOrInsertGeneratorGeoLocation(Convert.ToInt32(hf_IdLocation_EditGenerator.Value), GeoLoc[0], GeoLoc[1], tbLocationDesc.Text);
                    if (detailsOk && GeoOk)
                    {
                        // Both updated ok
                        EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The site name and geographic location has been updated.");
                        LogMe.LogUserMessage(string.Format("Generator ID:{0}, Details updated. Genset name:{1}, Site name:{2}", hf_IdLocation_EditGenerator.Value, tbGeneratorName.Text, tbSiteName.Text));
                        LogMe.LogUserMessage(string.Format("Generator ID:{0}, Geo location updated. Lat:{1}, Lon:{2}, Description:{3}", hf_IdLocation_EditGenerator.Value, GeoLoc[0], GeoLoc[1], tbLocationDesc.Text));
                    }
                }
                catch
                {
                    GeoOk = false;
                    if (detailsOk)
                    {
                        // Error with Location
                        EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "The site name has been updated, however the geographic location could not be updated.");
                    }
                    else
                    {
                        // Error with both
                        EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "The site name and geographic location could not be updated.");
                    }
                }
            }
            else
            {
                if (detailsOk)
                {
                    // Generator Updated
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The site name only has been updated.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Details updated. Genset name:{1}, Site name:{2}", hf_IdLocation_EditGenerator.Value, tbGeneratorName.Text, tbSiteName.Text));
                }
                else
                {
                    // Error with Generator
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "The site name could not be updated.");
                }
            }
        }

        protected void ddlEngineModels_SelectedIndexChanged(object sender, EventArgs e)
        {
            DB db = new DB();
            DropDownList ddl = (DropDownList)sender;
            int Id_Location = Convert.ToInt32(hf_IdLocation_EditGenerator.Value);

            if (ddl.SelectedValue != "-1")
            {
                if (db.updateEngineType(Id_Location, Convert.ToInt32(ddl.SelectedValue)))
                {
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "Settings sucessfully updated.");
                    LogMe.LogUserMessage(string.Format("Generator Id: {0}, engine model updated. Description: {1}", Id_Location, ddl.SelectedItem.Text));
                }
                else
                {
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Unable to update the engine type, Please try again!");
                }
            }
            else
            {
                EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Unable to update the engine type, the selected item is not valid!");
            }
        }

        protected void ddlGasTypes_SelectedIndexChanged(object sender, EventArgs e)
        {
            DB db = new DB();
            DropDownList ddl = (DropDownList)sender;
            int Id_Location = Convert.ToInt32(hf_IdLocation_EditGenerator.Value);

            if (ddl.SelectedValue != "-1")
            {
                if (db.updateOrInsertGasType_Mapping(Id_Location, Convert.ToInt32(ddl.SelectedValue)))
                {
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "Settings sucessfully updated.");
                    LogMe.LogUserMessage(string.Format("Generator Id: {0}, gas type updated. Description: {1}", Id_Location, ddl.SelectedItem.Text));
                }
                else
                {
                    EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Unable to update the gas type, Please try again!");
                }
            }
            else
            {
                EditGeneratorModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Unable to update the gas type, the selected item is not valid!");
            }
        }

        #endregion

        #region Contract

        protected void populateContract(int IdLocation)
        {
            EditContractModal_alert_placeholder.InnerHtml = "";
            hf_IdLocation_EditContract.Value = IdLocation.ToString();

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Generator Gas Type
                ddlContractTypes.DataSource = from g in RsDc.GetTable<ContractType>()
                                         orderby g.Contract_Type
                                         select g;

                ddlContractTypes.DataTextField = "Contract_Type";
                ddlContractTypes.DataValueField = "ID";
                ddlContractTypes.DataBind();
                ddlContractTypes.Items.Insert(0, new ListItem("Please Select", "-1", true));

                var query = (from g in RsDc.HL_Locations
                             where g.ID == IdLocation
                             select g).SingleOrDefault();

                var contract = (from c in RsDc.ContractInformations
                                where c.ID == query.ID_ContractInformation
                                select c).SingleOrDefault();

                // Set Values
                if (query != null)
                {
                    lblContractGeneratorName.Text = query.GENSETNAME.ToString();
                    lblContractGeneratorSerial.Text = query.GENSET_SN.ToString();
                }

                if (contract != null)
                {
                    tbContractOutput.Text = contract.ContractOutput.ToString();
                    tbContractAvailability.Text = contract.ContractAvailability.ToString();
                    tbDutyCycle.Text = contract.DutyCycle.ToString();
                    tbStartDate.Text = String.Format("{0:dd/MM/yyyy}", contract.ContractStartDate);
                    tbContractLength.Text = contract.ContractLength.ToString();
                    tbInitalRunHrs.Text = contract.InitialRunHrs.ToString();
                    tbInitialkWh.Text = contract.InitialKwHours.ToString();

                    // Contract Type
                    if (contract.ID_ContractType != null)
                    {
                        ddlContractTypes.SelectedValue = contract.ID_ContractType.ToString();
                    }
                }
                else
                {
                    tbContractOutput.Text = "";
                    tbContractAvailability.Text = "";
                    tbDutyCycle.Text = "";
                    tbStartDate.Text = "";
                    tbContractLength.Text = "";
                    tbInitalRunHrs.Text = "";
                    tbInitialkWh.Text = "";

                    EditContractModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Warning!", "The contract settings have not been defined.");
                }
            }


            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#EditContractModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditContractModal", sb.ToString(), false);
        }

        protected void CusVal_tbStartDate_ServerValidate(object source, ServerValidateEventArgs args)
        {
            DateTime d;
            bool Valid = DateTime.TryParseExact(args.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out d);
            if (!Valid)
            {
                LogMe.LogSystemError(string.Format("Unable to parse the datetime value: {0}", args.Value));
            }
            args.IsValid = Valid;
        }

        protected void SaveContractInfo_Click(object sender, EventArgs e)
        {
            if (db.updateOrInsertContractInformation(Convert.ToInt32(hf_IdLocation_EditContract.Value), ddlContractTypes.SelectedValue, tbContractOutput.Text, tbContractAvailability.Text, tbDutyCycle.Text, tbStartDate.Text, tbContractLength.Text, tbInitalRunHrs.Text, tbInitialkWh.Text))
            {
                EditContractModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The contract information was sucessfully saved.");
                LogMe.LogUserMessage(string.Format("Generator ID:{0}, Contract updated. Type:{1}, Output:{2}, Aval:{3}, Duty Cycle:{4}, Start date:{5}, Duration:{6}, Run hours:{7}, kWh:{8}", hf_IdLocation_EditContract.Value, ddlContractTypes.SelectedItem.Text, tbContractOutput.Text, tbContractAvailability.Text, tbDutyCycle.Text, tbStartDate.Text, tbContractLength.Text, tbInitalRunHrs.Text, tbInitialkWh.Text));
            }
            else
            {
                EditContractModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The contract information was not saved, please try again!");
            }
        }

        #endregion

        #region Report

        protected void populateReportOptions(int IdLocation)
        {
            EditReportOptions_alert_placeholder.InnerHtml = "";

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                EditReportOptions_alert_placeholder.InnerHtml = "";
                hf_IdLocation_EditReportOptions.Value = IdLocation.ToString();

                // Site Name
                var site = (from g in RsDc.HL_Locations where g.ID == IdLocation select g).SingleOrDefault();

                // Get the report chart options
                chkLstReportCharts.DataSource = from c in RsDc.GetTable<ColumnName>()
                                                where c.IsInstantaneousPlot == true && c.IsAvailableInReports == true
                                                orderby c.ColumnLabel
                                                select c;

                chkLstReportCharts.DataTextField = "ColumnLabel";
                chkLstReportCharts.DataValueField = "HeaderId";
                chkLstReportCharts.DataBind();

                // Get the current select values for charts
                

                // Set Values
                if (site != null)
                {
                    lblReportGeneratorName.Text = site.GENSETNAME.ToString();
                    lblReportGeneratorSerial.Text = site.GENSET_SN.ToString();
                }

                var ReportConfig = (from cfg in RsDc.ConfigReports where cfg.IdLocation == IdLocation select cfg).SingleOrDefault();

                if (ReportConfig != null)
                {
                    if (ReportConfig.ShowEfficiency == true) { chkShowEfficiency.Checked = true; }
                    if (ReportConfig.ShowUptime == true) { chkShowStartUp.Checked = true; }
                    if (ReportConfig.AvailabilityBasedOnUnitUnavailableFlag == true) { chkAvailability.Checked = true; }

                    // Mark the enabled charts in the checkboxes
                    if (ReportConfig.TrendChartArray != null && ReportConfig.TrendChartArray != "")
                    {
                        string[] assigned = ReportConfig.TrendChartArray.Split(',');

                        // For each checkbox item
                        foreach (ListItem item in chkLstReportCharts.Items)
                        {
                            if (assigned.Contains(item.Value))
                            {
                                // Check it
                                item.Selected = true;
                            }
                        }
                    }
                }
                else
                {
                    chkShowEfficiency.Checked = false;
                    chkShowStartUp.Checked = false;
                    chkAvailability.Checked = false;

                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Warning!", "Additional report options have not been defined.");
                }
            }

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#EditReportOptionsModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditReportOptionsModal", sb.ToString(), false);
        }

        protected void chkShowEfficiency_CheckedChanged(object sender, EventArgs e)
        {
            if (db.updateOrInsertReportConfig(Convert.ToInt32(hf_IdLocation_EditReportOptions.Value), chkShowEfficiency.Checked, chkShowStartUp.Checked, chkAvailability.Checked))
            {
                if (chkShowEfficiency.Checked)
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The efficiency report has been enabled.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Efficiency reports enabled.", hf_IdLocation_EditReportOptions.Value));
                }
                else
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The efficiency report has been disabled.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Efficiency reports disabled.", hf_IdLocation_EditReportOptions.Value));
                }
            }
            else
            {
                EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "Sorry, an error has occured. Please try again!.");
            }
        }

        protected void chkShowStartUp_CheckedChanged(object sender, EventArgs e)
        {
            if (db.updateOrInsertReportConfig(Convert.ToInt32(hf_IdLocation_EditReportOptions.Value), chkShowEfficiency.Checked, chkShowStartUp.Checked, chkAvailability.Checked))
            {
                if (chkShowStartUp.Checked)
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The start-up time report has been enabled.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Startup reports enabled.", hf_IdLocation_EditReportOptions.Value));
                }
                else
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The start-up time report has been disabled.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Startup reports disabled.", hf_IdLocation_EditReportOptions.Value));
                }
            }
            else
            {
                EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "Sorry, an error has occured. Please try again!.");
            }
        }

        protected void chkAvailability_CheckedChanged(object sender, EventArgs e)
        {
            if (db.updateOrInsertReportConfig(Convert.ToInt32(hf_IdLocation_EditReportOptions.Value), chkShowEfficiency.Checked, chkShowStartUp.Checked, chkAvailability.Checked))
            {
                if (chkAvailability.Checked)
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The availbility flag has been enabled.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Availability flag reports enabled.", hf_IdLocation_EditReportOptions.Value));
                }
                else
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The availbility flag has been disabled.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Availability flag reports disabled.", hf_IdLocation_EditReportOptions.Value));
                }
            }
            else
            {
                EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "Sorry, an error has occured. Please try again!.");
            }
        }

        //protected void chkShowChartActDem_CheckedChanged(object sender, EventArgs e)
        //{
        //    if (db.updateOrInsertReportConfig(Convert.ToInt32(hf_IdLocation_EditReportOptions.Value), chkShowEfficiency.Checked, chkShowStartUp.Checked, chkShowChartActDem.Checked, chkShowChartActPwr.Checked))
        //    {
        //        if (chkShowChartActDem.Checked)
        //        {
        //            EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The actual demand chart has been enabled.");
        //            LogMe.LogUserMessage(string.Format("Generator ID:{0}, Actual demand report chart enabled.", hf_IdLocation_EditReportOptions.Value));
        //        }
        //        else
        //        {
        //            EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The actual demand chart has been disabled.");
        //            LogMe.LogUserMessage(string.Format("Generator ID:{0}, Actual demand report chart disabled.", hf_IdLocation_EditReportOptions.Value));
        //        }
        //    }
        //    else
        //    {
        //        EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "Sorry, an error has occured. Please try again!.");
        //    }
        //}

        //protected void chkShowChartActPwr_CheckedChanged(object sender, EventArgs e)
        //{
        //    if (db.updateOrInsertReportConfig(Convert.ToInt32(hf_IdLocation_EditReportOptions.Value), chkShowEfficiency.Checked, chkShowStartUp.Checked, chkShowChartActDem.Checked, chkShowChartActPwr.Checked))
        //    {
        //        if (chkShowChartActPwr.Checked)
        //        {
        //            EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The actual power chart has been enabled.");
        //            LogMe.LogUserMessage(string.Format("Generator ID:{0}, Actual demand report chart enabled.", hf_IdLocation_EditReportOptions.Value));
        //        }
        //        else
        //        {
        //            EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The actual power chart has been disabled.");
        //            LogMe.LogUserMessage(string.Format("Generator ID:{0}, Actual power report chart disabled.", hf_IdLocation_EditReportOptions.Value));
        //        }
        //    }
        //    else
        //    {
        //        EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "Sorry, an error has occured. Please try again!.");
        //    }
        //}

        protected void chkLstReportCharts_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Get the sites report settings
                string tempTrendArray = null;

                // Loop each chart option and build the array string
                foreach (ListItem item in chkLstReportCharts.Items)
                {
                    if (item.Selected)
                    {
                        if (tempTrendArray == null)
                        {
                            tempTrendArray = item.Value.ToString();
                        }
                        else
                        {
                            tempTrendArray = tempTrendArray + "," + item.Value.ToString();
                        }
                    }
                }

                // Save to the db
                if (db.updateOrInsertReportConfigTrendArray(Convert.ToInt32(hf_IdLocation_EditReportOptions.Value), tempTrendArray))
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The trend charts have been updated.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Startup reports enabled.", hf_IdLocation_EditReportOptions.Value));
                }
                else
                {
                    EditReportOptions_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "Sorry, the trend charts could not be updated. Please try again!.");
                }
            }
        }

        #endregion

        #region Performance

        protected void populatePerformance(int IdLocation)
        {
            EditPerformanceModal_alert_placeholder.InnerHtml = "";
            hf_IdLocation_EditPerformance.Value = IdLocation.ToString();

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Site Name
                var site = (from g in RsDc.HL_Locations where g.ID == IdLocation select g).SingleOrDefault();

                // Set Values
                if (site != null)
                {
                    lblPerformanceGeneratorName.Text = site.GENSETNAME.ToString();
                    lblPerformanceGeneratorSerial.Text = site.GENSET_SN.ToString();
                }

                // ddl Gas Meter column
                ddlGasVolumeColumn.DataSource = RsDc.ed_History_GetColumnNames();
                ddlGasVolumeColumn.DataTextField = "COLUMN_NAME";
                ddlGasVolumeColumn.DataValueField = "COLUMN_NAME";
                ddlGasVolumeColumn.DataBind();
                ddlGasVolumeColumn.Items.Insert(0, new ListItem("Please select", "-1", true));

                // ddl Gas Meter Address
                ddlGasMeterAddress.Items.Insert(0, new ListItem("Please select", "-1", true));

                for (int i = 1; i <= 32; i++)
                {
                    ddlGasMeterAddress.Items.Insert(i, new ListItem(i.ToString(), i.ToString(), true));
                }

                // Current Settings for Efficiency
                var cfgEff = (from s in RsDc.ConfigEfficiencies
                              where s.IdLocation == IdLocation
                              select s).SingleOrDefault();

                if (cfgEff != null)
                {
                    tbCalorificValue.Text = cfgEff.GasCalorificValue.ToString();
                    chkCorrectionFactor.Checked = cfgEff.IsGasVolumeCorrected.Value;
                    ddlGasVolumeColumn.SelectedValue = cfgEff.GasVolumeColumnName;
                }
                else
                {
                    tbCalorificValue.Text = "";
                    chkCorrectionFactor.Checked = false;
                    ddlGasVolumeColumn.SelectedValue = "-1";

                    EditPerformanceModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Performace settings missing, please set the following for efficency reports.");
                }

                // Current Settings for Gas Address
                var cfgGas = (from s in RsDc.GasMeters_Mappings
                              where s.ID_Location == IdLocation
                              select s).SingleOrDefault();

                if (cfgGas != null)
                {
                    ddlGasMeterAddress.SelectedValue = cfgGas.Modbus_Addr.ToString();
                }

            }

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#EditPerformanceModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditPerformanceModal", sb.ToString(), false);
        }

        protected void SavePerformanceInfo_Click(object sender, EventArgs e)
        {
            // Check that both Gas Column Name and Gas Meter Address are not selected 
            if (ddlGasVolumeColumn.SelectedValue != "-1" && ddlGasMeterAddress.SelectedValue != "-1")
            {
                // Both are selected
                EditPerformanceModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "You cannot select both a gas column name and gas meter address, please try again!");
            }
            else
            {
                // Only one has been selected
                string GasColumn = null;
                int? GasMeter = null;

                // Meter or Column?
                if (ddlGasVolumeColumn.SelectedValue != "-1")
                {
                    // Set the Gas Column Name
                    GasColumn = ddlGasVolumeColumn.Text;
                }
                else if (ddlGasMeterAddress.SelectedValue != "-1")
                {
                    GasMeter = Convert.ToInt32(ddlGasMeterAddress.SelectedValue);
                }

                // Update Meter
                if (!db.UpdateOrInsertGasMeter_Mapping(Convert.ToInt32(hf_IdLocation_EditPerformance.Value), GasMeter))
                {
                    EditPerformanceModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The performance information was not saved, please try again!");
                    return;
                }

                // Update the perf data / column
                if (db.updateOrInsertEfficiencyConfig(Convert.ToInt32(hf_IdLocation_EditPerformance.Value), GasColumn, Convert.ToDouble(tbCalorificValue.Text), chkCorrectionFactor.Checked))
                {
                    EditPerformanceModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The performance information was sucessfully saved.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Performance data updated. Gas Column:{1}, Gas Meter:{2}, Calorific:{3}, Correction:{4}", hf_IdLocation_EditPerformance.Value, GasColumn, GasMeter, tbCalorificValue.Text, chkCorrectionFactor.Checked.ToString()));
                }
                else
                {
                    EditPerformanceModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The performance information was not saved, please try again!");
                }
            }
        }

        #endregion

        #region Insturments

        protected void populateInsturments(int IdLocation)
        {
            EditInsturments_alert_placeholder.InnerHtml = "";
            hf_IdLocation_EditInsturments.Value = IdLocation.ToString();

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Site Name
                var site = (from g in RsDc.HL_Locations where g.ID == IdLocation select g).SingleOrDefault();

                // Set Values
                if (site != null)
                {
                    lblInsturmentsGeneratorName.Text = site.GENSETNAME.ToString();
                    lblInsturmentsGeneratorSerial.Text = site.GENSET_SN.ToString();
                }

                // Get the thermal meter types
                ThermalMetersGrid.DataSource = (from s in RsDc.EnergyMeters_Types where s.Meter_Category == 1 select s); // 1 == Thermal Meters
                ThermalMetersGrid.DataBind();

                // Get the electrical meter types
                ElectricalMetersGrid.DataSource = (from s in RsDc.EnergyMeters_Types where s.Meter_Category == 2 select s); // 2 == Electrical Meters
                ElectricalMetersGrid.DataBind();

                // Then populate current thermal meter settings
                foreach (GridViewRow gvr in ThermalMetersGrid.Rows)
                {
                    DropDownList ddl = (DropDownList)ThermalMetersGrid.Rows[gvr.RowIndex].Cells[0].FindControl("ddlModbusAddress");
                    int Id_Type = (int)ThermalMetersGrid.DataKeys[gvr.RowIndex].Value;
                    string MB_Addr = ((from s in RsDc.EnergyMeters_Mappings where s.ID_Location == IdLocation && s.ID_Type == Id_Type select s.Modbus_Addr).FirstOrDefault()).ToString();
                    if (MB_Addr != "")
                    {
                        ddl.SelectedValue = MB_Addr;
                    }
                }

                // Then populate current electrical meter settings
                foreach (GridViewRow gvr in ElectricalMetersGrid.Rows)
                {
                    DropDownList ddl = (DropDownList)ElectricalMetersGrid.Rows[gvr.RowIndex].Cells[0].FindControl("ddlElectricalMeterSerial");
                    int Id_Type = (int)ElectricalMetersGrid.DataKeys[gvr.RowIndex].Value;
                    var MeterSerial = (from s in RsDc.EnergyMeters_Mapping_Serials where s.ID_Location == IdLocation && s.ID_Type == Id_Type select s).FirstOrDefault();
                    if (MeterSerial != null)
                    {
                        // Get the make & Model
                        var query = (from m in RsDc.EnergyMeters_MakeModels where m.ID == MeterSerial.ID_MakeModel select m).FirstOrDefault();

                        ddl.Items.Insert(1, new ListItem(query.Make + "-" + query.Model + ": " + MeterSerial.Serial, MeterSerial.Serial, true));
                        ddl.SelectedIndex = 1;
                    }
                }
            }

            //CSS Header Sytle
            ThermalMetersGrid.UseAccessibleHeader = true;
            ThermalMetersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;

            //CSS Header Sytle
            ElectricalMetersGrid.UseAccessibleHeader = true;
            ElectricalMetersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;

            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#EditInsturmentsModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "EditInsturmentsModal", sb.ToString(), false);
        }
        
        protected void ThermalMetersGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ListItem ddlItem = new ListItem();

                //Populate all dropdown lists
                DropDownList ddl =  (DropDownList)e.Row.Cells[0].FindControl("ddlModbusAddress");

                //And add a default when value is NULL
                ddl.Items.Insert(0, new ListItem("Please select", "-1", true));
                

                for (int i = 1; i <= 32; i++)
                {
                    ddl.Items.Insert(i, new ListItem(i.ToString(), i.ToString(), true));
                }
            }
        }

        protected void ddlModbusAddress_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                DropDownList ddl = (DropDownList)sender;
                GridViewRow gvr = (GridViewRow)ddl.NamingContainer;
                int Id_Location = Convert.ToInt32(hf_IdLocation_EditInsturments.Value);
                int Id_Type = (int)ThermalMetersGrid.DataKeys[gvr.RowIndex].Value;

                if (RsDc.ed_EnergyMeters_GetMapCountById(Id_Location, Id_Type, Convert.ToInt32(ddl.SelectedValue)).SingleOrDefault().RecordCount > 0)
                {
                    // Exists already
                    EditInsturments_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Modbus address is already in use, Please try again!");
                    ddl.SelectedValue = "-1";
                }
                else
                {
                    // Update
                    RsDc.ed_EnergyMeters_UpdateMapping(Id_Location, Id_Type, Convert.ToInt32(ddl.SelectedValue));
                    EditInsturments_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "Settings sucessfully updated.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Energy meter updated. Type:{1}, Modbus Addr:{2}", Id_Location, Id_Type, ddl.SelectedValue));
                }
            }

            //CSS Header Sytle
            ThermalMetersGrid.UseAccessibleHeader = true;
            ThermalMetersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;

            ElectricalMetersGrid.UseAccessibleHeader = true;
            ElectricalMetersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        #endregion        

        protected void ElectricalMetersGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ListItem ddlItem = new ListItem();

                //Populate all dropdown lists
                DropDownList ddl = (DropDownList)e.Row.Cells[0].FindControl("ddlElectricalMeterSerial");

                //And add a default when value is NULL
                ddl.Items.Insert(0, new ListItem("Please select", "-1", true));

                using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                {
                    var query = from meter in RsDc.EnergyMeters_Mapping_Serials
                                where meter.ID_Location == null
                                join MakeModel in RsDc.EnergyMeters_MakeModels on meter.ID_MakeModel equals MakeModel.ID
                                select new { Serial = meter.Serial, Make = MakeModel.Make, Model = MakeModel.Model };


                    // Add the Serials
                    foreach (var MeterMakeModel in query)
                    {
                        ddl.Items.Add(new ListItem(MeterMakeModel.Make + "-" + MeterMakeModel.Model + ": " + MeterMakeModel.Serial, MeterMakeModel.Serial, true));
                    }
                }
            }
        }

        protected void ddlElectricalMeterSerial_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                DropDownList ddl = (DropDownList)sender;
                GridViewRow gvr = (GridViewRow)ddl.NamingContainer;
                int Id_Location = Convert.ToInt32(hf_IdLocation_EditInsturments.Value);
                int Id_Type = (int)ElectricalMetersGrid.DataKeys[gvr.RowIndex].Value;

                // Check if type is in use on this location
                var query = (from map in RsDc.EnergyMeters_Mapping_Serials
                            where map.ID_Location == Id_Location && map.ID_Type == Id_Type && map.Serial != ddl.SelectedValue
                            select map).SingleOrDefault();


                if (query != null && ddl.SelectedValue != "-1")
                {
                    // Exists already
                    EditInsturments_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Meter type is already in use, Please try again!");
                    ddl.SelectedValue = "-1";
                }
                else
                {
                    // Update
                    db.updateMeterMapping_BySerial(ddl.SelectedValue, Id_Location, Id_Type);
                    EditInsturments_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "Settings sucessfully updated.");
                    LogMe.LogUserMessage(string.Format("Generator ID:{0}, Energy meter updated. Serial:{1}, Type:{2}", Id_Location, ddl.SelectedValue, Id_Type));
                }
            }

            //CSS Header Sytle
            ThermalMetersGrid.UseAccessibleHeader = true;
            ThermalMetersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;

            ElectricalMetersGrid.UseAccessibleHeader = true;
            ElectricalMetersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
        } 
    }
}