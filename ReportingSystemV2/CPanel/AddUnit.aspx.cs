using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Text.RegularExpressions;
using System.Drawing;
using System.Web.Services;
using System.Web.Security;
using ReportingSystemV2.Models;


namespace ReportingSystemV2.CPanel
{
    public partial class AddUnit : System.Web.UI.Page
    {
        CustomDataContext db = new CustomDataContext();

        // Global Error on GUI
        public bool userError = false;

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

        public class jQueryResult
        {
            public jQueryResult()
            {
                IsValid = false;
            }
            public bool IsValid { get; set; }
            public string Msg { get; set; }
        }

        public class UnitConfiguration
        {
            public string UnitSerial { get; set; }
            public int UnitModel { get; set; }
            public int ComapCount { get; set; }
            public string SiteName { get; set; }
            public string GensetName01 { get; set; }
            public string GensetName02 { get; set; }
            public string GensetName03 { get; set; }
            public string GensetName04 { get; set; }
            public string GensetName05 { get; set; }
            public string GensetName06 { get; set; }
            public string GensetName07 { get; set; }
            public string GensetName08 { get; set; }
            public string GensetSerial01 { get; set; }
            public string GensetSerial02 { get; set; }
            public string GensetSerial03 { get; set; }
            public string GensetSerial04 { get; set; }
            public string GensetSerial05 { get; set; }
            public string GensetSerial06 { get; set; }
            public string GensetSerial07 { get; set; }
            public string GensetSerial08 { get; set; }
            public string FTPPrefix { get; set; }
            public int UnitPortNo { get; set; }
            public string UnitBaudRate { get; set; }
            public bool EthernetEn { get; set; }
            public int FirstComapAddress { get; set; }
            public int HM01_Addr { get; set; }
            public int HM02_Addr { get; set; }
            public int HM03_Addr { get; set; }
            public int HM04_Addr { get; set; }
            public int HM05_Addr { get; set; }
            public int HM06_Addr { get; set; }
            public int HM07_Addr { get; set; }
            public int HM08_Addr { get; set; }
            public int SM01_Addr { get; set; }
            public int SM02_Addr { get; set; }
            public int SM03_Addr { get; set; }
            public int SM04_Addr { get; set; }
            public int SM05_Addr { get; set; }
            public int SM06_Addr { get; set; }
            public int SM07_Addr { get; set; }
            public int SM08_Addr { get; set; }
            public int GM01_Addr { get; set; }
            public int GM02_Addr { get; set; }
            public int GM03_Addr { get; set; }
            public int GM04_Addr { get; set; }
            public string CommsFilePath { get; set; }
            public string CommsObjName { get; set; }
            public string CommsObjDim { get; set; }
            public string CommsObjType { get; set; }
            public string CommsObjLen { get; set; }
            public string CommsObjDec { get; set; }
            public string CommsObjOfs { get; set; }
            public string CommsObjObj { get; set; }
            public string HeaderNameStr { get; set; }
            public string HeaderIdsStr { get; set; }
            public string HeaderTypeStr { get; set; }
            public bool FTPDevelopment { get; set; }
            public string OnCallNo1 { get; set; }
            public string OnCallNo2 { get; set; }
            public string OnCallNo3 { get; set; }
            public string OnCallNo4 { get; set; }
            public string OnCallNo5 { get; set; }
            public string AlertsEmail { get; set; }
            public string AdminEmail { get; set; }
            public bool SlaveEn { get; set; }
            public bool STOREn { get; set; }
            public int DemandReg { get; set; }
            public int TempAvgReg { get; set; }
            public int TempMaxReg { get; set; }
            public int TempMinReg { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindPrimaryEmailAddrs();
                BindSiteNames();
                BindPorts();
                BindComapCount();
                BindBaudRates();
                BindSlaveAddr();
                BindHeatMeterAddr();
                BindSteamMeterAddr();
                BindGasMeterAddr();
            }
        }

        #region Setup Defaults

        protected void BindPrimaryEmailAddrs()
        {
            ddlPrimaryEmailAddr.Items.Insert(0, new ListItem("Please Select", "-1"));
            ddlPrimaryEmailAddr.Items.Insert(1, new ListItem("Cork-Dataloggers@edina.eu", "Cork-Dataloggers@edina.eu"));
            ddlPrimaryEmailAddr.Items.Insert(2, new ListItem("Dublin-Dataloggers@edina.eu", "Dublin-Dataloggers@edina.eu"));
            ddlPrimaryEmailAddr.Items.Insert(3, new ListItem("Lisburn-Dataloggers@edina.eu", "Lisburn-Dataloggers@edina.eu"));
            ddlPrimaryEmailAddr.Items.Insert(4, new ListItem("Manchester-Dataloggers@edina.eu", "Manchester-Dataloggers@edina.eu"));
        }

        protected void BindSiteNames()
        {
            using (db)
            {
                //bind to unique sites to droplist
                ddlExistingSites.DataSource = from p in db.GetTable<HL_Location>()
                                              orderby p.SITENAME
                                              group p by p.SITENAME into uniqueSites
                                              select uniqueSites.FirstOrDefault();

                ddlExistingSites.DataTextField = "SITENAME";
                ddlExistingSites.DataValueField = "SITENAME";
                ddlExistingSites.DataBind();
                ddlExistingSites.Items.Insert(0, new ListItem("Please Select", "-1"));
            }
        }

