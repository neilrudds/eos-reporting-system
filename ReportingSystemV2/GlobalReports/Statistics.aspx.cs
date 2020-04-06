using ClosedXML.Excel;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.GlobalReports
{
    public partial class Statistics : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Attach to UserControl Event
            Master.globalReportDateChanged += new EventHandler(report_DateChanged);

            if (!IsPostBack)
            {
                //ClientScript.RegisterClientScriptBlock(GetType(), "UseSingleDate", "var UseSingleDate = true;", true);
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateGeneratorReadings();
            }

            if (gridGeneratorReadings.Rows.Count > 0)
            {
                //CSS Header Sytle
                gridGeneratorReadings.UseAccessibleHeader = true;
                gridGeneratorReadings.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        private void report_DateChanged(object sender, EventArgs e)
        {
            PopulateGeneratorReadings();
        }

        protected void PopulateGeneratorReadings()
        {
            GlobalReportsBase f = (GlobalReportsBase)Page.Master;

            var gens = new List<string> { };

            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            // Get the current logged in User and look up the user in ASP.NET Identity
            var currentUser = manager.FindById(User.Identity.GetUserId());

            // Get the site access array to list for query
            gens = currentUser.SiteAccessArray.Split(',').ToList();

            var userSites = RsDc.HL_Locations.Where(l => l.GensetEnabled == true).Where(l => gens.Contains(l.ID.ToString()));

            // Join HL_Location & GeneratorContents, then select latest records grouped by location

            if (f.startDate.Date == f.endDate.Date)
            {
                var result = (from site in userSites
                          join log in RsDc.GeneratorContents on site.ID equals log.IdLocation
                          where log.TimeStamp.Date == f.startDate.Date
                          select new
                          {
                              Generator = site.GENSETNAME,
                              Date = log.TimeStamp,
                              Runhours = log.Runhrs,
                              kW = log.kWhour
                          }).GroupBy(s => s.Generator)
                             .Select(s => s.OrderByDescending(x => x.Date).FirstOrDefault());

                // Display in alphabetical order
                gridGeneratorReadings.DataSource = result.OrderBy(s => s.Generator).ToList();
                gridGeneratorReadings.DataBind();
            }
            else
            {

                var result1 = (from s in userSites
                              join log in RsDc.GeneratorContents on s.ID equals log.IdLocation
                              where log.TimeStamp.Date == f.startDate.Date
                              select new
                              {
                                  Id = s.ID,
                                  Generator = s.GENSETNAME,
                                  Date = log.TimeStamp,
                                  Runhours = log.Runhrs,
                                  kW = log.kWhour
                              }).GroupBy(s => s.Generator)
                             .Select(s => s.OrderByDescending(x => x.Date).FirstOrDefault());

                var result2 = (from s in userSites
                               join log in RsDc.GeneratorContents on s.ID equals log.IdLocation
                               where log.TimeStamp.Date == f.endDate.Date
                               select new
                              {
                                  Id = s.ID,
                                  Generator = s.GENSETNAME,
                                  Date = log.TimeStamp,
                                  Runhours = log.Runhrs,
                                  kW = log.kWhour
                              }).GroupBy(s => s.Generator)
                             .Select(s => s.OrderByDescending(x => x.Date).FirstOrDefault());

                var resultSum =
                    (from d1 in result1
                    join d2 in result2 on d1.Id equals d2.Id
                    select new
                    {
                        Generator = d1.Generator,
                        StDate = d1.Date,
                        StRunhrs = d1.Runhours,
                        StkW = d1.kW,
                        EndDate = d2.Date,
                        EndRunhrs = d2.Runhours,
                        EndkW = d2.kW,
                        DiffRunhrs = (d1.Runhours == null || d2.Runhours == null ? 0 : (Convert.ToInt32(d2.Runhours) - Convert.ToInt32(d1.Runhours))).ToString(),
                        DiffkW = (d1.kW == null || d2.kW == null ? 0 : (Convert.ToInt32(d2.kW) - Convert.ToInt32(d1.kW))).ToString()
                    });

                // Display in alphabetical order
                gridGeneratorReadings.DataSource = resultSum.OrderBy(s => s.Generator).ToList();
                gridGeneratorReadings.DataBind();

            }
        }

        protected void btnDownloadXls_ServerClick(object sender, EventArgs e)
        {
            GlobalReportsBase f = (GlobalReportsBase)Page.Master;

            DB db = new DB();

            DataTable dt = new DataTable();

            var gens = new List<string> { };

            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            // Get the current logged in User and look up the user in ASP.NET Identity
            var currentUser = manager.FindById(User.Identity.GetUserId());

            // Get the site access array to list for query
            gens = currentUser.SiteAccessArray.Split(',').ToList();

            var userSites = RsDc.HL_Locations.Where(l => l.GensetEnabled == true)
                                           .Where(l => gens.Contains(l.ID.ToString()));
            
            var query = (dynamic)null;

            if (f.startDate.Date == f.endDate.Date)
            {
                

                query = (from site in userSites
                          join log in RsDc.GeneratorContents on site.ID equals log.IdLocation
                          where log.TimeStamp.Date == f.startDate.Date
                          select new
                          {
                              Generator = site.GENSETNAME,
                              Date = log.TimeStamp,
                              Runhours = log.Runhrs,
                              kW = log.kWhour
                          }).GroupBy(s => s.Generator)
                             .Select(s => s.OrderByDescending(x => x.Date).FirstOrDefault()).OrderBy(s => s.Generator).ToList();
            }
            else
            {

                    var result1 = (from s in userSites
                              join log in RsDc.GeneratorContents on s.ID equals log.IdLocation
                              where log.TimeStamp.Date == f.startDate.Date
                              select new
                              {
                                  Id = s.ID,
                                  Generator = s.GENSETNAME,
                                  Date = log.TimeStamp,
                                  Runhours = log.Runhrs,
                                  kW = log.kWhour
                              }).GroupBy(s => s.Generator)
                             .Select(s => s.OrderByDescending(x => x.Date).FirstOrDefault());

                var result2 = (from s in userSites
                               join log in RsDc.GeneratorContents on s.ID equals log.IdLocation
                               where log.TimeStamp.Date == f.endDate.Date
                               select new
                              {
                                  Id = s.ID,
                                  Generator = s.GENSETNAME,
                                  Date = log.TimeStamp,
                                  Runhours = log.Runhrs,
                                  kW = log.kWhour
                              }).GroupBy(s => s.Generator)
                             .Select(s => s.OrderByDescending(x => x.Date).FirstOrDefault());

                query = (from d1 in result1
                    join d2 in result2 on d1.Id equals d2.Id
                    select new
                    {
                        Generator = d1.Generator,
                        StDate = d1.Date,
                        StRunhrs = d1.Runhours,
                        StkW = d1.kW,
                        EndDate = d2.Date,
                        EndRunhrs = d2.Runhours,
                        EndkW = d2.kW,
                        DiffRunhrs = (d1.Runhours == null || d2.Runhours == null ? 0 : (Convert.ToInt32(d2.Runhours) - Convert.ToInt32(d1.Runhours))).ToString(),
                        DiffkW = (d1.kW == null || d2.kW == null ? 0 : (Convert.ToInt32(d2.kW) - Convert.ToInt32(d1.kW))).ToString()
                    }).OrderBy(s => s.Generator).ToList();
            }

            dt = db.LINQToDataTable(query);

            if (dt.Rows.Count == 0)
            {
                //Nothing to save
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Unable to create file. No data available for export in the selected period.');", true);
            }
            else
            {
                //Set DataTable Name which will be the name of Excel Sheet.
                dt.TableName = "Statistics";

                foreach (DataColumn column in dt.Columns)
                {
                    switch (column.ColumnName)
                    {
                        case "StDate":
                            column.ColumnName = "Start Date";
                            break;
                        case "StRunhrs":
                            column.ColumnName = "Start Runhours";
                            break;
                        case "StkW":
                            column.ColumnName = "Start kW";
                            break;
                        case "EndDate":
                            column.ColumnName = "End Date";
                            break;
                        case "EndRunhrs":
                            column.ColumnName = "End Runhours";
                            break;
                        case "EndkW":
                            column.ColumnName = "End kW";
                            break;
                        case "DiffRunhrs":
                            column.ColumnName = "Difference Runhours";
                            break;
                        case "DiffkW":
                            column.ColumnName = "Difference kW";
                            break;
                        default:
                            break;
                    }
                }

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
                        Response.AppendHeader("content-disposition", "attachment;filename=" + "Statistics" + "_" + DateTime.Now.ToString("dd-MM-yyyy") + ".xlsx");
                        Response.ContentType = "application/vnd.ms-excel";
                        Response.BinaryWrite(MS.ToArray());
                        Response.End();

                        MS.Close();
                    }
                }
            }
        }

        protected void gridGeneratorReadings_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Tidy headers
            if (e.Row.RowType == DataControlRowType.Header)
            {
                foreach (TableCell head in e.Row.Cells)
                {
                    switch (head.Text)
                    {
                        case "StDate":
                            head.Text = "Start Date";
                            break;
                        case "StRunhrs":
                            head.Text = "Start Runhours";
                            break;
                        case "StkW":
                            head.Text = "Start kW";
                            break;
                        case "EndDate":
                            head.Text = "End Date";
                            break;
                        case "EndRunhrs":
                            head.Text = "End Runhours";
                            break;
                        case "EndkW":
                            head.Text = "End kW";
                            break;
                        case "DiffRunhrs":
                            head.Text = "Difference Runhours";
                            break;
                        case "DiffkW":
                            head.Text = "Difference kW";
                            break;
                        default:
                            break;
                    }
                }
            }

            // Thousands seperator
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                foreach (TableCell cell in e.Row.Cells)
                {

                    if (cell.Text == "&nbsp;")
                    {
                        cell.Text = "Data unavailable.";
                    }
                    else
                    {
                        int n;
                        var isNumeric = int.TryParse(cell.Text, out n);

                        if (isNumeric)
                        {
                            cell.Text = string.Format("{0:n0}", n);
                        }
                    }
                }   
            }
        }
    }
}