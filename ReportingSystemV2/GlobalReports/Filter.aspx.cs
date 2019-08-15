using ClosedXML.Excel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2.GlobalReports
{
    public partial class Filter : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        ReportingSystemV2.Models.UserSites userSites = new ReportingSystemV2.Models.UserSites();

        protected void Page_Init(object sender, EventArgs e)
        {
            AsyncPostBackTrigger trig = new AsyncPostBackTrigger();
            trig.ControlID = ddlSelectGenerator.UniqueID; //Unique ID, not client ID 
            trig.EventName = "SelectedIndexChanged";
            updFilter.Triggers.Add(trig); 
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Attach to UserControl Event
            Master.globalReportDateChanged += new EventHandler(report_DateChanged);
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                populateddlSelectGenerator();
                BindFilterTable();
            }

            if (gridFilter.Rows.Count > 0)
            {
                //CSS Header Sytle
                gridFilter.UseAccessibleHeader = true;
                gridFilter.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void populateddlSelectGenerator()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                ddlSelectGenerator.DataSource = (from s in RsDc.HL_Locations orderby s.GENSETNAME select s)
                    .Where(t => userSites.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));
                ddlSelectGenerator.DataTextField = "GENSETNAME";
                ddlSelectGenerator.DataValueField = "ID";
                ddlSelectGenerator.DataBind();

                // And add a default when value is NULL
                ddlSelectGenerator.Items.Insert(0, new ListItem("All Generators", "-1", true));
            }
        }

        private void report_DateChanged(object sender, EventArgs e)
        {
            BindFilterTable();
        }

        protected IEnumerable GetFilteredData(string table, DateTime startDate, DateTime endDate, int? locationId = null)
        {
            if (table == "Shutdowns")
            {
                if (locationId == null)
                {
                    var query = from s in RsDc.ed_Exempts_GetWithReason(startDate.Date, endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59))
                                select new
                                {
                                    Genset = s.Genset,
                                    Down = s.DTDOWN.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Up = s.DTUP.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Duration = s.TIMEDIFFERENCE,
                                    Exempt = s.YesNo,
                                    Reason = s.REASON,
                                    Notes = s.DETAILS
                                };
                    return query;
                }
                else
                {
                    var query = from s in RsDc.ed_Exempts_GetWithReasonAndGensetName(startDate, endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59), locationId)
                                select new
                                {
                                    Genset = s.Genset,
                                    Down = s.DTDOWN.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Up = s.DTUP.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Duration = s.TIMEDIFFERENCE,
                                    Exempt = s.YesNo,
                                    Reason = s.REASON,
                                    Notes = s.DETAILS
                                };
                    return query;
                }
            }
            else
            {
                return null;
            }
        }

        protected void BindFilterTable()
        {
            GlobalReportsBase f = (GlobalReportsBase)Page.Master;

            if (ddlSelectGenerator.SelectedValue == "-1")
            {
                gridFilter.DataSource = GetFilteredData(f.TableName, f.startDate, f.endDate);
            }
            else
            {
                gridFilter.DataSource = GetFilteredData(f.TableName, f.startDate, f.endDate, Convert.ToInt32(ddlSelectGenerator.SelectedValue));
            }
            gridFilter.DataBind();
        }

        protected void btnDownloadXls_ServerClick(object sender, EventArgs e)
        {
            GlobalReportsBase f = (GlobalReportsBase)Page.Master;
            DB db = new DB();

            DataTable dt = new DataTable();

            if (f.TableName == "Shutdowns")
            {
                var query = (dynamic)null;

                if (ddlSelectGenerator.SelectedValue == "-1")
                {
                    query = from s in RsDc.ed_Exempts_GetWithReason(f.startDate.Date, f.endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59))
                                select new
                                {
                                    Genset = s.Genset,
                                    Down = s.DTDOWN.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Up = s.DTUP.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Duration = s.TIMEDIFFERENCE,
                                    Exempt = s.YesNo,
                                    Reason = s.REASON,
                                    Notes = s.DETAILS
                                };
                }
                else
                {
                    query = from s in RsDc.ed_Exempts_GetWithReasonAndGensetName(f.startDate.Date, f.endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59), Convert.ToInt32(ddlSelectGenerator.SelectedValue))
                                select new
                                {
                                    Genset = s.Genset,
                                    Down = s.DTDOWN.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Up = s.DTUP.ToString("dd/MM/yyyy HH:mm:ss.000"),
                                    Duration = s.TIMEDIFFERENCE,
                                    Exempt = s.YesNo,
                                    Reason = s.REASON,
                                    Notes = s.DETAILS
                                };
                }
                dt = db.LINQToDataTable(query);
            }

            if (dt.Rows.Count == 0)
            {
                //Nothing to save
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Unable to create file. No data available for export in the selected period.');", true);
            }
            else
            {
                //Set DataTable Name which will be the name of Excel Sheet.
                dt.TableName = f.TableName;

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
                        Response.AppendHeader("content-disposition", "attachment;filename=" + f.TableName + "_" + DateTime.Now.ToString("dd-MM-yyyy") + ".xlsx");
                        Response.ContentType = "application/vnd.ms-excel";
                        Response.BinaryWrite(MS.ToArray());
                        Response.End();

                        MS.Close();
                    }
                }
            }
        }

        protected void ddlSelectGenerator_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindFilterTable();
        }        
    }
}