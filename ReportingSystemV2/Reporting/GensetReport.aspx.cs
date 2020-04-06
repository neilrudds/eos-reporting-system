using DotNet.Highcharts.Enums;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Options;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Reporting
{
    public partial class GensetReport : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        DB db = new DB();

        [PersistenceMode(PersistenceMode.Attribute)]
        public int id_location
        {
            get
            {
                if (ViewState["id_location"] == null)
                    ViewState["id_location"] = 0;

                return (int)ViewState["id_location"];
            }
            set
            {
                ViewState["id_location"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Attach to UserControl Event
            Master.reportDateChanged += new EventHandler(report_DateChanged);
        }
                
        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;

            ChartBuilder Cb = new ChartBuilder();

            if (!Page.IsPostBack)
            {
                if (f.IdLocation != 0)
                {
                    id_location = f.IdLocation; // Save Location to Viewstate

                    if (f.endDate < f.startDate)
                    {
                        //reportSummary.Attributes["class"] = "messageoverlay";
                        Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Please select a valid date range..');", true);
                    }

                    if (bindContractInformation(f.IdLocation))
                    {
                        bindSummaryExempts(f.IdLocation, f.startDate, f.endDate);
                        bindPerformance(f.IdLocation, f.startDate, f.endDate);
                    }

                    // Charts
                    likWhPerDayChart.Text = Cb.GetColumnDifferenceByDayChartNoFillJS(f.IdLocation, 7, f.startDate, f.endDate, false, "kWh", "Energy Generated", "kWh Per Day");
                    liShutdownsChart.Text = Cb.GetDowntimeReasonsChartJS(f.IdLocation, f.startDate, f.endDate);
                    liRunHoursPerDayChart.Text = Cb.GetColumnDifferenceByDayChartNoFillJS(f.IdLocation, 6, f.startDate, f.endDate, false, "Runhrs", "Run Hours", "Run hours Per Day");
                }
                else
                {
                    //reportSummary.Attributes["class"] = "messageoverlay";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'Please select a site..');", true);
                }
            }
        }

        private void report_DateChanged(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;
            ChartBuilder Cb = new ChartBuilder();

            // Data
            bindSummaryExempts(id_location, f.startDate, f.endDate);
            bindPerformance(id_location, f.startDate, f.endDate);

            // Charts
            string myJSCode;
            myJSCode = Cb.GetColumnDifferenceByDayChartNoFillJS(f.IdLocation, 7, f.startDate, f.endDate, true, "kWh", "Energy Generated", "kWh Per Day");
            myJSCode += Cb.GetColumnDifferenceByDayChartNoFillJS(f.IdLocation, 6, f.startDate, f.endDate, true, "Runhrs", "Run Hours", "Run hours Per Day");
            myJSCode += Cb.chartHtmltoScript(Cb.GetDowntimeReasonsChartJS(id_location, f.startDate, f.endDate));
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
        }

        // Section 1
        protected bool bindContractInformation(int location)
        {
            var contractID = (from s in RsDc.HL_Locations
                              where s.ID == location
                              select s).FirstOrDefault();

            var contract = (from c in RsDc.ContractInformations
                            where c.ID == contractID.ID_ContractInformation
                            select new
                            {
                                Output = c.ContractOutput,
                                Availability = c.ContractAvailability,
                                DutyCycle = c.DutyCycle,
                                Length = c.ContractLength,
                                StartDate = c.ContractStartDate,
                                InitialRunHrs = c.InitialRunHrs,
                                initialkWh = c.InitialKwHours
                            }).FirstOrDefault();

            if (contract != null)
            {

                lblContractType.Text = db.GetContractType(location);
                lblContractOutput.Text = contract.Output.ToString();
                lblContractAvailability.Text = contract.Availability.ToString();
                lblContractDutyCycle.Text = contract.DutyCycle.ToString();
                lblContractStartDate.Text = string.Format("{0:dd/MM/yyyy}", contract.StartDate);
                lblContractDuration.Text = contract.Length.ToString();
                return true;
            }
            else
            {
                //reportSummary.Attributes["class"] = "messageoverlay";
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('danger', 'Oops!', 'Contract information is missing for this site..');", true);
                return false;
            }

        }

        // Section 2
        protected void bindPerformance(int location, DateTime startDate, DateTime endDate)
        {
            // Get the Values
            decimal Runhrs = db.GetActualHoursRun(location, startDate, endDate);
            decimal kWhours = db.GetActualkWhProduced(location, startDate, endDate);

            decimal? avgOutput = 0;
            if (Runhrs != 0)
            {
                avgOutput = kWhours / Runhrs;
            }

            // What type of report, Shutdowns or Availibility
            var report = (from r in RsDc.ConfigReports
                          where r.IdLocation == location
                          select r).FirstOrDefault();

            if (report != null && report.AvailabilityBasedOnUnitUnavailableFlag == true)
            {
                int? minsUnavailable = RsDc.GeneratorAvailabilities
                                  .Where(a => a.DtUnavailable >= startDate && a.DtUnavailable < endDate.AddHours(23).AddMinutes(59).AddSeconds(59) 
                                    && a.IdLocation == location && (a.Exclude == false || a.Exclude == null))
                                  .Sum(a => (int?)a.TimeDifference);

                double dblMinsUnavalilable = 0.0;
                if (minsUnavailable != null)
                {
                    dblMinsUnavalilable = (double)minsUnavailable;
                }

                lblHrsAvailable.Text = string.Format("{0:0.00}", ((endDate.AddDays(1) - startDate).TotalMinutes - dblMinsUnavalilable) / 60);
            }
            else
            {
                lblHrsAvailable.Text = "N/A";
            }

            // Set the Values
            lblPeriodDays.Text = (endDate.AddDays(1) - startDate).TotalDays.ToString();
            lblPeriodHours.Text = (endDate.AddDays(1) - startDate).TotalHours.ToString();
            lblHrsRun.Text = Runhrs.ToString();
            lblkWh.Text = kWhours.ToString();
            lblAvgOutput.Text = string.Format("{0:0.00}", avgOutput);

            Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "contractPerformance();", true);
        }

        // Section 3
        protected void bindSummaryExempts(int location, DateTime startDate, DateTime endDate)
        {
            var ReportConfig = (from cfg in RsDc.ConfigReports where cfg.IdLocation == location select cfg).FirstOrDefault();

            if (ReportConfig != null && ReportConfig.AvailabilityBasedOnUnitUnavailableFlag == true)
            {

                var availability = (from a in RsDc.GeneratorAvailabilities
                                    where a.IdLocation == location && a.DtUnavailable >= startDate && a.DtAvailable < endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
                                    select new
                                    {
                                        dtdown = a.DtUnavailable,
                                        dtup = a.DtAvailable,
                                        timedifference = a.TimeDifference,
                                        reason = a.Reason,
                                        YesNo = (a.IsExempt == true) ? "Yes" : (a.IsExempt == false) ? "No" : "Unverified",
                                        DETAILS = a.Details,
                                        IsExempt = a.IsExempt
                                    });

                StringBuilder Sb = new StringBuilder();

                int? totalExempts = availability.Where(a => a.IsExempt == true).Sum(a => (int?)a.timedifference);
                int? totalNonExempts = availability.Where(a => a.IsExempt == null || a.IsExempt == false).Sum(a => (int?)a.timedifference);

                TimeSpan tsTotalExempts = new TimeSpan(0, Convert.ToInt32(totalExempts), 0);
                TimeSpan tsTotalNonExempts = new TimeSpan(0, Convert.ToInt32(totalNonExempts), 0);

                Sb.Append("<br />Total Exempt Availability: <b>" + (tsTotalExempts.Days * 24 + tsTotalExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0")) + "</b>");
                Sb.Append("<br />Total Non-Exempt Availability: <b>" + (tsTotalNonExempts.Days * 24 + tsTotalNonExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalNonExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0")) + "</b>");

                Sb.Append("<input type=\"hidden\" id=\"totalExemptDowntime\" value=\"" + tsTotalExempts.TotalHours.ToString() + "\"></input>");
                Sb.Append("<input type=\"hidden\" id=\"totalNonExemptDowntime\" value=\"" + tsTotalNonExempts.TotalHours.ToString() + "\"></input>");

                exemptsFooter.InnerHtml = Sb.ToString();

                gridSummaryExempts.DataSource = availability;
                gridSummaryExempts.DataBind();
            }
            else
            {

                // Remove the excluded downtimes for the report and calculations
                DataTable tmpDT = db.getDowntime_SplitTimes(location, startDate, endDate, true, false);
                StringBuilder SB = new StringBuilder();

                // Calculate the exempts duration
                int totalExempts = 0;
                int totalNonExempts = 0;


                if (tmpDT.Rows.Count > 0)
                {
                    foreach (DataRow dr in tmpDT.Rows)
                    {
                        if (dr["ISEXEMPT"] != System.DBNull.Value && Convert.ToBoolean(dr["ISEXEMPT"]))
                        {
                            totalExempts += Convert.ToInt32(dr["TIMEDIFFERENCE"]);
                        }
                        else
                        {
                            totalNonExempts += Convert.ToInt32(dr["TIMEDIFFERENCE"]);
                        }
                    }
                }

                TimeSpan tsTotalExempts = new TimeSpan(0, totalExempts, 0);
                TimeSpan tsTotalNonExempts = new TimeSpan(0, totalNonExempts, 0);

                SB.Append("<br />Total Exempt Downtime: <b>" + (tsTotalExempts.Days * 24 + tsTotalExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0")) + "</b>");
                SB.Append("<br />Total Non-Exempt Downtime: <b>" + (tsTotalNonExempts.Days * 24 + tsTotalNonExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalNonExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0")) + "</b>");

                SB.Append("<input type=\"hidden\" id=\"totalExemptDowntime\" value=\"" + tsTotalExempts.TotalHours.ToString() + "\"></input>");
                SB.Append("<input type=\"hidden\" id=\"totalNonExemptDowntime\" value=\"" + tsTotalNonExempts.TotalHours.ToString() + "\"></input>");

                exemptsFooter.InnerHtml = SB.ToString();

                gridSummaryExempts.DataSource = tmpDT;
                gridSummaryExempts.DataBind();
            }

            if (gridSummaryExempts.Rows.Count != 0)
            {
                //CSS Header Sytle
                gridSummaryExempts.UseAccessibleHeader = true;
                gridSummaryExempts.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected string GetTimeStamp(DateTime value)
        {
            return value.ToString("dd-MM-yyyy");
        }

        protected string GetGeneratorNameById(int IdLocation)
        {
            try
            {
                var Generator = (from l in RsDc.HL_Locations where l.ID == IdLocation select l).FirstOrDefault();

                if (Generator.GENSETNAME != "")
                {
                    return Generator.GENSETNAME;
                }
                else
                {
                    return "Unknown";
                }
            }
            catch
            {
                return "Unknown";
            }
        }

        protected void btnCreateReportPDF_Click(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;
            ReportBuilder rb = new ReportBuilder();
            bool AvailabilityFlag = false;

            try
            {
                var report = (from r in RsDc.ConfigReports where r.IdLocation == f.IdLocation select r).FirstOrDefault();

                if (report != null && report.AvailabilityBasedOnUnitUnavailableFlag == true)
                {
                    AvailabilityFlag = true;
                }

                // Get the PDF Report to a Byte Array
                Byte[] content = rb.CreateGeneratorReportPDF_Monthly(f.IdLocation, f.startDate, f.endDate, AvailabilityFlag);
                // Pass to the user
                Response.ContentType = "application/pdf";
                Response.AppendHeader("content-disposition", "attachment;filename=" + GetGeneratorNameById(f.IdLocation) + "_" + GetTimeStamp(DateTime.Now) + ".pdf");
                Response.AddHeader("Content-Length", content.Length.ToString());
                Response.OutputStream.Write(content, 0, content.Length);
        }
            catch (Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'The PDF Report could not be generated, please try again later. If the problem persists then contact an administrator..');", true);
        }
    }
    }
}