        protected void BindPorts()
        {
            if (ddlUnitModel.SelectedIndex == 0)
            {
                // Mx2i Pro
                // Front RS232 = 0, Rear Optional RS485 = 1
                rblPort.Items.Clear();
                rblPort.Items.Add(new ListItem("RS232 (Front)", "1"));
                rblPort.Items.Add(new ListItem("RS485 (Rear)", "0"));

                // Ethernet Optional
                ddlEthernetEnabled.SelectedIndex = 0;
                ddlEthernetEnabled.Enabled = true;
            }
            else if (ddlUnitModel.SelectedIndex == 1)
            {
                // Mx2i Turbo
                // Front RS232 = 1, Rear RS485 = 2
                rblPort.Items.Clear();
                rblPort.Items.Add(new ListItem("RS232 (Front)", "1"));
                rblPort.Items.Add(new ListItem("RS485 (Rear)", "2"));

                // Ethernet Optional
                ddlEthernetEnabled.SelectedIndex = 0;
                ddlEthernetEnabled.Enabled = true;
            }
            else if (ddlUnitModel.SelectedIndex == 2 || ddlUnitModel.SelectedIndex == 3)
            {
                // Ax9 Turbo or NX-900
                // RS485 1 = 2, RS485 2 = 0
                rblPort.Items.Clear();
                rblPort.Items.Add(new ListItem("RS232-2", "1"));
                rblPort.Items.Add(new ListItem("RS485-1", "2"));
                rblPort.Items.Add(new ListItem("RS485-2", "0"));

                // Ethernet Always Enabled
                ddlEthernetEnabled.SelectedIndex = 1;
                ddlEthernetEnabled.Enabled = false;
            }
        }

        protected void BindComapCount()
        {
            for (int i = 0; i < 8; i++)
            {
                ddlComapCount.Items.Insert(i, new ListItem((i + 1).ToString(), (i + 1).ToString()));
            }
        }

        protected void BindBaudRates()
        {
            ddlBaud.Items.Insert(0, new ListItem("9600", "1"));
            ddlBaud.Items.Insert(1, new ListItem("19200", "2"));
            ddlBaud.Items.Insert(2, new ListItem("38400", "3"));
            ddlBaud.Items.Insert(3, new ListItem("57600", "4"));
            ddlBaud.SelectedIndex = 3;
        }

        protected void BindSlaveAddr()
        {
            ListItem defaultVal = new ListItem("-", "-1");
            ddlSlaveAddr.Items.Insert(0, defaultVal);

            for (int i = 1; i < 32; i++)
            {
                ddlSlaveAddr.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
            }
        }

        protected void BindHeatMeterAddr()
        {
            ListItem defaultVal = new ListItem("-", "-1");
            ddlHM_01.Items.Insert(0, defaultVal);
            ddlHM_02.Items.Insert(0, defaultVal);
            ddlHM_03.Items.Insert(0, defaultVal);
            ddlHM_04.Items.Insert(0, defaultVal);
            ddlHM_05.Items.Insert(0, defaultVal);
            ddlHM_06.Items.Insert(0, defaultVal);
            ddlHM_07.Items.Insert(0, defaultVal);
            ddlHM_08.Items.Insert(0, defaultVal);

            //HM 1 - 32
            for (int i = 1; i < 33; i++)
            {
                ddlHM_01.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_02.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_03.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_04.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_05.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_06.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_07.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlHM_08.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
            }

        }

        protected void BindSteamMeterAddr()
        {
            ListItem defaultVal = new ListItem("-", "-1");
            ddlSM_01.Items.Insert(0, defaultVal);
            ddlSM_02.Items.Insert(0, defaultVal);
            ddlSM_03.Items.Insert(0, defaultVal);
            ddlSM_04.Items.Insert(0, defaultVal);

            //HM 1 - 32
            for (int i = 1; i < 32; i++)
            {
                ddlSM_01.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlSM_02.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlSM_03.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlSM_04.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
            }

        }

        protected void BindGasMeterAddr()
        {
            ListItem defaultVal = new ListItem("-", "-1");
            ddlGM_01.Items.Insert(0, defaultVal);
            ddlGM_02.Items.Insert(0, defaultVal);

            //HM 1 - 32
            for (int i = 1; i < 32; i++)
            {
                ddlGM_01.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
                ddlGM_02.Items.Insert(i, new ListItem(i.ToString(), i.ToString()));
            }

        }
    
        #endregion

        #region UI Updates

        protected void ddlUnitModel_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            if (ddl.SelectedIndex == 0)
            {
                // Mx2i Pro
                // Front RS232 = 0, Rear Optional RS485 = 1
                rblPort.Items.Clear();
                rblPort.Items.Add(new ListItem("RS232 (Front)", "0"));
                rblPort.Items.Add(new ListItem("RS485 (Rear)", "1"));

                // Ethernet Optional
                ddlEthernetEnabled.SelectedIndex = 0;
                ddlEthernetEnabled.Enabled = true;
            }
            else if (ddl.SelectedIndex == 1)
            {
                // Mx2i Turbo
                // Front RS232 = 1, Rear RS485 = 2
                rblPort.Items.Clear();
                rblPort.Items.Add(new ListItem("RS232 (Front)", "1"));
                rblPort.Items.Add(new ListItem("RS485 (Rear)", "2"));

                // Ethernet Optional
                ddlEthernetEnabled.SelectedIndex = 0;
                ddlEthernetEnabled.Enabled = true;
            }
            else if (ddlUnitModel.SelectedIndex == 2 || ddlUnitModel.SelectedIndex == 3)
            {
                // Ax9 Turbo or NX-900
                // RS485 1 = 2, RS485 2 = 0
                rblPort.Items.Clear();
                rblPort.Items.Add(new ListItem("RS232-2", "1"));
                rblPort.Items.Add(new ListItem("RS485-1", "2"));
                rblPort.Items.Add(new ListItem("RS485-2", "0"));
                
                // Ethernet Always Enabled
                ddlEthernetEnabled.SelectedIndex = 1;
                ddlEthernetEnabled.Enabled = false;
            }
        }

