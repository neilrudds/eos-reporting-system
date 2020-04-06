using DotNet.Highcharts.Options;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.CPanel
{
    public partial class ManageDataLoggers : System.Web.UI.Page
    {
        CustomDataContext CdC = new CustomDataContext();

        public class HistoryColumn
        {
            public string Name { get; set; }
            public string Dim { get; set; }
            public string Type { get; set; }
            public int Len { get; set; }
            public int Dec { get; set; }
            public int Ofs { get; set; }
            public string Obj { get; set; }
            public HistoryColumn() { }
        }

        public class BinaryDefinition
        {
            public string Type { get; set; }
            public string Definition { get; set; }
            public BinaryDefinition() { }
        }

        #region "Page Loading"

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) // Initial Page Load
            {
                DataloggersGrid.DataSource = CdC.ed_Blackbox_Get();
                DataloggersGrid.DataBind();

                populateDDLs();  // Populate drop-down list's default values
                BindPrimaryEmailAddrs(); // Populate the primary email selections

                // Set Chart Literal
                chartLiteral.Text = "<div id='chart1_container' style='height:450px;'></div>";

                // No file uploads avaliable
                ClientScript.RegisterClientScriptBlock(GetType(), "NewUploadAvaliable", "var NewUploadAvaliable = false;", true);
            }
            else if (IsPostBack && FileUpload1.PostedFile != null) // Postback with a file available
            {
                if (FileUpload1.PostedFile.FileName.Length > 0)
                {
                    ClientScript.RegisterClientScriptBlock(GetType(), "NewUploadAvaliable", "var NewUploadAvaliable = true;", true);
                }
                else
                {
                    ClientScript.RegisterClientScriptBlock(GetType(), "NewUploadAvaliable", "var NewUploadAvaliable = true;", true);
                }
            }
            else // Postback with no file
            {
                ClientScript.RegisterClientScriptBlock(GetType(), "NewUploadAvaliable", "var NewUploadAvaliable = false;", true);
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Apply GridView CSS header styles if rows exist
            if (DataloggersGrid.Rows.Count > 0)
            {
                DataloggersGrid.UseAccessibleHeader = true;
                DataloggersGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }

            if (gridModifyHistory.Rows.Count > 0)
            {
                gridModifyHistory.UseAccessibleHeader = true;
                gridModifyHistory.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        /// <summary>
        /// Populate the primary email address ddl's with values
        /// </summary>
        protected void BindPrimaryEmailAddrs()
        {
            ddlPrimaryEmail.Items.Insert(0, new ListItem("Please Select", "-1"));
            ddlPrimaryEmail.Items.Insert(1, new ListItem("Cork-Dataloggers@edina.eu", "Cork-Dataloggers@edina.eu"));
            ddlPrimaryEmail.Items.Insert(2, new ListItem("Dublin-Dataloggers@edina.eu", "Dublin-Dataloggers@edina.eu"));
            ddlPrimaryEmail.Items.Insert(3, new ListItem("Lisburn-Dataloggers@edina.eu", "Lisburn-Dataloggers@edina.eu"));
            ddlPrimaryEmail.Items.Insert(4, new ListItem("Manchester-Dataloggers@edina.eu", "Manchester-Dataloggers@edina.eu"));
        }

        /// <summary>
        /// Gets the current configuration status of a datalogger
        /// </summary>
        /// <param name="serial">Datalogger Serial</param>
        /// <returns></returns>
        public string getUnitStatus(string serial)
        {
            var query = (from u in CdC.Blackboxes where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                if (query.CFG_State == null)
                {
                    return "Configuration missing";
                }
                else if (query.CFG_State == 1)
                {
                    return "Initial configuration pending";
                }
                else if (query.CFG_State == 2)
                {
                    return "Configuration accepted";
                }
                else if (query.CFG_State == 3)
                {
                    return "Configuration update pending";
                }
                else if (query.CFG_State == 4)
                {
                    return "Operational";
                }
                else
                {
                    return "Configuration missing";
                }
            }
            else
            {
                return "Configuration missing";
            }

        }

        /// <summary>
        /// Populate the avaliable settings of the ddl's with default values
        /// </summary>
        public void populateDDLs()
        {
            List<ListItem> items = new List<ListItem>();

            // Apply to all
            items.Add(new ListItem { Value = "-1", Text = "-" });

            for (int j = 1; j < 33; j++)
            {
                items.Add(new ListItem
                {
                    Value = j.ToString(),
                    Text = j.ToString()
                });
            }

            ddlHM_01.Items.AddRange(items.ToArray());
            ddlHM_01.DataBind();

            ddlHM_02.Items.AddRange(items.ToArray());
            ddlHM_02.DataBind();

            ddlHM_03.Items.AddRange(items.ToArray());
            ddlHM_03.DataBind();

            ddlHM_04.Items.AddRange(items.ToArray());
            ddlHM_04.DataBind();

            ddlHM_05.Items.AddRange(items.ToArray());
            ddlHM_05.DataBind();

            ddlHM_06.Items.AddRange(items.ToArray());
            ddlHM_06.DataBind();

            ddlHM_07.Items.AddRange(items.ToArray());
            ddlHM_07.DataBind();

            ddlHM_08.Items.AddRange(items.ToArray());
            ddlHM_08.DataBind();

            ddlSM_01.Items.AddRange(items.ToArray());
            ddlSM_01.DataBind();

            ddlSM_02.Items.AddRange(items.ToArray());
            ddlSM_02.DataBind();

            ddlSM_03.Items.AddRange(items.ToArray());
            ddlSM_03.DataBind();

            ddlSM_04.Items.AddRange(items.ToArray());
            ddlSM_04.DataBind();

            ddlGM_01.Items.AddRange(items.ToArray());
            ddlGM_01.DataBind();

            ddlGM_02.Items.AddRange(items.ToArray());
            ddlGM_02.DataBind();

            ddlDir_01.Items.AddRange(items.ToArray());
            ddlDir_01.DataBind();

            ddlDir_02.Items.AddRange(items.ToArray());
            ddlDir_02.DataBind();

            ddlDir_03.Items.AddRange(items.ToArray());
            ddlDir_03.DataBind();

            ddlDir_04.Items.AddRange(items.ToArray());
            ddlDir_04.DataBind();
        }

        /// <summary>
        /// Convert seconds to DD, hh:mm:ss
        /// </summary>
        /// <param name="seconds">Time in seconds</param>
        /// <returns></returns>
        private string ConvertSecondsToDate(int seconds)
        {
            TimeSpan t = TimeSpan.FromSeconds(Convert.ToDouble(seconds));

            if (t.Days > 0)
                return t.ToString(@"d\d\,\ hh\:mm\:ss");
            return t.ToString(@"hh\:mm\:ss");
        }

        #endregion

        protected void DataloggersGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idx = Convert.ToInt32(e.CommandArgument.ToString()); // Row index
            GridViewRow row = (GridViewRow)DataloggersGrid.Rows[idx]; // The row
            string SerialNo = (DataloggersGrid.DataKeys[idx].Value).ToString(); // Datalogger serial from datakeys

            if (e.CommandName == "UnitInfo" && Shared.canUserAccessFunction("DataloggerViewInfo"))
            {
                // Populate the info pane
                populateUnitInfo(SerialNo);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#UnitInfoModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UnitInfoModalScript", sb.ToString(), false);

            }
            else if (e.CommandName == "UnitConfig" && Shared.canUserAccessFunction("DataloggerEditSettings"))
            {
                // Populate the config pane
                populateUnitConfig(SerialNo);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#UnitConfigurationModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UnitConfigurationModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "UnitTools" && Shared.canUserAccessFunction("DataloggerViewTools"))
            {
                populateUnitTools(SerialNo);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#UnitToolsModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UnitToolsModalScript", sb.ToString(), false);
            }
            else if (e.CommandName == "UnitHistory" && Shared.canUserAccessFunction("DataloggerEditHistory"))
            {
                populateUnitHistory(SerialNo);

                // Present the modal
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#ModifyHistoryModal').modal('show');");
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ModifyHistoryModalScript", sb.ToString(), false);
            }
        }

        #region "Unit Info Modal"

        protected void populateUnitInfo(string serialNo)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var unit = (from u in RsDc.Blackboxes
                            where u.BB_SerialNo == serialNo
                            select u).SingleOrDefault();


                // Set unit details
                lblUnitSerial.Text = serialNo;

                // Set Values
                if (unit != null)
                {
                    lblSiteName.Text = unit.CFG_SiteName;

                    if (unit.CFG_State != null)
                    {
                        if (unit.BB_Model == 0)
                        {
                            lblUnitModel.Text = "Mx2i Pro";
                        }
                        else if (unit.BB_Model == 1)
                        {
                            lblUnitModel.Text = "Mx2i Turbo";
                        }
                        else if (unit.BB_Model == 2)
                        {
                            lblUnitModel.Text = "AX9 Turbo";
                        }
                        else
                        {
                            lblUnitModel.Text = "Unknown";
                        }

                        DateTime dtOnline = (DateTime)unit.ST_LastStatusUpdateTime;
                        lblLastOnline.Text = dtOnline.ToString("dd/MM/yyyy HH:mm:ss");

                        lblGSMSignal.Text = unit.ST_GSMSignalLevel.ToString() + "%";

                        int BattCharge = (int)unit.ST_BatteryChargeLevel * 20; // Percentage 1 - 5
                        lblBattCharge.Text = BattCharge.ToString() + "%";

                        DateTime dtInstall = (DateTime)unit.CreationDate;
                        lblInstallDate.Text = dtInstall.ToString("dd/MM/yyyy HH:mm:ss");

                        lblInstallBy.Text = unit.CreatedBy;
                        lblUptime.Text = ConvertSecondsToDate((int)unit.ST_TimeSinceLastResetSeconds);

                        lblControllers.Text = unit.CFG_ConnectedControllersCount.ToString();

                        UnitInfoModal_alert_placeholder.InnerHtml = ""; // Clear error message
                    }
                    else
                    {
                        // Clear the values
                        lblUnitModel.Text = "-";
                        lblLastOnline.Text = "-";
                        lblGSMSignal.Text = "-";
                        lblBattCharge.Text = "-";
                        lblInstallDate.Text = "-";
                        lblInstallBy.Text = "-";
                        lblUptime.Text = "-";
                        lblControllers.Text = "-";

                        UnitInfoModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "The units settings are missing, please use the unit tools to sync the settings!");
                    }

                    bindGraph(unit.ID, DateTime.Now.AddDays(-7), DateTime.Now);
                }
            }
        }

        protected void openTab2()
        {
            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("openTab('tab2a');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "OpenTabRefScript1", sb.ToString(), false);
        }

        protected void openTab4()
        {
            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("openTab('tab4a');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "OpenTabRefScript2", sb.ToString(), false);
        }

        #endregion

        #region "Unit Configuration Modal"

        protected void clearUnitConfig()
        {
            // General
            rblPort.Items.Clear();
            rblPort.Items.Add(new ListItem("Unknown", "-1"));
            rblPort.SelectedValue = "-1";
            ddlCurrBaud.SelectedValue = "-1";
            ddlEthernetEnabled.SelectedValue = "0";
            ddlPrimaryEmail.SelectedValue = "-1";
            tbSecondaryEmail.Text = "";

            // Meters
            ddlHM_01.SelectedIndex = 0;

            ddlHM_02.SelectedIndex = 0;
            ddlHM_02.Enabled = false;

            ddlHM_03.SelectedIndex = 0;
            ddlHM_03.Enabled = false;

            ddlHM_04.SelectedIndex = 0;
            ddlHM_04.Enabled = false;

            ddlHM_05.SelectedIndex = 0;
            ddlHM_05.Enabled = false;

            ddlHM_06.SelectedIndex = 0;
            ddlHM_06.Enabled = false;

            ddlHM_07.SelectedIndex = 0;
            ddlHM_07.Enabled = false;

            ddlHM_08.SelectedIndex = 0;
            ddlHM_08.Enabled = false;

            ddlSM_01.SelectedIndex = 0;

            ddlSM_02.SelectedIndex = 0;
            ddlSM_02.Enabled = false;

            ddlSM_03.SelectedIndex = 0;
            ddlSM_03.Enabled = false;

            ddlSM_04.SelectedIndex = 0;
            ddlSM_04.Enabled = false;

            ddlGM_01.SelectedIndex = 0;

            ddlGM_02.SelectedIndex = 0;
            ddlGM_02.Enabled = false;

            tbLGSerial1.Text = "";
            tbLGSerial2.Text = "";
            tbLGSerial3.Text = "";
            tbLGSerial4.Text = "";
        }

        protected void populateUnitConfig(string serialNo)
        {
            // Reset Values
            clearUnitConfig();

            // Then populate
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var unit = (from u in RsDc.Blackboxes
                            where u.BB_SerialNo == serialNo
                            select u).FirstOrDefault();

                lblConfigUnitSerial.Text = serialNo;

                if (unit != null)
                {
                    lblConfigSiteName.Text = unit.CFG_SiteName;

                    if (unit.CFG_State != null)
                    {
                        if (unit.BB_Model == 0)
                        {
                            // Mx2i Pro
                            // Front RS232 = 0, Rear Optional RS485 = 1
                            rblPort.Items.Clear();
                            rblPort.Items.Add(new ListItem("RS232 (Front)", "1"));
                            rblPort.Items.Add(new ListItem("RS485 (Rear)", "0"));

                            // L&G Port Options
                            rblLGPort.Items.Clear();
                            rblLGPort.Items.Add(new ListItem("Unavailable", "-1"));
                            rblLGPort.SelectedIndex = 0;
                            rblLGPort.Enabled = false;

                            if (Convert.ToInt32(unit.CFG_PortNo) == 1)
                            {
                                rblPort.SelectedIndex = 0;
                            }
                            else if (Convert.ToInt32(unit.CFG_PortNo) == 0)
                            {
                                rblPort.SelectedIndex = 1;
                            }

                            // Enable Ethernet Option
                            ddlEthernetEnabled.Enabled = true;

                            // Disable L&G Meters
                            tbLGSerial1.Enabled = false;
                            tbLGSerial2.Enabled = false;
                            tbLGSerial3.Enabled = false;
                            tbLGSerial4.Enabled = false;
                        }
                        else if (unit.BB_Model == 1)
                        {
                            // Mx2i Turbo
                            // Front RS232 = 1, Rear RS485 = 2
                            rblPort.Items.Clear();
                            rblPort.Items.Add(new ListItem("RS232 (Front)", "1"));
                            rblPort.Items.Add(new ListItem("RS485 (Rear)", "2"));

                            // L&G Port Options
                            rblLGPort.Items.Clear();
                            rblLGPort.Items.Add(new ListItem("Unavailable", "-1"));
                            rblLGPort.SelectedIndex = 0;
                            rblLGPort.Enabled = false;

                            if (Convert.ToInt32(unit.CFG_PortNo) == 1)
                            {
                                rblPort.SelectedIndex = 0;
                            }
                            else if (Convert.ToInt32(unit.CFG_PortNo) == 2)
                            {
                                rblPort.SelectedIndex = 1;
                            }

                            // Enable Ethernet Option
                            ddlEthernetEnabled.Enabled = true;

                            // Disable L&G Meters
                            tbLGSerial1.Enabled = false;
                            tbLGSerial2.Enabled = false;
                            tbLGSerial3.Enabled = false;
                            tbLGSerial4.Enabled = false;
                        }
                        else if (unit.BB_Model == 2)
                        {
                            // Ax9 Turbo
                            // RS485 1 = 2, RS485 2 = 0
                            rblPort.Items.Clear();
                            rblPort.Items.Add(new ListItem("RS232-2", "1"));
                            rblPort.Items.Add(new ListItem("RS485-1", "2"));
                            rblPort.Items.Add(new ListItem("RS485-2", "0"));

                            // L&G Port Options
                            rblLGPort.Items.Clear();
                            rblLGPort.Items.Add(new ListItem("RS232-2", "1"));
                            rblLGPort.Items.Add(new ListItem("RS485-1", "2"));
                            rblLGPort.Items.Add(new ListItem("RS485-2", "0"));
                            rblLGPort.Enabled = true;

                            // Enable L&G Meters
                            tbLGSerial1.Enabled = true;
                            tbLGSerial2.Enabled = true;
                            tbLGSerial3.Enabled = true;
                            tbLGSerial4.Enabled = true;

                            // Modbus Port
                            if (unit.CFG_PortNo != null)
                            {
                                if (Convert.ToInt32(unit.CFG_PortNo) == 1)
                                {
                                    rblPort.SelectedIndex = 0;
                                }
                                else if (Convert.ToInt32(unit.CFG_PortNo) == 2)
                                {
                                    rblPort.SelectedIndex = 1;
                                }
                                else if (Convert.ToInt32(unit.CFG_PortNo) == 0)
                                {
                                    rblPort.SelectedIndex = 2;
                                }
                            }

                            // IEC-62056-21 Port
                            if (unit.CFG_LG_PortNo != null)
                            {
                                if (Convert.ToInt32(unit.CFG_LG_PortNo) == 1)
                                {
                                    rblLGPort.SelectedIndex = 0;
                                }
                                else if (Convert.ToInt32(unit.CFG_LG_PortNo) == 2)
                                {
                                    rblLGPort.SelectedIndex = 1;
                                }
                                else if (Convert.ToInt32(unit.CFG_LG_PortNo) == 0)
                                {
                                    rblLGPort.SelectedIndex = 2;
                                }
                            }

                            // Disable Ethernet Option
                            ddlEthernetEnabled.Enabled = false;

                            // Disable L&G Meters
                            tbLGSerial1.Enabled = true;
                            tbLGSerial1.Enabled = true;
                            tbLGSerial1.Enabled = true;
                            tbLGSerial1.Enabled = true;
                        }

                        if (unit.CFG_BaudRate != null)
                        {
                            ddlCurrBaud.SelectedIndex = Convert.ToInt32(unit.CFG_BaudRate);
                        }
                        else
                        {
                            ddlCurrBaud.SelectedIndex = 0;
                        }

                        ddlEthernetEnabled.SelectedIndex = Convert.ToInt32(unit.CFG_EthernetModuleEn);

                        if (unit.CFG_GenStatEmail != null && unit.CFG_GenStatEmail != "")
                        {
                            if (unit.CFG_GenStatEmail.ToLower() == "cork-dataloggers@edina.eu")
                            {
                                ddlPrimaryEmail.SelectedIndex = 1;
                            }
                            else if (unit.CFG_GenStatEmail.ToLower() == "dublin-dataloggers@edina.eu")
                            {
                                ddlPrimaryEmail.SelectedIndex = 2;
                            }
                            else if (unit.CFG_GenStatEmail.ToLower() == "lisburn-dataloggers@edina.eu")
                            {
                                ddlPrimaryEmail.SelectedIndex = 3;
                            }
                            else if (unit.CFG_GenStatEmail.ToLower() == "manchester-dataloggers@edina.eu")
                            {
                                ddlPrimaryEmail.SelectedIndex = 4;
                            }
                            else
                            {
                                ddlPrimaryEmail.SelectedIndex = 0;
                            }
                        }

                        tbSecondaryEmail.Text = unit.CFG_AdminEmail;

                        // Heat Meters
                        if (unit.CFG_HMAddr01 != null)
                        {
                            ddlHM_01.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr01);
                            ddlHM_02.Enabled = true;
                        }

                        if (unit.CFG_HMAddr02 != null)
                        {
                            ddlHM_02.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr02);
                            ddlHM_03.Enabled = true;
                        }

                        if (unit.CFG_HMAddr03 != null)
                        {
                            ddlHM_03.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr03);
                            ddlHM_04.Enabled = true;
                        }

                        if (unit.CFG_HMAddr04 != null)
                        {
                            ddlHM_04.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr04);
                            ddlHM_05.Enabled = true;
                        }

                        if (unit.CFG_HMAddr05 != null)
                        {
                            ddlHM_05.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr05);
                            ddlHM_06.Enabled = true;
                        }

                        if (unit.CFG_HMAddr06 != null)
                        {
                            ddlHM_06.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr06);
                            ddlHM_07.Enabled = true;
                        }

                        if (unit.CFG_HMAddr07 != null)
                        {
                            ddlHM_07.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr07);
                            ddlHM_08.Enabled = true;
                        }

                        if (unit.CFG_HMAddr08 != null)
                        {
                            ddlHM_08.SelectedIndex = Convert.ToInt32(unit.CFG_HMAddr08);
                        }

                        // Steam Meters
                        if (unit.CFG_SMAddr01 != null)
                        {
                            ddlSM_01.SelectedIndex = Convert.ToInt32(unit.CFG_SMAddr01);
                            ddlSM_02.Enabled = true;
                        }

                        if (unit.CFG_SMAddr02 != null)
                        {
                            ddlSM_02.SelectedIndex = Convert.ToInt32(unit.CFG_SMAddr02);
                            ddlSM_03.Enabled = true;
                        }

                        if (unit.CFG_SMAddr03 != null)
                        {
                            ddlSM_03.SelectedIndex = Convert.ToInt32(unit.CFG_SMAddr03);
                            ddlSM_04.Enabled = true;
                        }

                        if (unit.CFG_SMAddr04 != null)
                        {
                            ddlSM_04.SelectedIndex = Convert.ToInt32(unit.CFG_SMAddr04);
                        }

                        // Gas Meters
                        if (unit.CFG_GMAddr01 != null)
                        {
                            ddlGM_01.SelectedIndex = Convert.ToInt32(unit.CFG_GMAddr01);
                            ddlGM_02.Enabled = true;
                        }

                        if (unit.CFG_GMAddr02 != null)
                        {
                            ddlGM_02.SelectedIndex = Convert.ToInt32(unit.CFG_GMAddr02);
                        }

                        // L&G Meters
                        if (unit.CFG_LG_E650_SN01 != null)
                        {
                            tbLGSerial1.Text = unit.CFG_LG_E650_SN01;
                        }

                        if (unit.CFG_LG_E650_SN02 != null)
                        {
                            tbLGSerial2.Text = unit.CFG_LG_E650_SN02;
                        }

                        if (unit.CFG_LG_E650_SN03 != null)
                        {
                            tbLGSerial3.Text = unit.CFG_LG_E650_SN03;
                        }

                        if (unit.CFG_LG_E650_SN04 != null)
                        {
                            tbLGSerial4.Text = unit.CFG_LG_E650_SN04;
                        }

                        // SMS Numbers
                        if (unit.CFG_AddOnCallNo01 != null)
                        {
                            tb_SMS_01.Text = unit.CFG_AddOnCallNo01;
                        }

                        if (unit.CFG_AddOnCallNo02 != null)
                        {
                            tb_SMS_02.Text = unit.CFG_AddOnCallNo02;
                        }

                        if (unit.CFG_AddOnCallNo03 != null)
                        {
                            tb_SMS_03.Text = unit.CFG_AddOnCallNo03;
                        }

                        if (unit.CFG_AddOnCallNo04 != null)
                        {
                            tb_SMS_04.Text = unit.CFG_AddOnCallNo04;
                        }

                        if (unit.CFG_AddOnCallNo05 != null)
                        {
                            tb_SMS_05.Text = unit.CFG_AddOnCallNo05;
                        }

                        // RSG40 Gas Enabled
                        if (unit.CFG_RSG40_GasEn == true)
                        {
                            chkRSG40Gas.Enabled = true;
                            chkRSG40Gas.Checked = true;
                        }

                        // Diris A20 Meters
                        if (unit.CFG_DirAddr01 != null)
                        {
                            ddlDir_01.SelectedIndex = Convert.ToInt32(unit.CFG_DirAddr01);
                            tb_Diris_SN_01.Enabled = true;
                            ddlDir_02.Enabled = true;
                        }

                        if (unit.CFG_Dir_A20_SN01 != null)
                        {
                            tb_Diris_SN_01.Text = unit.CFG_Dir_A20_SN01.Trim();
                        }

                        if (unit.CFG_DirAddr02 != null)
                        {
                            ddlDir_02.SelectedIndex = Convert.ToInt32(unit.CFG_DirAddr02);
                            tb_Diris_SN_02.Enabled = true;
                            ddlDir_03.Enabled = true;
                        }

                        if (unit.CFG_Dir_A20_SN02 != null)
                        {
                            tb_Diris_SN_02.Text = unit.CFG_Dir_A20_SN02.Trim();
                        }

                        if (unit.CFG_DirAddr03 != null)
                        {
                            ddlDir_03.SelectedIndex = Convert.ToInt32(unit.CFG_DirAddr03);
                            tb_Diris_SN_03.Enabled = true;
                            ddlDir_04.Enabled = true;
                        }

                        if (unit.CFG_Dir_A20_SN03 != null)
                        {
                            tb_Diris_SN_03.Text = unit.CFG_Dir_A20_SN03.Trim();
                        }

                        if (unit.CFG_DirAddr04 != null)
                        {
                            ddlDir_04.SelectedIndex = Convert.ToInt32(unit.CFG_DirAddr04);
                            tb_Diris_SN_04.Enabled = true;
                        }

                        if (unit.CFG_Dir_A20_SN04 != null)
                        {
                            tb_Diris_SN_04.Text = unit.CFG_Dir_A20_SN04.Trim();
                        }

                        SaveUnitConfig.Enabled = true; // Settings Ok, enable save button
                        UnitConfigurationModal_alert_placeholder.InnerHtml = ""; // Clear alert
                    }
                    else
                    {
                        UnitConfigurationModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "The units settings are missing, please use the unit tools to sync the settings!");
                        SaveUnitConfig.Enabled = false; // No Settings present, disable the save button
                    }
                }
            }
        }

        /// <summary>
        /// Save the datalogger settings to the Db
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void SaveUnitConfig_Click(object sender, EventArgs e)
        {
            // Update the datalogger settings
            try
            {
                string SerialNo = lblConfigUnitSerial.Text;
                int?[] heatMeters = new int?[8];
                int?[] steamMeters = new int?[4];
                int?[] gasMeters = new int?[2];
                int?[] dirisMeters = new int?[4];

                var unit = (from u in CdC.Blackboxes
                            where u.BB_SerialNo == SerialNo
                            select u).FirstOrDefault();

                if (unit.BB_SerialNo != null)
                {
                    unit.CFG_PortNo = Int32.Parse(rblPort.SelectedValue);
                    unit.CFG_BaudRate = ddlCurrBaud.SelectedValue;

                    if (ddlEthernetEnabled.SelectedValue == "0")
                    {
                        unit.CFG_EthernetModuleEn = false;
                    }
                    else if (ddlEthernetEnabled.SelectedValue == "1")
                    {
                        unit.CFG_EthernetModuleEn = true;
                    }

                    // Primary Email
                    if (ddlPrimaryEmail.SelectedValue != "-1")
                    {
                        unit.CFG_GenStatEmail = ddlPrimaryEmail.SelectedValue.ToLower();
                    }

                    // Secondary Email
                    if (tbSecondaryEmail.Text != "")
                    {
                        unit.CFG_AdminEmail = tbSecondaryEmail.Text.ToLower();
                    }
                    else
                    {
                        unit.CFG_AdminEmail = null;
                    }

                    // Heat Meters
                    DropDownList[] ddlHeatMeters = getHeatMeterFields();

                    for (int i = 0; i < 8; i++)
                    {
                        if (ddlHeatMeters[i].SelectedValue.ToString() != "-1")
                        {
                            heatMeters[i] = Int32.Parse(ddlHeatMeters[i].SelectedValue);
                        }
                        else
                        {
                            heatMeters[i] = null;
                        }

                    }

                    // Steam Meters
                    DropDownList[] ddlSteamMeters = getSteamMeterFields();

                    for (int i = 0; i < 4; i++)
                    {
                        if (ddlSteamMeters[i].SelectedValue.ToString() != "-1")
                        {
                            steamMeters[i] = Int32.Parse(ddlSteamMeters[i].SelectedValue);
                        }
                        else
                        {
                            steamMeters[i] = null;
                        }

                    }

                    // Gas Meters
                    DropDownList[] ddlGasMeters = getGasMeterFields();

                    for (int i = 0; i < 2; i++)
                    {
                        if (ddlGasMeters[i].SelectedValue.ToString() != "-1")
                        {
                            gasMeters[i] = Int32.Parse(ddlGasMeters[i].SelectedValue);

                            // On first enabled gm, check the RSG40
                            if (i == 1)
                            {
                                if (chkRSG40Gas.Checked)
                                {
                                    unit.CFG_RSG40_GasEn = true;
                                }
                                else
                                {
                                    unit.CFG_RSG40_GasEn = null;
                                }
                            }
                        }
                        else
                        {
                            gasMeters[i] = null;
                        }

                    }

                    // Diris Meters
                    DropDownList[] ddlDirisMeters = getDirisMeterFields();

                    for (int i = 0; i < 4; i++)
                    {
                        if (ddlDirisMeters[i].SelectedValue.ToString() != "-1")
                        {
                            dirisMeters[i] = Int32.Parse(ddlDirisMeters[i].SelectedValue);
                        }
                        else
                        {
                            dirisMeters[i] = null;
                        }

                    }

                    // Heat Meters
                    unit.CFG_HMAddr01 = heatMeters[0];
                    unit.CFG_HMAddr02 = heatMeters[1];
                    unit.CFG_HMAddr03 = heatMeters[2];
                    unit.CFG_HMAddr04 = heatMeters[3];
                    unit.CFG_HMAddr05 = heatMeters[4];
                    unit.CFG_HMAddr06 = heatMeters[5];
                    unit.CFG_HMAddr07 = heatMeters[6];
                    unit.CFG_HMAddr08 = heatMeters[7];
                    // Gas Meters
                    unit.CFG_SMAddr01 = steamMeters[0];
                    unit.CFG_SMAddr02 = steamMeters[1];
                    unit.CFG_SMAddr03 = steamMeters[2];
                    unit.CFG_SMAddr04 = steamMeters[3];
                    // Steam Meters
                    unit.CFG_GMAddr01 = gasMeters[0];
                    unit.CFG_GMAddr02 = gasMeters[1];
                    // Diris Meters
                    unit.CFG_DirAddr01 = dirisMeters[0];
                    unit.CFG_DirAddr02 = dirisMeters[1];
                    unit.CFG_DirAddr03 = dirisMeters[2];
                    unit.CFG_DirAddr04 = dirisMeters[3];

                    // Landis & Gyr Meters
                    if (rblLGPort.SelectedValue != "-1")
                    {
                        unit.CFG_LG_PortNo = Int32.Parse(rblLGPort.SelectedValue);

                        if (tbLGSerial1.Text != "")
                        {
                            unit.CFG_LG_E650_SN01 = tbLGSerial1.Text;
                        }
                        else
                        {
                            unit.CFG_LG_E650_SN01 = null;
                        }

                        if (tbLGSerial1.Text != "" && tbLGSerial2.Text != "")
                        {
                            unit.CFG_LG_E650_SN02 = tbLGSerial2.Text;
                        }
                        else
                        {
                            unit.CFG_LG_E650_SN02 = null;
                        }

                        if (tbLGSerial1.Text != "" && tbLGSerial2.Text != "" && tbLGSerial3.Text != "")
                        {
                            unit.CFG_LG_E650_SN03 = tbLGSerial3.Text;
                        }
                        else
                        {
                            unit.CFG_LG_E650_SN03 = null;
                        }

                        if (tbLGSerial1.Text != "" && tbLGSerial2.Text != "" && tbLGSerial3.Text != "" && tbLGSerial4.Text != "")
                        {
                            unit.CFG_LG_E650_SN04 = tbLGSerial4.Text;
                        }
                        else
                        {
                            unit.CFG_LG_E650_SN04 = null;
                        }

                        if (tbLGSerial1.Text == "" && tbLGSerial2.Text == "" && tbLGSerial3.Text == "" && tbLGSerial4.Text == "")
                        {
                            unit.CFG_LG_PortNo = null; // No Serials, so clear the port
                        }
                    }

                    // SMS Numbers
                    if (tb_SMS_01.Text != "")
                    {
                        unit.CFG_AddOnCallNo01 = tb_SMS_01.Text;
                    }
                    else
                    {
                        unit.CFG_AddOnCallNo01 = null;
                    }

                    if (tb_SMS_02.Text != "")
                    {
                        unit.CFG_AddOnCallNo02 = tb_SMS_02.Text;
                    }
                    else
                    {
                        unit.CFG_AddOnCallNo02 = null;
                    }

                    if (tb_SMS_03.Text != "")
                    {
                        unit.CFG_AddOnCallNo03 = tb_SMS_03.Text;
                    }
                    else
                    {
                        unit.CFG_AddOnCallNo03 = null;
                    }

                    if (tb_SMS_04.Text != "")
                    {
                        unit.CFG_AddOnCallNo04 = tb_SMS_04.Text;
                    }
                    else
                    {
                        unit.CFG_AddOnCallNo04 = null;
                    }

                    if (tb_SMS_05.Text != "")
                    {
                        unit.CFG_AddOnCallNo05 = tb_SMS_05.Text;
                    }
                    else
                    {
                        unit.CFG_AddOnCallNo05 = null;
                    }

                    // Diris Meters
                    if (tb_Diris_SN_01.Text != "")
                    {
                        unit.CFG_Dir_A20_SN01 = tb_Diris_SN_01.Text;
                    }
                    else
                    {
                        unit.CFG_Dir_A20_SN01 = null;
                    }

                    if (tb_Diris_SN_01.Text != "" && tb_Diris_SN_02.Text != "")
                    {
                        unit.CFG_Dir_A20_SN02 = tb_Diris_SN_02.Text;
                    }
                    else
                    {
                        unit.CFG_Dir_A20_SN02 = null;
                    }

                    if (tb_Diris_SN_01.Text != "" && tb_Diris_SN_02.Text != "" && tb_Diris_SN_03.Text != "")
                    {
                        unit.CFG_Dir_A20_SN03 = tb_Diris_SN_03.Text;
                    }
                    else
                    {
                        unit.CFG_Dir_A20_SN03 = null;
                    }

                    if (tb_Diris_SN_01.Text != "" && tb_Diris_SN_02.Text != "" && tb_Diris_SN_03.Text != "" && tb_Diris_SN_04.Text != "")
                    {
                        unit.CFG_Dir_A20_SN04 = tb_Diris_SN_04.Text;
                    }
                    else
                    {
                        unit.CFG_Dir_A20_SN04 = null;
                    }

                    unit.CFG_State = 3; // Config Update Pending Flag

                    CdC.SubmitChanges();

                    LogMe.LogUserMessage(string.Format("Blackbox configuration modified, Serial: {0}", SerialNo));
                    UnitConfigurationModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The configuration has been updated!");
                }
            }
            catch (Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                UnitConfigurationModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The configuration could not be saved, please review try again!");
            }

        }

        protected DropDownList[] getHeatMeterFields()
        {
            DropDownList[] ddlHeatMeters = new DropDownList[8];
            ddlHeatMeters[0] = ddlHM_01;
            ddlHeatMeters[1] = ddlHM_02;
            ddlHeatMeters[2] = ddlHM_03;
            ddlHeatMeters[3] = ddlHM_04;
            ddlHeatMeters[4] = ddlHM_05;
            ddlHeatMeters[5] = ddlHM_06;
            ddlHeatMeters[6] = ddlHM_07;
            ddlHeatMeters[7] = ddlHM_08;

            return ddlHeatMeters;
        }

        protected DropDownList[] getSteamMeterFields()
        {
            DropDownList[] ddlSteamMeters = new DropDownList[4];
            ddlSteamMeters[0] = ddlSM_01;
            ddlSteamMeters[1] = ddlSM_02;
            ddlSteamMeters[2] = ddlSM_03;
            ddlSteamMeters[3] = ddlSM_04;

            return ddlSteamMeters;
        }

        protected DropDownList[] getGasMeterFields()
        {
            DropDownList[] ddlGasMeters = new DropDownList[2];
            ddlGasMeters[0] = ddlGM_01;
            ddlGasMeters[1] = ddlGM_02;

            return ddlGasMeters;
        }

        protected DropDownList[] getDirisMeterFields()
        {
            DropDownList[] ddlDirisMeters = new DropDownList[4];
            ddlDirisMeters[0] = ddlDir_01;
            ddlDirisMeters[1] = ddlDir_02;
            ddlDirisMeters[2] = ddlDir_03;
            ddlDirisMeters[3] = ddlDir_04;

            return ddlDirisMeters;
        }

        #endregion

        #region "Unit Tools Modal"

        protected void populateUnitTools(string serialNo)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var unit = (from u in RsDc.Blackboxes
                            where u.BB_SerialNo == serialNo
                            select u).FirstOrDefault();

                lblToolsUnitSerial.Text = serialNo;
                if (unit != null)
                {
                    lblToolsSiteName.Text = unit.CFG_SiteName;
                }
            }
        }

        #endregion

        #region "Unit History Configuration Modal"

        // Populate current settings
        protected void populateUnitHistory(string serialNo)
        {
            // Clear the New History Upload Tab
            gridHistoryResult.DataSource = null;
            gridHistoryResult.DataBind();

            UnitHistoryModal_alert_placeholder.InnerHtml = null;
            lblSuccess.Text = "";

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Datatable
                DataTable dt = new DataTable();
                dt.Clear();
                dt.Columns.Add("Name");
                dt.Columns.Add("Type");
                dt.Columns.Add("Len");
                dt.Columns.Add("Dec");

                int InvalidColumns = 0;

                lblHistoryUnitSerial.Text = serialNo;

                var site = (from s in RsDc.HL_Locations where s.BLACKBOX_SN == serialNo
                            select s).FirstOrDefault();

                if (site != null)
                {
                    lblHistorySiteName.Text = site.SITENAME;
                }

                try
                {
                    var unit = (from u in RsDc.Blackboxes where u.BB_SerialNo == serialNo
                                select u).FirstOrDefault();

                    if (unit != null && unit.CFG_HistoryColNameStr != null)
                    {

                        string[] columns = unit.CFG_HistoryColNameStr.Split(',');
                        string[] type = unit.CFG_HistoryColTypeStr.Split('.');
                        string[] len = unit.CFG_CommsObjLenStr.Split('.');
                        string[] dec = unit.CFG_CommsObjDecStr.Split('.');

                        // Lengths match?
                        if (columns.Length > 0 && type.Length >= columns.Length && len.Length >= columns.Length && dec.Length >= columns.Length)
                        {
                            for (int i = 0; i < columns.Length; i++)
                            {
                                DataRow _record = dt.NewRow();
                                _record["Name"] = columns[i];
                                _record["Type"] = type[i];
                                _record["Len"] = len[i];
                                _record["Dec"] = dec[i];

                                dt.Rows.Add(_record);

                                if (columns[i] == "Unknown") // Only intrested in unknown columns now as these are invalid.
                                {
                                    //if (!checkIfColumnIsValid(columns[i]))
                                    //{
                                        // Invalid
                                        InvalidColumns++;
                                    //}
                                }
                            }

                            if (InvalidColumns > 0)
                            {
                                UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("warning", "Oops!", "Invalid history columns exist in the current settings, please review the following configuration!");
                            }
                            else
                            {
                                UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The current history configuration is valid!");
                            }

                            gridModifyHistory.DataSource = dt;
                            gridModifyHistory.DataBind();

                            // CSS Header Sytle
                            gridModifyHistory.UseAccessibleHeader = true;
                            gridModifyHistory.HeaderRow.TableSection = TableRowSection.TableHeader;
                        }
                        else
                        {
                            // Clear
                            gridModifyHistory.DataSource = null;
                            gridModifyHistory.DataBind();

                            UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The history configuration could not be read, please sync the settings and try again!");
                        }
                    }
                    else
                    {
                        // Clear
                        gridModifyHistory.DataSource = null;
                        gridModifyHistory.DataBind();

                        UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The history configuration does not exist, please sync the settings and try again!");
                    }

                }
                catch (Exception e)
                {
                    // Error, Clear
                    gridModifyHistory.DataSource = null;
                    gridModifyHistory.DataBind();

                    UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The history configuration may not exist or it could not be read, please sync the settings and try again!");
                    LogMe.LogSystemException(e.Message);
                }
            }
        }

        protected bool checkIfColumnIsValid(string columnName)
        {
            // Does the history header exist in the valid column names table, CASE SENSITIVE!
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                int HeaderID = (from q in RsDc.ComAp_Headers
                                where q.History_Header == columnName
                                select q.id).FirstOrDefault();

                if (HeaderID > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        protected void bindGraph(int IdBlackbox, DateTime startDate, DateTime endDate, bool PostBack = false)
        {
            List<Series> SeriesData = new List<Series>(); // Store for the trend series'
            ChartBuilder Cb = new ChartBuilder();
            System.Text.StringBuilder eb = new System.Text.StringBuilder(); // String of faulty columns
            string myJSCode;
            bool error = false;

            // Add the signal level data to the chart
            SeriesData.Add(Cb.GetGSMSignalTurbo(IdBlackbox, startDate, endDate));
            SeriesData.Add(Cb.GetBatteryChargeLevelTurbo(IdBlackbox, startDate, endDate));

            // Populate the chart with the data
            myJSCode = Cb.PopuateOverTimeChartDataloggersJS(chartData: SeriesData, ChartTitle: "Unit Status", ScriptIt: true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
        }

        // Modify the current history
        protected void gridModifyHistory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            CustomDataContext db = new CustomDataContext();

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddl = new DropDownList();
                ddl = e.Row.FindControl("ddlHeaderName") as DropDownList;
                String Name = e.Row.Cells[0].Text as string;
                String Type = e.Row.Cells[1].Text as string;
                Label lbl = e.Row.FindControl("lblDescription") as Label;

                // Does the name exist in the wildcard table
                int HeaderID = (from q in db.ComAp_Headers where q.History_Header == Name
                    select q.id).FirstOrDefault();

                // If yes then get its mapping from the headers table
                if (HeaderID > 0)
                {
                    ddl.SelectedValue = HeaderID.ToString();
                    //lbl.Text = "ddlVal=" + ddl.SelectedValue.ToString() + "; id_Header=" + HeaderID.ToString();
                }
                else
                {
                    string headerString = (from x in db.Blackboxes
                                           where x.BB_SerialNo == lblHistoryUnitSerial.Text
                                           select x.CFG_HistoryColNameStr).FirstOrDefault();

                    if (headerString.IndexOf(Name) > 0 && Name != "Unknown")
                    {
                        ddl.SelectedValue = "-2";
                        ddl.SelectedItem.Text = Name;
                        lbl.Text = "Custom column, please check for an alternative";
                        lbl.ForeColor = Color.Violet;
                    }
                    else
                    {
                        ddl.SelectedValue = "-1";
                        lbl.Text = "Please select a valid header";
                        lbl.ForeColor = Color.Red;
                    }
                }

                //These fields cannot be changed
                if (Name == "Reason" || Name == "Date" || Name == "Time")
                {
                    ddl.Enabled = false;
                }

                // Set the type cell
                if (Type == "1")
                {
                    e.Row.Cells[1].Text = "Binary";
                }
                else if (Type == "2")
                {
                    e.Row.Cells[1].Text = "Char";
                }
                else if (Type == "3")
                {
                    e.Row.Cells[1].Text = "Integer";
                }
                else if (Type == "4")
                {
                    e.Row.Cells[1].Text = "List";
                }
                else if (Type == "5")
                {
                    e.Row.Cells[1].Text = "Unsigned";
                }
                else
                {
                    e.Row.Cells[1].Text = "Unknown";
                }
            }
        }

        protected void ddlHeaderName_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = ddl.NamingContainer as GridViewRow;
            Label lbl = row.FindControl("lblDescription") as Label;
            bool PrevSelected = new bool();

            // Loop each row and make sure user is not already using this header name
            DropDownList ddlSelected = new DropDownList();
            foreach (GridViewRow ddlrow in gridModifyHistory.Rows)
            {
                // Exclude the current row
                if (ddlrow != row)
                {
                    ddlSelected = ddlrow.FindControl("ddlHeaderName") as DropDownList;
                    if (ddlSelected.SelectedValue == ddl.SelectedValue)
                    {
                        PrevSelected = true;
                    }
                }
            }

            // Validate all other options
            if (ddl.SelectedValue == "-1")
            {
                lbl.Text = "Please select a valid header";
                lbl.ForeColor = Color.Red;
            }
            else if (PrevSelected && ddl.SelectedValue != "-2")
            {
                ddl.SelectedValue = "-1";
                lbl.Text = "Header name already in use";
                lbl.ForeColor = Color.Red;
            }
            else if (ddl.SelectedValue == "-2")
            {
                if (ddl.Text.IndexOf("Unknown") > 0)
                {
                    lbl.Text = "Column will not be imported";
                    lbl.ForeColor = Color.Orange;
                }
                else
                {
                    lbl.Text = "Custom column, please check for an alternative";
                    lbl.ForeColor = Color.Violet;
                }
            }
            else
            {
                lbl.Text = "";
            }
        }

        protected void btnSaveHistoryConfig_Click(object sender, EventArgs e)
        {
            DB db = new DB();

            int Correct = 0;
            int Unknown = 0;
            int InValid = 0;
            foreach (GridViewRow row in gridModifyHistory.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.FindControl("ddlHeaderName") as DropDownList;

                if (ddl.SelectedValue == "-1")
                {
                    InValid++;
                }
                else if (ddl.SelectedValue == "-2")
                {
                    Unknown++;
                }
                else
                {
                    Correct++;
                }
            }

            if (InValid > 0)
            {
                UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The configuration is invalid and cannot be saved, please review the settings and try again!");
            }
            else
            {
                // Save
                if (db.updateHistoryHeaders(lblHistoryUnitSerial.Text, headerNamesToString(gridModifyHistory, "ddlHeaderName"), headerTypesToString(gridModifyHistory), columnToString(gridModifyHistory, 2), columnToString(gridModifyHistory, 3)))
                {
                    // Update the wildcards
                    updateWildcardToDb(gridModifyHistory, "ddlHeaderName");

                    //Map the Binarys
                    mapBinarysToDefinitions(gridModifyHistory, "ddlHeaderName", lblHistoryUnitSerial.Text);

                    LogMe.LogUserMessage(string.Format("Blackbox history configuration modified, Serial: {0}", lblHistoryUnitSerial.Text));
                    UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The configuration settings have been saved!");
                }
                else
                {
                    UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "The configuration settings could not be saved, please try again later!");
                }
            }
        }

        // Upload new history file
        protected void UploadMultipleFiles(object sender, EventArgs e)
        {
            System.Threading.Thread.Sleep(5000);

            Boolean endFlag = false;
            int rows = 0;

            //Datatable
            DataTable dt = new DataTable();
            dt.Clear();
            dt.Columns.Add("Name");
            dt.Columns.Add("Type");
            dt.Columns.Add("Len");
            dt.Columns.Add("Dec");

            if (FileUpload1.HasFile)
            {
                //try
                //{
                if (FileUpload1.PostedFile.ContentType == "text/plain")
                {
                    if (FileUpload1.PostedFile.ContentLength > 1024)
                    {
                        //Parse it
                        StreamReader txtReader = new StreamReader(FileUpload1.PostedFile.InputStream);

                        string inputLine = "";

                        while (!endFlag && (inputLine = txtReader.ReadLine()) != null)
                        {
                            if (inputLine.Contains("Tab. 7:  History Record"))
                            {
                                //Found the History Section
                                while (!endFlag && (inputLine = txtReader.ReadLine()) != null)
                                {
                                    if (inputLine.Contains("------------------"))
                                    {
                                        //Settings begin in the next row
                                        while (!endFlag && (inputLine = txtReader.ReadLine()) != null)
                                        {
                                            //History ends on a blank row - exit all
                                            if (inputLine == string.Empty)
                                            {
                                                endFlag = true;
                                            }
                                            else
                                            {
                                                HistoryColumn column = new HistoryColumn();
                                                column.Name = Regex.Replace(inputLine.Substring(0, 15), @"\s", "");
                                                column.Dim = Regex.Replace(inputLine.Substring(15, 5), @"\s", "");
                                                column.Type = Regex.Replace(inputLine.Substring(20, 13), @"\s", "");
                                                column.Len = int.Parse(inputLine.Substring(33, 4));
                                                string dec = Regex.Replace(inputLine.Substring(37, 2), @"\s", "");

                                                //Handle Decimal
                                                if (dec == "-")
                                                {
                                                    column.Dec = 0;
                                                }
                                                else
                                                {
                                                    column.Dec = int.Parse(dec);
                                                }

                                                //Add to table
                                                DataRow _record = dt.NewRow();
                                                _record["Name"] = column.Name;
                                                _record["Type"] = column.Type;
                                                _record["Len"] = column.Len.ToString();
                                                _record["Dec"] = column.Dec.ToString();

                                                dt.Rows.Add(_record);

                                                rows++;
                                            }

                                        }
                                    }
                                }
                            }
                        }

                        // Lets get the Binary definition too
                        saveBinaryDefinitions(parseBinaryDefinitions(txtReader), lblHistoryUnitSerial.Text);

                        txtReader.Close();
                    }

                    gridHistoryResult.DataSource = dt;
                    gridHistoryResult.DataBind();
                    //UpdatePanelUpload.Update();

                    //CSS Header Sytle
                    gridHistoryResult.UseAccessibleHeader = true;
                    gridHistoryResult.HeaderRow.TableSection = TableRowSection.TableHeader;
                }
            }

            lblSuccess.Text = string.Format("{0} files have been uploaded successfully.", FileUpload1.PostedFiles.Count);
        }

        protected DataTable parseBinaryDefinitions(StreamReader file)
        {
            // Data needed for Db is: Type e.g. Binary#1, then definition
            Boolean endFlag = false;

            //Datatable
            DataTable dt = new DataTable();
            dt.Clear();
            dt.Columns.Add("Type");
            dt.Columns.Add("Def");

            string inputLine = "";

            while (!endFlag && (inputLine = file.ReadLine()) != null)
            {
                if (inputLine.Contains("Tab. 11:  Binary# Types Meaning"))
                {
                    //Found the Binary Section
                    while (!endFlag && (inputLine = file.ReadLine()) != null)
                    {
                        if (inputLine.Contains("------------------"))
                        {
                            // Type is on the next row
                            while (!endFlag && (inputLine = file.ReadLine()) != null)
                            {
                                if (inputLine.Contains("Binary#"))
                                {
                                    bool endBinary = false;

                                    // We have a new binary definition
                                    BinaryDefinition def = new BinaryDefinition();
                                    def.Type = inputLine;

                                    // Skip next 3 rows
                                    for (int i = 1; i <= 3; ++i)
                                    {
                                        file.ReadLine();
                                    }

                                    while (!endBinary && (inputLine = file.ReadLine()) != null)
                                    {
                                        // Loop all rows and add to definition string
                                        if (inputLine.Contains("------------------") || inputLine.Contains("=====================") || inputLine == string.Empty)
                                        {
                                            endBinary = true;
                                        }
                                        else
                                        {
                                            def.Definition = def.Definition + inputLine.Trim() + ";";
                                        }
                                    }

                                    DataRow _record = dt.NewRow();
                                    _record["Type"] = def.Type.Trim();
                                    _record["Def"] = def.Definition.Trim();

                                    dt.Rows.Add(_record);
                                }
                                else if (inputLine.Contains("====================="))
                                {
                                    // End of Binary section
                                    file.Close();
                                    endFlag = true;
                                }
                            }
                        }
                    }
                }
            }
            return dt;
        }

        protected void saveBinaryDefinitions(DataTable dt, string UnitSerial)
        {
            DB db = new DB();

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var unit = (from u in RsDc.Blackboxes
                            where u.BB_SerialNo == UnitSerial
                            select u).SingleOrDefault();

                db.updateBinaryDefinition(dt, unit.ID);
            }
        }

        protected void gridHistoryResult_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            CustomDataContext db = new CustomDataContext();

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddl = new DropDownList();
                ddl = e.Row.FindControl("ddlNewHeaderName") as DropDownList;
                String Name = e.Row.Cells[0].Text as string;
                Label lbl = e.Row.FindControl("lblNewDescription") as Label;

                // Does the name exist in the wildcard table
                int HeaderID = (from q in db.ComAp_Wildcards
                                where q.CommsObj_Name == Name && q.Approved == true
                                select q.id_Header).FirstOrDefault();

                // If yes then get its mapping from the headers table
                if (HeaderID > 0)
                {
                    ddl.SelectedValue = HeaderID.ToString();
                    //lbl.Text = "ddlVal=" + ddl.SelectedValue.ToString() + "; id_Header=" + HeaderID.ToString();
                }
                else
                {
                    ddl.SelectedValue = "-2";
                    ddl.SelectedItem.Text = Name;
                    lbl.Text = "Custom column, please check for an alternative";
                    lbl.ForeColor = Color.Violet;
                }

                // These fields cannot be changed
                if (Name == "Reason" || Name == "Date" || Name == "Time")
                {
                    ddl.Enabled = false;
                }

            }

        }

        protected void ddlNewHeaderName_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = ddl.NamingContainer as GridViewRow;
            Label lbl = row.FindControl("lblNewDescription") as Label;
            bool PrevSelected = new bool();

            // Loop each row and make sure user is not already using this header name
            DropDownList ddlSelected = new DropDownList();
            foreach (GridViewRow ddlrow in gridHistoryResult.Rows)
            {
                // Exclude the current row
                if (ddlrow != row)
                {
                    ddlSelected = ddlrow.FindControl("ddlNewHeaderName") as DropDownList;
                    if (ddlSelected.SelectedValue == ddl.SelectedValue)
                    {
                        PrevSelected = true;
                    }
                }
            }

            // Validate all other options
            if (ddl.SelectedValue == "-1")
            {
                lbl.Text = "Please select a valid header";
                lbl.ForeColor = Color.Red;
            }
            else if (PrevSelected && ddl.SelectedValue != "-2")
            {
                ddl.SelectedValue = "-1";
                lbl.Text = "Header name already in use";
                lbl.ForeColor = Color.Red;
            }
            else if (ddl.SelectedValue == "-2")
            {
                lbl.Text = "Custom column, please check for an alternative";
                lbl.ForeColor = Color.Violet;
            }
            else
            {
                lbl.Text = "";
            }
        }

        protected void btnSaveNewHistoryConfig_Click(object sender, EventArgs e)
        {
            DB db = new DB();

            int Correct = 0;
            int Unknown = 0;
            int InValid = 0;

            foreach (GridViewRow row in gridHistoryResult.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.FindControl("ddlNewHeaderName") as DropDownList;

                if (ddl.SelectedValue == "-1")
                {
                    InValid++;
                }
                else if (ddl.SelectedValue == "-2")
                {
                    Unknown++;
                }
                else
                {
                    Correct++;
                }
            }

            if (InValid > 0)
            {
                UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Oops!", "The configuration is invalid and cannot be saved, please review the settings and try again!");
            }
            else
            {

                // Save
                string headerString = headerNamesToString(gridHistoryResult, "ddlNewHeaderName");
                string TypeStr = headerTypesToString(gridHistoryResult);
                string LenStr = columnToString(gridHistoryResult, 2);
                string DecStr = columnToString(gridHistoryResult, 3);
                string ObjNameStr = columnToString(gridHistoryResult, 0);
                string ObjTypeStr = columnToString(gridHistoryResult, 1);
                string HistoryColIDsStr = headerNameIdsToString(gridHistoryResult, "ddlNewHeaderName");

                if (db.updateHistoryHeaders(lblHistoryUnitSerial.Text, headerString, TypeStr, LenStr, DecStr, ObjNameStr, ObjTypeStr, HistoryColIDsStr))
                {
                    updateWildcardToDb(gridHistoryResult, "ddlNewHeaderName");
                    mapBinarysToDefinitions(gridHistoryResult, "ddlNewHeaderName", lblHistoryUnitSerial.Text);
                    LogMe.LogUserMessage(string.Format("Blackbox history configuration modified, Serial: {0}", lblHistoryUnitSerial.Text));
                    UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("success", "Success!", "The configuration settings have been saved!");
                }
                else
                {
                    UnitHistoryModal_alert_placeholder.InnerHtml = Shared.createAlertMessage("danger", "Error!", "The configuration settings could not be saved, please try again later!");
                }
            }
        }

        protected void mapBinarysToDefinitions(GridView gv, string ddlName, string UnitSerial)
        {
            DB db = new DB();

            foreach (GridViewRow row in gv.Rows) // Loop all rows
            {
                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time")) // Ignore these static rows
                {
                    DropDownList ddl = new DropDownList();
                    ddl = row.FindControl(ddlName) as DropDownList; // Polulate the ddl control

                    // Is this a Binary column
                    if (row.Cells[1].Text.Contains("Binary")) // Find Binary rows
                    {
                        if (ddl.SelectedValue != "-1" && ddl.SelectedValue != "-2") // Ignore unmapped headers
                        {
                            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
                            {
                                var unit = (from u in RsDc.Blackboxes
                                            where u.BB_SerialNo == UnitSerial
                                            select u).SingleOrDefault();

                                db.updateBinaryMap(unit.ID, ddl.SelectedItem.Text, row.Cells[1].Text); // Added mapped Binarys to the Db
                            }
                        }
                    }


                }
            }
        }

        protected string headerNameIdsToString(GridView gv, string ddlName)
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in gv.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.FindControl(ddlName) as DropDownList;

                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time"))
                {
                    if (ddl.SelectedValue == "-1")
                    {
                        //Invalid
                    }
                    else if (ddl.SelectedValue == "-2")
                    {
                        if (firstRow)
                        {
                            result = result + "0";
                            firstRow = false;
                        }
                        else
                        {
                            result = result + "." + "0";
                        }
                    }
                    else
                    {
                        if (firstRow)
                        {
                            result = result + ddl.SelectedValue;
                            firstRow = false;
                        }
                        else
                        {
                            result = result + "." + ddl.SelectedValue;
                        }
                    }
                }
            }
            return result;
        }

        // Shared
        protected void updateWildcardToDb(GridView gv, string ddlName)
        {
            // Save the history mappings where they dont exist in the mapping table - they will require approval - Unknown columns will require a mapping declaration
            int Saved = 0;

            foreach (GridViewRow row in gv.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.FindControl(ddlName) as DropDownList;
                String Name = row.Cells[0].Text;
                String Type = row.Cells[1].Text;
                String Len = row.Cells[2].Text;
                String Dec = row.Cells[3].Text;

                if (ddl.SelectedValue == "-1" || ddl.SelectedValue == "-2")
                {
                    // No map created, add empty
                }
                else
                {
                    // Add complete map
                    CdC.ed_ComapWildcard_Insert(int.Parse(ddl.SelectedValue), Name, "", Type, int.Parse(Len), int.Parse(Dec), 0, 0);
                    LogMe.LogUserMessage(string.Format("Wildcard entry created for {0}, Name:{1}, Type:{2}, Len:{3}, Dec:{4}", ddl.SelectedItem.Text, Name, Type, Len, Dec));
                }
            }
        }

        protected string headerNamesToString(GridView gv, string ddlName)
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in gv.Rows)
            {
                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time"))
                {
                    DropDownList ddl = new DropDownList();
                    ddl = row.FindControl(ddlName) as DropDownList;

                    if (ddl.SelectedValue == "-1")
                    {
                        //Invalid
                    }
                    //else if (ddl.SelectedValue == "-2")
                    //{
                    //    if (firstRow)
                    //    {
                    //        result = result + "Unknown";
                    //        firstRow = false;
                    //    }
                    //    else
                    //    {
                    //        result = result + "," + "Unknown";
                    //    }
                    //}
                    else
                    {
                        if (firstRow)
                        {
                            result = result + ddl.SelectedItem.Text;
                            firstRow = false;
                        }
                        else
                        {
                            result = result + "," + ddl.SelectedItem.Text;
                        }
                    }
                }
            }
            return result;
        }

        protected string headerTypesToString(GridView gv)
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in gv.Rows)
            {
                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time"))
                {
                    if (firstRow)
                    {

                        result = result + columnTypeNameToId(row.Cells[1].Text);
                        firstRow = false;
                    }
                    else
                    {
                        result = result + "." + columnTypeNameToId(row.Cells[1].Text);
                    }
                }
            }
            return result;
        }

        protected string columnToString(GridView gv, int cell)
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in gv.Rows)
            {
                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time"))
                {
                    if (firstRow)
                    {
                        result = result + row.Cells[cell].Text;
                        firstRow = false;
                    }
                    else
                    {
                        result = result + "." + row.Cells[cell].Text;
                    }
                }
            }
            return result;
        }

        protected string columnTypeNameToId(string name)
        {
            if (name.Contains("Binary"))
            {
                return "1";
            }
            else if (name.Contains("Char"))
            {
                return "2";
            }
            else if (name.Contains("Integer"))
            {
                return "3";
            }
            else if (name.Contains("List"))
            {
                return "4";
            }
            else if (name.Contains("Unsigned"))
            {
                return "5";
            }
            else
            {
                return "0";
            }
        }

        #endregion

        #region User Event Validation

        protected int[] getComapIDsForSelectedSite()
        {
            int[] comaps;
            comaps = new int[8];

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var unit = (from u in RsDc.Blackboxes
                            where u.BB_SerialNo == lblConfigUnitSerial.Text
                            select u).FirstOrDefault();

                if (unit != null)
                {
                    int[] temp = new int[8];
                    int firstAddress = Convert.ToInt32(unit.CFG_FirstControllerAddr);

                    // Build and array of the addresses
                    for (int i = 0; i < Convert.ToInt32(unit.CFG_ConnectedControllersCount); i++)
                    {
                        temp[i] = firstAddress + i;
                    }

                    // Copy only connect comaps
                    Array.Copy(temp, comaps, Convert.ToInt32(unit.CFG_ConnectedControllersCount));
                }

                return comaps;
            }
        }

        protected int[] getSelectedHeatMeterSlaveIDs()
        {
            int[] meters;
            meters = new int[8];

            meters[0] = Int32.Parse(ddlHM_01.SelectedValue);
            meters[1] = Int32.Parse(ddlHM_02.SelectedValue);
            meters[2] = Int32.Parse(ddlHM_03.SelectedValue);
            meters[3] = Int32.Parse(ddlHM_04.SelectedValue);
            meters[4] = Int32.Parse(ddlHM_05.SelectedValue);
            meters[5] = Int32.Parse(ddlHM_06.SelectedValue);
            meters[6] = Int32.Parse(ddlHM_07.SelectedValue);
            meters[7] = Int32.Parse(ddlHM_08.SelectedValue);

            return meters;
        }

        protected int[] getSelectedSteamMeterSlaveIDs()
        {
            int[] meters;
            meters = new int[4];

            meters[0] = Int32.Parse(ddlSM_01.SelectedValue);
            meters[1] = Int32.Parse(ddlSM_02.SelectedValue);
            meters[2] = Int32.Parse(ddlSM_03.SelectedValue);
            meters[3] = Int32.Parse(ddlSM_04.SelectedValue);
            //meters[4] = Int32.Parse(ddlHM_05.SelectedValue);
            //meters[5] = Int32.Parse(ddlHM_06.SelectedValue);
            //meters[6] = Int32.Parse(ddlHM_07.SelectedValue);
            //meters[7] = Int32.Parse(ddlHM_08.SelectedValue);

            return meters;
        }

        protected int[] getSelectedGasMeterSlaveIDs()
        {
            int[] meters;
            meters = new int[2];

            meters[0] = Int32.Parse(ddlGM_01.SelectedValue);
            meters[1] = Int32.Parse(ddlGM_02.SelectedValue);
            //meters[2] = Int32.Parse(ddlHM_03.SelectedValue);
            //meters[3] = Int32.Parse(ddlHM_04.SelectedValue);
            //meters[4] = Int32.Parse(ddlHM_05.SelectedValue);
            //meters[5] = Int32.Parse(ddlHM_06.SelectedValue);
            //meters[6] = Int32.Parse(ddlHM_07.SelectedValue);
            //meters[7] = Int32.Parse(ddlHM_08.SelectedValue);

            return meters;
        }

        protected int[] getSelectedDirisMeterSlaveIDs()
        {
            int[] meters;
            meters = new int[4];

            meters[0] = Int32.Parse(ddlDir_01.SelectedValue);
            meters[1] = Int32.Parse(ddlDir_02.SelectedValue);
            meters[2] = Int32.Parse(ddlDir_03.SelectedValue);
            meters[3] = Int32.Parse(ddlDir_04.SelectedValue);
            //meters[4] = Int32.Parse(ddlHM_05.SelectedValue);
            //meters[5] = Int32.Parse(ddlHM_06.SelectedValue);
            //meters[6] = Int32.Parse(ddlHM_07.SelectedValue);
            //meters[7] = Int32.Parse(ddlHM_08.SelectedValue);

            return meters;
        }

        protected void ddlHM_01_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 0)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_02.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_02_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 1)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_03.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_03_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 2)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_04.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_04_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 3)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_05.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_05_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 4)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_06.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_06_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 5)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_07.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_07_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 6)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlHM_08.Enabled = true;
            }

            openTab2();
        }

        protected void ddlHM_08_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Check against other heat meters
            for (int i = 0; i < 8; i++)
            {
                //Skip the meter in question
                if (i != 7)
                {
                    if (heats[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                    }
                }
            }

            openTab2();
        }

        protected void ddlSM_01_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Heat Meters
            for (int i = 0; i < 8; i++)
            {
                if (heats[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other steam meters
            for (int i = 0; i < 4; i++)
            {
                //Skip the meter in question
                if (i != 0)
                {
                    if (steams[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlSM_02.Enabled = true;
            }

            openTab2();
        }

        protected void ddlSM_02_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Heat Meters
            for (int i = 0; i < 8; i++)
            {
                if (heats[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other steam meters
            for (int i = 0; i < 4; i++)
            {
                //Skip the meter in question
                if (i != 1)
                {
                    if (steams[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlSM_03.Enabled = true;
            }

            openTab2();
        }

        protected void ddlSM_03_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Heat Meters
            for (int i = 0; i < 8; i++)
            {
                if (heats[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other steam meters
            for (int i = 0; i < 4; i++)
            {
                //Skip the meter in question
                if (i != 2)
                {
                    if (steams[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlSM_04.Enabled = true;
            }

            openTab2();
        }

        protected void ddlSM_04_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Heat Meters
            for (int i = 0; i < 8; i++)
            {
                if (heats[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Gas Meters
            for (int i = 0; i < 2; i++)
            {
                if (gases[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Check against other steam meters
            for (int i = 0; i < 4; i++)
            {
                //Skip the meter in question
                if (i != 3)
                {
                    if (steams[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                    }
                }
            }

            openTab2();
        }

        protected void ddlGM_01_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();
            bool conflict = false;

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Heat Meters
            for (int i = 0; i < 8; i++)
            {
                if (heats[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                    conflict = true;
                }
            }

            //Check against other gas meters
            for (int i = 0; i < 2; i++)
            {
                //Skip the meter in question
                if (i != 0)
                {
                    if (gases[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                        conflict = true;
                    }
                }
            }

            if (!conflict)
            {
                ddlGM_02.Enabled = true;
                chkRSG40Gas.Enabled = true;
            }

            openTab2();
        }

        protected void ddlGM_02_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getComapIDsForSelectedSite();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();

            //Check against the comaps range first
            for (int i = 0; i < 8; i++)
            {
                if (comaps[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Heat Meters
            for (int i = 0; i < 8; i++)
            {
                if (heats[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[i] == Int32.Parse(ddl.SelectedValue))
                {
                    ddl.SelectedIndex = 0;
                }
            }

            //Check against other gas meters
            for (int i = 0; i < 2; i++)
            {
                //Skip the meter in question
                if (i != 1)
                {
                    if (gases[i] == Int32.Parse(ddl.SelectedValue))
                    {
                        ddl.SelectedIndex = 0;
                    }
                }
            }

            openTab2();
        }

        protected void ddlDir_01_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlDir_02_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlDir_03_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlDir_04_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        #endregion 
    }
}