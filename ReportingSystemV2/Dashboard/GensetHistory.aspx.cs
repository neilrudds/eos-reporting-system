using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using ClosedXML.Excel;
using System.IO;
using System.Net.Mail;
using System.Configuration;
using System.Net.Mime;
using ReportingSystemV2.Models;
using System.Text.RegularExpressions;

namespace ReportingSystemV2.Dashboard
{
    public partial class GeneratorHistory : System.Web.UI.Page
    {
        DB db = new DB();
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        public int location;
        public int type = -1;

        public static int totalRecordsCount;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null && Request.QueryString["type"] != null)
            {
                location = int.Parse(Request.QueryString["id"]);
                type = int.Parse(Request.QueryString["type"]);
            }

            tbEmailMsg.Attributes.Add("onkeyup", "return GetCount(" + tbEmailMsg.ClientID + "," + msgCharCount.ClientID + ");");

            fixHeaderRow();
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            fixHeaderRow();
        }

        protected void fixHeaderRow()
        {
            if (GridHistory.Rows.Count > 0)
            {
                //CSS Header Sytle
                GridHistory.UseAccessibleHeader = true;
                GridHistory.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected DataTable FormatComApDT(DataTable dt)
        {
            // Format Table
            if (dt.Rows.Count > 0)
            {
                dt.Columns.Remove("ID");
                dt.Columns["Time_stamp"].ColumnName = "Date";
            }

            return dt;
        }

        protected DataTable FormatDirisA20DT(DataTable dt)
        {
            // Format Table
            if (dt.Rows.Count > 0)
            {
                dt.Columns.Remove("ID");
                dt.Columns["Timestamp"].ColumnName = "Date";
                dt.Columns["I_1"].ColumnName = "I-1";
                dt.Columns["I_2"].ColumnName = "I-2";
                dt.Columns["I_3"].ColumnName = "I-3";
                dt.Columns["I_N"].ColumnName = "I-N";
                dt.Columns["V12"].ColumnName = "V1-V2";
                dt.Columns["V23"].ColumnName = "V2-V3";
                dt.Columns["V31"].ColumnName = "V3-V1";
                dt.Columns["V1_N"].ColumnName = "V1-N";
                dt.Columns["V2_N"].ColumnName = "V2-N";
                dt.Columns["V3_N"].ColumnName = "V3-N";
            }

            return dt;
        }

        protected DataTable FormatLgE650DT(DataTable dt)
        {
            // Format Table
            if (dt.Rows.Count > 0)
            {
                dt.Columns.Remove("ID");
                dt.Columns["Timestamp"].ColumnName = "Date";

                // Tidy the names
                var xx = new List<string>();
                foreach (DataColumn column in dt.Columns)
                {
                    if (column.ColumnName != "Date")
                    {
                        xx.Add(column.ColumnName);
                    }
                }

                foreach (string x in xx)
                {
                    string[] newColName = x.Split('_');
                    string Name = "";

                    for (int i = 0; i < newColName.Length; i++)
                    {
                        if (i < newColName.Length -1)
                        {
                            if (newColName[i] != "")
                            {
                                Name = Name + newColName[i] + ".";
                            }
                            else
                            {
                                Name = Name + newColName[i];
                            }
                        }
                        else
                        {
                            Name = Name + newColName[i];
                        }
                        
                    }
                    dt.Columns[x].ColumnName = Name;
                }

            }

            return dt;
        }

        protected DataTable FormatEhDT(DataTable dt, string ModbusId)
        {
            if (dt.Rows.Count > 0)
            {
                // Table formatting
                dt.Columns.Remove("ID");
                dt.Columns.Remove("ID_Location");
                dt.Columns["Timestamp"].ColumnName = "Date";

                // Array of Columns to remove
                var xx = new List<string>();
                foreach (DataColumn column in dt.Columns)
                {
                    // Split for number
                    string[] ColName = column.ColumnName.Split('_');

                    if (column.ColumnName != "Date" && ColName[1] != ModbusId)
                    {
                        xx.Add(column.ColumnName);
                    }
                }

                foreach (string x in xx)
                {
                    dt.Columns.Remove(x);
                }

                // Tidy the names
                var yy = new List<string>();
                foreach (DataColumn column in dt.Columns)
                {
                    if (column.ColumnName != "Date" && column.ColumnName.Contains(ModbusId))
                    {
                        yy.Add(column.ColumnName);
                    }
                }

                foreach (string y in yy)
                {
                    string[] newColName = y.Split('_');
                    dt.Columns[y].ColumnName = newColName[0];
                }
            }
            return dt;
        }

        protected DataTable getDataForSelectedDevice(int type, int IdLocation, DateTime startDate, DateTime endDate, int startRowIndex, int maximumRows)
        {
            DataTable tmpDT = new DataTable();

            int primarySiteId = (from s in RsDc.ed_Genset_GetPrimaryGensetIdByGensetId(IdLocation)
                                 select s.ID).SingleOrDefault();

            // Convert the IEnumerable result to a datatable
            // ComAp History
            if (type == -1)
            {
                Tuple<IEnumerable<ed_Genset_GetHistoryByIdResult>, int> result = db.SelectComApQuery(IdLocation, startDate, endDate);

                if (startRowIndex != -1 && maximumRows != -1)
                {
                    tmpDT = FormatComApDT(db.LINQToDataTable(result.Item1.Skip(startRowIndex).Take(maximumRows)));
                }
                else
                {
                    tmpDT = FormatComApDT(db.LINQToDataTable(result.Item1));
                }

                totalRecordsCount = result.Item2;

                // Return after we remove the empty columns
                return db.RemoveEmptyColumns(tmpDT);
            }
            else
            {
                // Get the meter category
                int? category = (from s in RsDc.EnergyMeters_Types where s.id == type select s.Meter_Category).SingleOrDefault();

                if (category == 1) // Heat Meter, Only one table to query
                {
                    var ModbusId = (from m in RsDc.EnergyMeters_Mappings
                                    where m.ID_Location == IdLocation && m.ID_Type == Convert.ToInt32(type)
                                    select m.Modbus_Addr).SingleOrDefault().ToString();

                    Tuple<IEnumerable<EnergyMeter>, int> result = db.SelectRH33Query(primarySiteId, startDate, endDate);

                    totalRecordsCount = result.Item2;

                    if (startRowIndex != -1 && maximumRows != -1)
                    {
                        return FormatEhDT(db.LINQToDataTable(result.Item1.Skip(startRowIndex).Take(maximumRows)), ModbusId);
                    }
                    else
                    {
                        return FormatEhDT(db.LINQToDataTable(result.Item1), ModbusId);
                    }
                }
                else if (category == 5) // Gas Meter
                {
                    var ModbusId = (from m in RsDc.GasMeters_Mappings
                                    where m.ID_Location == IdLocation && m.ID_Type == Convert.ToInt32(type)
                                    select m.Modbus_Addr).SingleOrDefault().ToString();

                    Tuple<IEnumerable<GasMeter>, int> result = db.SelectEHGasQuery(primarySiteId, startDate, endDate);

                    totalRecordsCount = result.Item2;

                    if (startRowIndex != -1 && maximumRows != -1)
                    {
                        return FormatEhDT(db.LINQToDataTable(result.Item1.Skip(startRowIndex).Take(maximumRows)), ModbusId);
                    }
                    else
                    {
                        return FormatEhDT(db.LINQToDataTable(result.Item1), ModbusId);
                    }
                }
                else
                {
                    // Electrical Meter, Data is in a specific table
                    // Get the meter map
                    var Map = (from s in RsDc.EnergyMeters_Mapping_Serials
                               join t in RsDc.EnergyMeters_MakeModels on s.ID_MakeModel equals t.ID
                               where s.ID_Location == IdLocation && s.ID_Type == type
                               select new { Serial = s.Serial, TableName = t.DataTableName }).SingleOrDefault();

                    if (Map.TableName == "dbo.EnergyMeters_Diris_A20")
                    {
                        Tuple<IEnumerable<EnergyMeters_Diris_A20>, int> result = db.SelectDirisA20Query(Map.Serial, startDate, endDate);

                        totalRecordsCount = result.Item2;

                        if (startRowIndex != -1 && maximumRows != -1)
                        {
                            return FormatDirisA20DT(db.LINQToDataTable(result.Item1.Skip(startRowIndex).Take(maximumRows)));
                        }
                        else
                        {
                            return FormatDirisA20DT(db.LINQToDataTable(result.Item1));
                        }
                    }
                    else if (Map.TableName == "dbo.EnergyMeters_LG_E650")
                    {
                        Tuple<IEnumerable<EnergyMeters_LG_E650>, int> result = db.SelectLgE650Query(Map.Serial, startDate, endDate);

                        totalRecordsCount = result.Item2;

                        if (startRowIndex != -1 && maximumRows != -1)
                        {
                            return FormatLgE650DT(db.LINQToDataTable(result.Item1.Skip(startRowIndex).Take(maximumRows)));
                        }
                        else
                        {
                            return FormatLgE650DT(db.LINQToDataTable(result.Item1));
                        }
                    }
                    else
                    {
                        return tmpDT;
                    }
                }
            }
        }

        // Select a specific page of data
        public DataTable SelectPage(int startRowIndex, int maximumRows, string id, string type, DateTime startDate, DateTime endDate)
        {
            try
            {
                return getDataForSelectedDevice(Convert.ToInt32(type), Convert.ToInt32(id), startDate, endDate, startRowIndex, maximumRows); 
            }
            catch (Exception ex) // Add a user message here
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('alert-warning', 'Oops!', 'The operation has timed out, please try again later..');", true);
                LogMe.LogSystemException(ex.Message);

                // Empty datatable
                DataTable tmpDT = new DataTable();
                return tmpDT;
            }
        }

        // Get the total number of records selected
        public int SelectCount(string id, string type, DateTime startDate, DateTime endDate)
        {
            return GetTotalRecordsCount();
        }

        public static int GetTotalRecordsCount()
        {
            return totalRecordsCount;
        }

        protected void ddlRecPerPage_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridHistory.PageSize = Int32.Parse(ddlRecPerPage.SelectedValue);
            GridHistory.PageIndex = 0;
            GridHistory.DataBind();
        }

        protected void GridHistory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Remove cell wrapping
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }

            // Format Date
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                System.Data.DataRowView dtview;
                DateTime dt;
                dtview = (DataRowView)e.Row.DataItem;

                if (dtview.Row.ItemArray[0] is System.DateTime)
                {
                    dt = (DateTime)dtview.Row.ItemArray[0];
                    e.Row.Cells[0].Text = dt.ToString("dd/MM/yyyy HH:mm:ss.000");
                }

                // Set cell tooltips
                // Really long winded, sort it out
                int primarySiteId = (from s in RsDc.ed_Genset_GetPrimaryGensetIdByGensetId(location)
                                     select s.ID).SingleOrDefault();

                string blackboxSN = (from s in RsDc.HL_Locations
                                  where s.ID == primarySiteId
                                  select s.BLACKBOX_SN).SingleOrDefault();

                int blackboxId = (from s in RsDc.Blackboxes
                                  where s.BB_SerialNo == blackboxSN
                                  select s.ID).SingleOrDefault();

                // Get the list of columns that are mapped
                IEnumerable<ComAp_BinaryTypes_Mapping> mapped = db.SelectMappedBinaryDefinitions(blackboxId);

                // Add tooltips to the comAp table
                // Loop through them and find the column by name
                if (type == -1)
                {
                    foreach (ComAp_BinaryTypes_Mapping map in mapped)
                    {
                        try
                        {
                            // Get the column index
                            int index = GetColumnIndexByName(e.Row, map.ColumnName);

                            // Get the columns mapped Binary#
                            string def = db.SelectBinaryDefinitions(map.ID_BinaryType);
                            string[] result = SplitBinaryDef(def);

                            // Get the column cell current value
                            char[] binarys = SplitBinary(e.Row.Cells[index].Text);

                            // Set the tooltip
                            e.Row.Cells[index].ToolTip = createToolTip(result, binarys);
                        }
                        catch
                        {
                            // Ignore
                        }
                    }
                }
            }

            int _TotalRecs = GetTotalRecordsCount();
            int _CurrentRecStart = GridHistory.PageIndex * GridHistory.PageSize + (GridHistory.Rows.Count == 0 ? 0 : 1); // Empty gv, start record at 0
            int _CurrentRecEnd = GridHistory.PageIndex * GridHistory.PageSize + GridHistory.Rows.Count;

            lblFooter.Text = string.Format("Displaying {0} to {1} of {2} records found", _CurrentRecStart, _CurrentRecEnd, _TotalRecs);

            fixHeaderRow();
        }

        // Split the binary definition
        string[] SplitBinaryDef(string def)
        {
            string[] temp = def.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries);

            for (int i = 0; i < temp.Count(); i++)
            {
                temp[i] = Regex.Replace(temp[i], @"(\d+)\s", "").Trim();
            }

            return temp;
        }

        // Split the binary cell
        char[] SplitBinary(string def)
        {
            return def.ToCharArray();
        }

        // Create the tooltip content by merging the binary cell & definition
        string createToolTip(string[] def, char[] bits)
        {
            string output = "";

            if (def.Count() == bits.Count())
            {
                for (int i = 0; i < def.Count(); i++)
                {
                    output = output + bits[i].ToString() + "=" + def[i];
                    if (i < def.Count() - 1)
                    {
                        output = output + "\n";
                    }
                }
                return output;
            }
            else
            {
                return "The definition is incorrect, please check the configuration.";
            }
        }

        // Get the index of a column by name
        int GetColumnIndexByName(GridViewRow row, string columnName)
        {
            int columnIndex = 0;
            foreach (DataControlFieldCell cell in row.Cells)
            {
                if (cell.ContainingField is BoundField)
                    if (((BoundField)cell.ContainingField).DataField.Equals(columnName))
                        break;
                columnIndex++; // keep adding 1 while we don't have the correct name
            }
            return columnIndex;
        }

        // Export to Excel
        protected void ExportExcel(string id, string type, DateTime startDate, DateTime endDate)
        {
            DataTable dt = getDataForSelectedDevice(Convert.ToInt32(type), Convert.ToInt32(id), startDate, endDate, -1, -1);

            if (dt.Rows.Count == 0)
            {
                //Nothing to save
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Unable to create file. No data available for export in the selected period.');", true);
            }
            else
            {
                //Get the sitename by id
                var gensetName = (from s in RsDc.HL_Locations
                                  where s.ID == Int32.Parse(id)
                                  select s.GENSETNAME).FirstOrDefault();

                //Set DataTable Name which will be the name of Excel Sheet.
                dt.TableName = gensetName.ToString();

                //Create a New Workbook.
                using (XLWorkbook wb = new XLWorkbook())
                {

                    //Add the DataTable as Excel Worksheet.
                    wb.Worksheets.Add(dt);

                    using (MemoryStream MS = new MemoryStream())
                    {
                        //Save the Excel Workbook to MemoryStream.
                        wb.SaveAs(MS);

                        MS.Position = 0;

                        //Send Excel attachment to client.
                        Response.Clear();
                        Response.Buffer = true;
                        Response.AppendHeader("content-disposition", "attachment;filename=" + gensetName.ToString() + "_" + DateTime.Now.ToString("dd-MM-yyyy") + ".xlsx");
                        Response.ContentType = "application/vnd.ms-excel";
                        Response.BinaryWrite(MS.ToArray());
                        Response.End();

                        MS.Close();
                    }
                }
            }
        }

        // Email with Excel attachment
        protected void EmailExcel(string id, string type, string emailaddr, DateTime startDate, DateTime endDate)
        {
            DataTable dt = getDataForSelectedDevice(Convert.ToInt32(type), Convert.ToInt32(id), startDate, endDate, -1, -1);

            if (dt.Rows.Count == 0)
            {
                //Nothing to save
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Unable to send email. No data available for export in the selected period.');", true);
            }
            else
            {
                try
                {
                    //Get the sitename by id
                    var gensetName = (from s in RsDc.HL_Locations
                                      where s.ID == Int32.Parse(id)
                                      select s.GENSETNAME).FirstOrDefault();

                    //Set DataTable Name which will be the name of Excel Sheet.
                    dt.TableName = gensetName.ToString();

                    //Create a New Workbook.
                    using (XLWorkbook wb = new XLWorkbook())
                    {

                        //Add the DataTable as Excel Worksheet.
                        wb.Worksheets.Add(dt);

                        using (MemoryStream MS = new MemoryStream())
                        {
                            //Save the Excel Workbook to MemoryStream.
                            wb.SaveAs(MS);
                            MS.Position = 0;

                            byte[] bytes = MS.ToArray();
                            MS.Close();

                            //Build the message body
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();

                            sb.Append("<div style='font-family:Open Sans,Helvetica Neue,Helvetica,Arial,sans-serif; font-size: 14px'>");
                            sb.Append("Please find the attached history export.");
                            sb.Append("<br/>");
                            sb.Append("Sent by: "); 
                            sb.Append("<br/>");
                            sb.Append("User Message: " + tbEmailMsg.Text);
                            sb.Append("<br/>");
                            sb.Append("Please do not reply to this email.");
                            sb.Append("</div>");

                            // email
                            EdinaEmailService email = new EdinaEmailService();
                            EdinaMessage msg = new EdinaMessage();

                            msg.Destination = emailaddr;
                            msg.Subject = "History Export - " + gensetName.ToString();
                            msg.Body = sb.ToString();
                            msg.IsBodyHtml = true;
                            //ContentType ct = new ContentType();
                            //ct.MediaType = MediaTypeNames.Application.Octet;
                            //ct.Name = "test.xlsx";
                            msg.Attachment = new Attachment(new MemoryStream(bytes), gensetName.ToString() + "_" + DateTime.Now.ToString("dd-MM-yyyy") + ".xlsx", "application/vnd.ms-excel");
                            //ContentDisposition dis = msg.Attachment.ContentDisposition;
                            //dis.CreationDate = DateTime.Now;
                            //dis.ModificationDate = DateTime.Now;
                            //dis.FileName = msg.Attachment.Name;
                            //dis.ReadDate = DateTime.Now;
                            //dis.Size = MS.Length;
                            //dis.DispositionType = DispositionTypeNames.Attachment;

                            email.AsyncSendEmail(msg);

                            LogMe.LogUserMessage(string.Format("History data emailed for generaror id:{0}, to recipient:{1} for period:{2} to {3}", id, emailaddr, startDate.ToString("dd-MM-yyyy"), endDate.ToString("dd-MM-yyyy")));

                            Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('success', 'Success!', 'The email has been sent to: " + emailaddr + ".');", true);
                        }
                    }
                 }
                 catch (Exception ex)
                 {
                   Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Somethings gone wrong, the administrator has been notified.');", true);
                 }
            }

        }

        protected void btnDownloadXls_Click(object sender, EventArgs e)
        {
            ExportExcel(location.ToString(), type.ToString(), DateRangeSelect.StartDate, DateRangeSelect.EndDate);

            LogMe.LogUserMessage(string.Format("History data downloaded for generator id:{0} for period:{1} to {2}", location, DateRangeSelect.StartDate.ToString("dd-MM-yyyy"), DateRangeSelect.StartDate.ToString("dd-MM-yyyy")));
        }

        protected void btnEmailXls_Click(object sender, EventArgs e)
        {
            // Present the modal
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#historyEmailModal').modal('show');");
            sb.Append(@"</script>");

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "historyEmailModalScript", sb.ToString(), false);
        }

        protected void btnSendEmail_Click(object sender, EventArgs e)
        {
           if (Page.IsValid)
           {
               EmailExcel(location.ToString(), type.ToString(), tbEmailAdd.Text.ToString(), DateRangeSelect.StartDate, DateRangeSelect.EndDate);
           }
        }
    }
}