        protected void ddlExistingSites_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            if (ddl.SelectedIndex == 0)
            {
                tbNewSiteName.Enabled = true;
                cvSiteName.Enabled = true;
            }
            else
            {
                tbNewSiteName.Text = "";
                tbNewSiteName.Enabled = false;
                cvSiteName.Enabled = false;
            }
        }

        protected void rblPort_SelectedIndexChanged(object sender, EventArgs e)
        {
            RadioButtonList rbl = (RadioButtonList)sender;

            if (rbl.SelectedValue == "rs232")
            {
                ddlEthernetEnabled.Enabled = true;
                ddlHM_01.Enabled = false;
                ddlHM_01.SelectedIndex = 0;
                ddlHM_02.Enabled = false;
                ddlHM_02.SelectedIndex = 0;
                ddlHM_03.Enabled = false;
                ddlHM_03.SelectedIndex = 0;
                ddlHM_04.Enabled = false;
                ddlHM_04.SelectedIndex = 0;
            }
            else if (rbl.SelectedValue == "rs485")
            {
                if (ddlUnitModel.SelectedIndex == 0)
                {
                    ddlEthernetEnabled.SelectedIndex = 0;
                    ddlEthernetEnabled.Enabled = false;
                }

                ddlHM_01.Enabled = true;
                ddlHM_02.Enabled = true;
                ddlHM_03.Enabled = true;
                ddlHM_04.Enabled = true;
            }
        }

        protected void gridHistoryResult_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            CustomDataContext db = new CustomDataContext();

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddl = new DropDownList();
                ddl = e.Row.FindControl("ddlHeaderName") as DropDownList;
                String Name = e.Row.Cells[0].Text as string;
                Label lbl = e.Row.FindControl("lblDescription") as Label;

                // Does the name exist in the wildcard table
                int HeaderID = (
                    from q in db.ComAp_Wildcards
                    where q.CommsObj_Name == Name && q.Approved == true
                    select q.id_Header).FirstOrDefault();

                //If yes then get its mapping from the headers table
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

                //These fields cannot be changed
                if (Name == "Reason" || Name == "Date" || Name == "Time")
                {
                    ddl.Enabled = false;
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
            foreach (GridViewRow ddlrow in historyResult.Rows)
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
                lbl.Text = "Custom column, please check for an alternative";
                lbl.ForeColor = Color.Violet;
            }
            else
            {
                lbl.Text = "";
            }
        }

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
                                                txtReader.Close();
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
                    }

                    historyResult.DataSource = dt;
                    historyResult.DataBind();
                    //UpdatePanelUpload.Update();

                    //CSS Header Sytle
                    historyResult.UseAccessibleHeader = true;
                    historyResult.HeaderRow.TableSection = TableRowSection.TableHeader;
                }
            }

            lblSuccess.Text = string.Format("{0} files have been uploaded successfully.", FileUpload1.PostedFiles.Count);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "openWiz('#History')", true);
        }

        #endregion

        #region Get User Selected Values
        protected int[] getSelectedComapSlaveIDs()
        {
            int[] comaps;
            comaps = new int[8];

            // Figure out the used addresses for comaps
            if (ddlComapCount.SelectedValue == "1")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
            }
            else if (ddlComapCount.SelectedValue == "2")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
            }
            else if (ddlComapCount.SelectedValue == "3")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
                comaps[2] = comaps[0] + 2;
            }
            else if (ddlComapCount.SelectedValue == "4")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
                comaps[2] = comaps[0] + 2;
                comaps[2] = comaps[0] + 3;
            }
            else if (ddlComapCount.SelectedValue == "5")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
                comaps[2] = comaps[0] + 2;
                comaps[3] = comaps[0] + 3;
                comaps[4] = comaps[0] + 4;
            }
            else if (ddlComapCount.SelectedValue == "6")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
                comaps[2] = comaps[0] + 2;
                comaps[3] = comaps[0] + 3;
                comaps[4] = comaps[0] + 4;
                comaps[5] = comaps[0] + 5;
            }
            else if (ddlComapCount.SelectedValue == "7")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
                comaps[2] = comaps[0] + 2;
                comaps[3] = comaps[0] + 3;
                comaps[4] = comaps[0] + 4;
                comaps[5] = comaps[0] + 5;
                comaps[6] = comaps[0] + 6;
            }
            else if (ddlComapCount.SelectedValue == "8")
            {
                comaps[0] = Int32.Parse(ddlSlaveAddr.SelectedValue);
                comaps[1] = comaps[0] + 1;
                comaps[2] = comaps[0] + 2;
                comaps[3] = comaps[0] + 3;
                comaps[4] = comaps[0] + 4;
                comaps[5] = comaps[0] + 5;
                comaps[6] = comaps[0] + 6;
                comaps[7] = comaps[0] + 7;
            }

            return comaps;
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

        protected string pad2digits(int value)
        {
            if (value < 10)
            {
                return "0" + value.ToString();
            }
            else
            {
                return value.ToString();
            }
        }

        protected void getSiteName(string sitename)
        {
            //Get suitable Genset names
            var query = from q in db.GetTable<HL_Location>()
                        where q.SITENAME == sitename
                        orderby q.GENSETNAME
                        select new
                        {
                            GensetName = q.GENSETNAME
                        };

            var Gensets = query.Select(a => a.GensetName).ToList();

            int largest = 0;

            try
            {
                foreach (var Genset in Gensets)
                {
                    if (Int32.Parse(Regex.Match(Genset, @"\d+").Value) > largest)
                    {
                        largest = Int32.Parse(Regex.Match(Genset, @"\d+").Value);
                    }
                }
            }
            
            catch (Exception)
            {
                // Numbers not used for site - set to 1
            }

            //Update Site Names using dynamic ID
            Label[] lblGenset = getGensetNameFields();

            var Controllers = Int32.Parse(ddlComapCount.SelectedValue);

            for (int i = 1; i <= Controllers; i++)
            {
                lblGenset[i - 1].Text = lblSiteName.Text + " " + pad2digits(largest + i);
            }
        }
        #endregion

        protected void ReviewBtn_Click(object sender, EventArgs e)
        {
            blFinalErrors.Items.Clear();

            CustomDataContext db = new CustomDataContext();

            //---------------------Site Settings--------------------------
            //Check datalogger serial
            Regex regex = new Regex("^[0-9]+$", RegexOptions.Compiled);

            if (tbUnitSerial.Text.Length == 0)
            {
                blFinalErrors.Items.Add("Please enter a datalogger serial no.");
                userError = true;
            }
            else if (!regex.IsMatch(tbUnitSerial.Text))
            {
                blFinalErrors.Items.Add("Datalogger serial no. must contain numeric values only.");
                userError = true;
            }
            else if (tbUnitSerial.Text.Length != 9)
            {
                blFinalErrors.Items.Add("Datalogger serial no. must be 9 characters.");
                userError = true;
            }
            else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbUnitSerial.Text == row.BLACKBOX_SN))
            {
                blFinalErrors.Items.Add("Datalogger serial no. is already in use.");
                userError = true;
            }
            lblUnitSerial.Text = tbUnitSerial.Text;

            //Check sitename
            if (ddlExistingSites.SelectedIndex != 0)
            {
                lblSiteName.Text = ddlExistingSites.SelectedValue;
                getSiteName(ddlExistingSites.SelectedValue);
            }
            else
            {
                if (tbNewSiteName.Text == "")
                {
                    blFinalErrors.Items.Add("Please enter a new site name or select an existing.");
                    userError = true;
                    lblSiteName.Text = "";
                    lblGensetName01.Text = "";
                    lblGensetName02.Text = "";
                    lblGensetName03.Text = "";
                    lblGensetName04.Text = "";
                    lblGensetName05.Text = "";
                    lblGensetName06.Text = "";
                    lblGensetName07.Text = "";
                    lblGensetName08.Text = "";
                }
                else
                {
                    lblSiteName.Text = tbNewSiteName.Text;
                    getSiteName(tbNewSiteName.Text);
                }

            }

            //Check comap serials
            //Unit 1
            if (tbComapSerial1.Text.Length == 0)
            {
                blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 1.");
                userError = true;
            }
            else if (tbComapSerial1.Text.Length != 8)
            {
                blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 1.");
                userError = true;
            }
            else if (db.HL_Locations.AsEnumerable()
                      .Any(row => tbComapSerial1.Text == row.GENSET_SN))
            {
                blFinalErrors.Items.Add("ComAp 1 Serial is already in use.");
                userError = true;
            }

            //Unit 2
            if (ddlComapCount.SelectedValue == "2" || ddlComapCount.SelectedValue == "3")
            {
                if (tbComapSerial2.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 2.");
                    userError = true;
                }
                else if (tbComapSerial2.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 2.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial2.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 2 Serial is already in use.");
                    userError = true;
                }
            }

            //Unit 3
            if (ddlComapCount.SelectedValue == "3")
            {
                if (tbComapSerial3.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 3.");
                    userError = true;
                }
                else if (tbComapSerial3.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 3.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial3.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 3 Serial is already in use.");
                    userError = true;
                }
            }

            //Unit 4
            if (ddlComapCount.SelectedValue == "4")
            {
                if (tbComapSerial4.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 4.");
                    userError = true;
                }
                else if (tbComapSerial4.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 4.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial4.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 4 Serial is already in use.");
                    userError = true;
                }
            }

            //Unit 5
            if (ddlComapCount.SelectedValue == "5")
            {
                if (tbComapSerial5.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 5.");
                    userError = true;
                }
                else if (tbComapSerial5.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 5.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial5.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 5 Serial is already in use.");
                    userError = true;
                }
            }

            //Unit 6
            if (ddlComapCount.SelectedValue == "6")
            {
                if (tbComapSerial6.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 6.");
                    userError = true;
                }
                else if (tbComapSerial6.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 6.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial6.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 6 Serial is already in use.");
                    userError = true;
                }
            }

            //Unit 7
            if (ddlComapCount.SelectedValue == "7")
            {
                if (tbComapSerial7.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 7.");
                    userError = true;
                }
                else if (tbComapSerial7.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 7.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial7.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 7 Serial is already in use.");
                    userError = true;
                }
            }

            //Unit 8
            if (ddlComapCount.SelectedValue == "8")
            {
                if (tbComapSerial8.Text.Length == 0)
                {
                    blFinalErrors.Items.Add("Please enter a Serial No. for ComAp 8.");
                    userError = true;
                }
                else if (tbComapSerial8.Text.Length != 8)
                {
                    blFinalErrors.Items.Add("Serial No. must be 8 characters for ComAp 8.");
                    userError = true;
                }
                else if (db.HL_Locations.AsEnumerable()
                          .Any(row => tbComapSerial8.Text == row.GENSET_SN))
                {
                    blFinalErrors.Items.Add("ComAp 8 Serial is already in use.");
                    userError = true;
                }
            }

            //------------------Communications Settings-----------------------
            //Port
            if (ddlUnitModel.SelectedIndex == 0) // Mx2i Pro
            {
                if (rblPort.SelectedValue == "1")
                {
                    lblCommPort.Text = "RS232 (Front)";
                }
                else if (rblPort.SelectedValue == "0")
                {
                    lblCommPort.Text = "RS485 (Rear)";
                }
            }
            else if (ddlUnitModel.SelectedIndex == 1) // Mx2i Turbo
            {
                if (rblPort.SelectedValue == "1")
                {
                    lblCommPort.Text = "RS232 (Front)";
                }
                else if (rblPort.SelectedValue == "2")
                {
                    lblCommPort.Text = "RS485 (Rear)";
                }
            }
            else if (ddlUnitModel.SelectedIndex == 2 || ddlUnitModel.SelectedIndex == 3) // AX9 or NX-900
            {
                if (rblPort.SelectedValue == "2")
                {
                    lblCommPort.Text = "RS485 1";
                }
                else if (rblPort.SelectedValue == "0")
                {
                    lblCommPort.Text = "RS485 2";
                }
            }

            //Baud
            if (ddlBaud.SelectedValue == "1")
            {
                lblCommBaud.Text = "9600bps";
            }
            else if (ddlBaud.SelectedValue == "2")
            {
                lblCommBaud.Text = "19200bps";
            }
            else if (ddlBaud.SelectedValue == "3")
            {
                lblCommBaud.Text = "38400bps";
            }
            else if (ddlBaud.SelectedValue == "4")
            {
                lblCommBaud.Text = "57600bps";
            }

            //Check comap addresses have been selected
            if (ddlSlaveAddr.SelectedIndex == 0)
            {
                blFinalErrors.Items.Add("Please select a valid ComAp slave address.");
                userError = true;
                lblComapAddr.Text = "";
            }
            else
            {
                //Comap Addresses
                int[] comaps;
                comaps = getSelectedComapSlaveIDs();
                string comapsStr = "";

                for (int i = 0; i < 8; i++)
                {
                    if (comaps[i] != 0)
                    {
                        if (i != Int32.Parse(ddlComapCount.SelectedValue) - 1)
                        {
                            comapsStr = comapsStr + comaps[i].ToString() + "/";
                        }
                        else
                        {
                            comapsStr = comapsStr + comaps[i].ToString();
                        }
                    }
                }
                lblComapAddr.Text = comapsStr;
            }

            //Check heat meter addresses
            if (ddlHM_01.SelectedIndex == 0 && ddlHM_02.SelectedIndex == 0 && ddlHM_03.SelectedIndex == 0 && ddlHM_04.SelectedIndex == 0
                && ddlHM_05.SelectedIndex == 0 && ddlHM_06.SelectedIndex == 0 && ddlHM_07.SelectedIndex == 0 && ddlHM_08.SelectedIndex == 0)
            {
                lblHMAddr.Text = "";
            }
            else
            {
                //Heat Meter Addresses
                int[] heatMeters;
                heatMeters = getSelectedHeatMeterSlaveIDs();
                string heatmetersStr = "";

                for (int i = 0; i < 8; i++)
                {
                    if (heatMeters[i] != 0)
                    {
                        if (heatMeters[i].ToString() != "-1")
                        {
                            if (i != 7 && heatMeters[i + 1].ToString() != "-1")
                            {
                                heatmetersStr = heatmetersStr + heatMeters[i].ToString() + "/";
                            }
                            else
                            {
                                heatmetersStr = heatmetersStr + heatMeters[i].ToString();
                            }
                        }
                    }
                }
                lblHMAddr.Text = heatmetersStr;
            }

            //Check steam meter addresses
            if (ddlSM_01.SelectedIndex == 0 && ddlSM_02.SelectedIndex == 0 && ddlSM_03.SelectedIndex == 0 && ddlSM_04.SelectedIndex == 0)
            {
                lblSteamAddr.Text = "";
            }
            else
            {
                //Heat Meter Addresses
                int[] steamMeters;
                steamMeters = getSelectedSteamMeterSlaveIDs();
                string steammetersStr = "";

                for (int i = 0; i < 4; i++)
                {
                    if (steamMeters[i] != 0)
                    {
                        if (steamMeters[i].ToString() != "-1")
                        {
                            if (i != 3 && steamMeters[i + 1].ToString() != "-1")
                            {
                                steammetersStr = steammetersStr + steamMeters[i].ToString() + "/";
                            }
                            else
                            {
                                steammetersStr = steammetersStr + steamMeters[i].ToString();
                            }
                        }
                    }
                }
                lblSteamAddr.Text = steammetersStr;
            }

            //Check gas meter addresses
            if (ddlGM_01.SelectedIndex == 0 && ddlGM_02.SelectedIndex == 0)
            {
                lblGasAddr.Text = "";
            }
            else
            {
                //Heat gas Addresses
                int[] gasMeters;
                gasMeters = getSelectedGasMeterSlaveIDs();
                string gasmetersStr = "";

                for (int i = 0; i < 2; i++)
                {
                    if (gasMeters[i] != 0)
                    {
                        if (gasMeters[i].ToString() != "-1")
                        {
                            if (i != 1 && gasMeters[i + 1].ToString() != "-1")
                            {
                                gasmetersStr = gasmetersStr + gasMeters[i].ToString() + "/";
                            }
                            else
                            {
                                gasmetersStr = gasmetersStr + gasMeters[i].ToString();
                            }
                        }
                    }
                }
                lblGasAddr.Text = gasmetersStr;
            }

            //Ethernet
            lblEthernetEn.Text = ddlEthernetEnabled.SelectedValue.ToString();

            //--------------------History Settings----------------------------
            int Correct = 0;
            int Unknown = 0;
            int InValid = 0;
            foreach (GridViewRow row in historyResult.Rows)
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

            lblHistoryTotal.Text = (Correct + Unknown + InValid).ToString();
            lblHistoryValid.Text = Correct.ToString();
            lblHistoryUnknown.Text = Unknown.ToString();

            if (historyResult.Rows.Count == 0)
            {
                blFinalErrors.Items.Add("Please upload a valid history file for processing.");
                userError = true;
            }
            else if (InValid > 0)
            {
                blFinalErrors.Items.Add("You have history column errors, please review and try again.");
                userError = true;
            }

            //Enable Save button if settings are correct
            if (InValid == 0)
            {
                SaveBtn.Enabled = true;
            }

            //Review all settings
            Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "openWiz('#Summary')", true);
        }
        
        // Controls to arrays for looping
        protected Label[] getGensetNameFields()
        {
            Label[] lblGensetNames = new Label[8];
            lblGensetNames[0] = lblGensetName01;
            lblGensetNames[1] = lblGensetName02;
            lblGensetNames[2] = lblGensetName03;
            lblGensetNames[3] = lblGensetName04;
            lblGensetNames[4] = lblGensetName05;
            lblGensetNames[5] = lblGensetName06;
            lblGensetNames[6] = lblGensetName07;
            lblGensetNames[7] = lblGensetName08;

            return lblGensetNames;
        }

        protected TextBox[] getGensetSerialFields()
        {
            TextBox[] tbGensetSerials = new TextBox[8];
            tbGensetSerials[0] = tbComapSerial1;
            tbGensetSerials[1] = tbComapSerial2;
            tbGensetSerials[2] = tbComapSerial3;
            tbGensetSerials[3] = tbComapSerial4;
            tbGensetSerials[4] = tbComapSerial5;
            tbGensetSerials[5] = tbComapSerial6;
            tbGensetSerials[6] = tbComapSerial7;
            tbGensetSerials[7] = tbComapSerial8;

            return tbGensetSerials;
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

        #region Save

        protected string columnToString(int cell)
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in historyResult.Rows)
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

        protected string headerNameToString()
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in historyResult.Rows)
            {
                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time"))
                {
                    DropDownList ddl = new DropDownList();
                    ddl = row.FindControl("ddlHeaderName") as DropDownList;

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

        protected string headerNameIDsToString()
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in historyResult.Rows)
            {
                DropDownList ddl = new DropDownList();
                ddl = row.FindControl("ddlHeaderName") as DropDownList;

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

        protected string TypeIDFromName(string name)
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

        protected string headerTypeToString()
        {
            string result = "";
            bool firstRow = true;

            foreach (GridViewRow row in historyResult.Rows)
            {
                if (!row.Cells[0].Text.Contains("Reason") && !row.Cells[0].Text.Contains("Date") && !row.Cells[0].Text.Contains("Time"))
                {
                    if (firstRow)
                    {

                        result = result + TypeIDFromName(row.Cells[1].Text);
                        firstRow = false;
                    }
                    else
                    {
                        result = result + "." + TypeIDFromName(row.Cells[1].Text);
                    }
                }
            }
            return result;
        }

        protected void updateWildcard(GridView gr, string ddlName)
        {
             // Save the history mappings where they dont exist in the mapping table - they will require approval - Unknown columns will require a mapping declaration
             int Saved = 0;

             foreach (GridViewRow row in gr.Rows)
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
                     db.ed_ComapWildcard_Insert(int.Parse(ddl.SelectedValue), Name, "", Type, int.Parse(Len), int.Parse(Dec), 0, 0);
                     LogMe.LogUserMessage(string.Format("Wildcard entry created for {0}, Name:{1}, Type:{2}, Len:{3}, Dec:{4}", ddl.SelectedItem.Text, Name, Type, Len, Dec));
                 }
             }
        }

        protected void clearAllFields()
        {
            //Clear the page for a new unit
            tbUnitSerial.Text = "";
            ddlUnitModel.ClearSelection();
            ddlExistingSites.ClearSelection();
            tbNewSiteName.Text = "";
            ddlComapCount.ClearSelection();

            //Port
            rblPort.SelectedIndex = 0;

            ddlBaud.SelectedIndex = 3;
            ddlEthernetEnabled.ClearSelection();
            ddlSlaveAddr.ClearSelection();

            TextBox[] Serials = getGensetSerialFields();
            for (int i = 0; i < 8; i++)
            {
                Serials[i].Text = "";
            }

            //Heat Meters
            DropDownList[] ddlHeatMeters = getHeatMeterFields();
            for (int i = 0; i < 8; i++)
            {
                ddlHeatMeters[i].ClearSelection();

                if (i != 0)
                { 
                    ddlHeatMeters[i].Enabled = false;
                }
            }

            //Steam Meters
            DropDownList[] ddlSteamMeters = getSteamMeterFields();
            for (int i = 0; i < 4; i++)
            {
                ddlSteamMeters[i].ClearSelection();

                if (i != 0)
                {
                    ddlSteamMeters[i].Enabled = false;
                }
            }

            //Gas Meters
            DropDownList[] ddlGasMeters = getGasMeterFields();
            for (int i = 0; i < 2; i++)
            {
                ddlGasMeters[i].ClearSelection();

                if (i != 0)
                {
                    ddlGasMeters[i].Enabled = false;
                }
            }

            //File upload
            FileUpload1.Attributes.Clear();
            lblSuccess.Text = "";
            historyResult.DataSource = null;
            historyResult.DataBind();

            //Clear Genset Names
            Label[] Names = getGensetNameFields();
            for (int i = 0; i < 8; i++)
            {
                Names[i].Text = "";
            }

            lblUnitSerial.Text = "";
            lblSiteName.Text = "";
            lblCommPort.Text = "";
            lblCommBaud.Text = "";
            lblComapAddr.Text = "";
            lblHMAddr.Text = "";
            lblSteamAddr.Text = "";
            lblGasAddr.Text = "";
            lblEthernetEn.Text = "";
            lblHistoryTotal.Text = "";
            lblHistoryValid.Text = "";
            lblHistoryUnknown.Text = "";

            blFinalErrors.Items.Clear();
        }

        // Finally Save
        protected void SubmitBtn_Click(object sender, EventArgs e)
        {
            // Save the config for download to a device, unit will appear in sites list as pending

            string siteName = "";
            var Controllers = Int32.Parse(ddlComapCount.SelectedValue);
            string[] gensetNames = new string[8];
            string[] gensetSerials = new string[8];
            int?[] heatMeters = new int?[8];
            int?[] steamMeters = new int?[4];
            int?[] gasMeters = new int?[2];
            int model = 0;
            bool ethernetEn = false;


            //Sitename
            if (ddlExistingSites.SelectedIndex != 0)
            {
                siteName = ddlExistingSites.SelectedValue;
            }
            else
            {
                if (tbNewSiteName.Text == "")
                {
                    //No Sitename defined
                }
                else
                {
                    siteName = tbNewSiteName.Text;
                }

            }

            //Update Names
            Label[] Names = getGensetNameFields();

            for (int i = 1; i <= Controllers; i++)
            {
                if (Names[i - 1].Text != "")
                {
                    gensetNames[i - 1] = Names[i - 1].Text;
                }
                else
                {
                    gensetNames[i - 1] = null;
                }

            }

            //Update Serials
            TextBox[] Serials = getGensetSerialFields();

            for (int i = 1; i <= Controllers; i++)
            {
                if (Serials[i - 1].Text != "")
                {
                    gensetSerials[i - 1] = Serials[i - 1].Text.ToUpper();
                }
                else
                {
                    gensetSerials[i - 1] = null;
                }

            }

            //Unit Model
            if (ddlUnitModel.SelectedIndex == 0)
            {
                model = 0; //Mx2i
            }
            else if (ddlUnitModel.SelectedIndex == 1)
            {
                model = 1; //Mx2i Turbo
            }
            else if (ddlUnitModel.SelectedIndex == 2)
            {
                model = 2; //AX9 Turbo
            }
            else if (ddlUnitModel.SelectedIndex == 3)
            {
                model = 3; //NX-900
            }

            if (ddlEthernetEnabled.SelectedIndex == 0)
            {
                ethernetEn = true;
            }

            //Heat Meters
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

            //Steam Meters
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

            //Gas Meters
            DropDownList[] ddlGasMeters = getGasMeterFields();

            for (int i = 0; i < 2; i++)
            {
                if (ddlGasMeters[i].SelectedValue.ToString() != "-1")
                {
                    gasMeters[i] = Int32.Parse(ddlGasMeters[i].SelectedValue);
                }
                else
                {
                    gasMeters[i] = null;
                }

            }

            // Reason, Date, Time are static fields on the datalogger, we begin saving at RPM----
            // Save the new site configuration to the database

            if (userError)
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "bootstrap_alert.warning('alert-warning', 'Oops!', 'Settings are invalid, please review and try again..')", true);
            }
            else
            {
                try
                {
                    

                    db.ed_Blackbox_Add(tbUnitSerial.Text, model, Int32.Parse(ddlComapCount.SelectedValue), siteName,
                        gensetNames[0], gensetNames[1], gensetNames[2], gensetNames[3], // Genset Names
                        gensetNames[4], gensetNames[5], gensetNames[6], gensetNames[7],
                        gensetSerials[0], gensetSerials[1], gensetSerials[2], gensetSerials[3], // Genset Serials
                        gensetSerials[4], gensetSerials[5], gensetSerials[6], gensetSerials[7],
                        siteName.Substring(0, 4).ToUpper(), Int32.Parse(rblPort.SelectedValue), ddlBaud.SelectedValue, ethernetEn, ddlSlaveAddr.SelectedIndex, // Port Settings
                        heatMeters[0], heatMeters[1], heatMeters[2], heatMeters[3], // Heat Meters
                        heatMeters[4], heatMeters[5], heatMeters[6], heatMeters[7],
                        steamMeters[0], steamMeters[1], steamMeters[2], steamMeters[3], null, null, null, null, // Steam Meters
                        gasMeters[0], gasMeters[1], null, null,  // Gas Meters
                        "C:/Somewhere/SomewhereElse", columnToString(0), null, columnToString(1), columnToString(2), columnToString(3), null, null,
                        headerNameToString(), headerNameIDsToString(), headerTypeToString(), // Comap Headers etc...
                        true, null, null, null, null, null, ddlPrimaryEmailAddr.SelectedValue, null, // Dev Mode, Oncall Numbers, Alert Emails group and support group
                        false, false, null, null, null, null, User.Identity.Name); // Modbus Slave, STOR Project, Registers

                    // Add mappings for approval
                    updateWildcard(historyResult, "ddlHeaderName");

                    // Add Gensets to HL_Locations
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    for (int i = 1; i <= Controllers; i++)
                    {
                        if (gensetSerials[i - 1] != "" && gensetNames[i - 1] != "" && siteName != "" && tbUnitSerial.Text != "")
                        {
                            db.ed_Genset_Add(gensetSerials[i - 1], gensetNames[i - 1], siteName, tbUnitSerial.Text);
                            sb.Append(string.Format("#{0} ", gensetSerials[i - 1]));
                        }
                    }

                    LogMe.LogUserMessage(string.Format("Blackbox:{0}, configuration has been created for site:{1} with {2} controllers. {3}", tbUnitSerial.Text, siteName, Controllers, sb));

                    //Display success message if all ok
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "bootstrap_alert.warning('alert-success', 'Success!', 'New unit successfully added..')", true);

                    //Clear the fields ready for another site
                    clearAllFields();
                }
                catch (Exception ex)
                {
                    //Go to review settings
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "bootstrap_alert.warning('alert-danger', 'Error!', 'Oops something went wrong. Please contact the administrator..')", true);

                    LogMe.LogUserMessage(string.Format("Blackbox:{0}, configuration could not be created for site:{1}", tbUnitSerial.Text, siteName));
                    LogMe.LogSystemException(ex.ToString());
                }
            }
            }

        #endregion

        // Webmethods & Validation
        #region WebMethods
        [WebMethod]
        public static jQueryResult IsSerialValid(string serial)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            Regex regex = new Regex("^[0-9]+$", RegexOptions.Compiled);

            if (serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (!regex.IsMatch(serial))
            {
                result.Msg = "Numeric values only.";
                return result;
            }
            else if (serial.Length != 9)
            {
                result.Msg = "Serial No. must be 9 characters.";
                return result;
            }
            else if (db.HL_Locations.AsEnumerable()
                          .Any(row => serial == row.BLACKBOX_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsSiteNameValid(string siteName, int existingSite)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (siteName.Length == 0 && existingSite == -1)
            {
                result.Msg = "Please enter a new site name or select an existing.";
                return result;
            }
            else if (existingSite != -1 || siteName.Length > 0)
            {
                result.IsValid = true;
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap1SerialValid(string serial)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap2SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount > 1 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount > 1 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap3SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount >= 3 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount >= 3 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap4SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount >= 4 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount >= 4 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap5SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount >= 5 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount >= 5 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap6SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount >= 6 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount >= 6 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap7SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount >= 7 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount >= 7 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public static jQueryResult IsComap8SerialValid(string serial, int comapCount)
        {
            CustomDataContext db = new CustomDataContext();

            jQueryResult result = new jQueryResult();

            if (comapCount >= 8 && serial.Length == 0)
            {
                result.Msg = "Please enter a Serial No.";
                return result;
            }
            else if (comapCount >= 8 && serial.Length != 8)
            {
                result.Msg = "Serial No. must be 8 characters.";
                return result;
            }
            else if (comapCount > 1 && db.HL_Locations.AsEnumerable()
                      .Any(row => serial == row.GENSET_SN))
            {
                result.Msg = "Serial is already in use.";
                return result;
            }
            else
            {
                result.IsValid = true;
                return result;
            }
        }

        #endregion

        #region Validation
        protected void ddlSlaveAddr_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
            int[] heats;
            heats = getSelectedHeatMeterSlaveIDs();
            int[] steams;
            steams = getSelectedSteamMeterSlaveIDs();
            int[] gases;
            gases = getSelectedGasMeterSlaveIDs();

            // Check for overlaps in heat meters, reset meter if found
            for (int i = 0; i < 8; i++)
            {
                if (heats[0] == comaps[i])
                {
                    ddlHM_01.SelectedIndex = 0;
                }
                else if (heats[1] == comaps[i])
                {
                    ddlHM_02.SelectedIndex = 0;
                }
                else if (heats[2] == comaps[i])
                {
                    ddlHM_03.SelectedIndex = 0;
                }
                else if (heats[3] == comaps[i])
                {
                    ddlHM_04.SelectedIndex = 0;
                }
                else if (heats[4] == comaps[i])
                {
                    ddlHM_05.SelectedIndex = 0;
                }
                else if (heats[5] == comaps[i])
                {
                    ddlHM_06.SelectedIndex = 0;
                }
                else if (heats[6] == comaps[i])
                {
                    ddlHM_07.SelectedIndex = 0;
                }
                else if (heats[7] == comaps[i])
                {
                    ddlHM_08.SelectedIndex = 0;
                }
            }

            //Steam Meters
            for (int i = 0; i < 4; i++)
            {
                if (steams[0] == comaps[i])
                {
                    ddlSM_01.SelectedIndex = 0;
                }
                else if (steams[1] == comaps[i])
                {
                    ddlSM_02.SelectedIndex = 0;
                }
                else if (steams[2] == comaps[i])
                {
                    ddlSM_03.SelectedIndex = 0;
                }
                else if (steams[3] == comaps[i])
                {
                    ddlSM_04.SelectedIndex = 0;
                }
            }

            for (int i = 0; i < 2; i++)
            {
                if (gases[0] == comaps[i])
                {
                    ddlGM_01.SelectedIndex = 0;
                }
                else if (gases[1] == comaps[i])
                {
                    ddlGM_02.SelectedIndex = 0;
                }
            }
        }

        protected void ddlHM_01_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_02_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_03_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_04_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_05_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_06_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_07_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlHM_08_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlSM_01_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlSM_02_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlSM_03_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlSM_04_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlGM_01_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
            }
        }

        protected void ddlGM_02_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;

            int[] comaps;
            comaps = getSelectedComapSlaveIDs();
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
        }

        protected void ddlPrimaryEmailAddr_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
        #endregion
}