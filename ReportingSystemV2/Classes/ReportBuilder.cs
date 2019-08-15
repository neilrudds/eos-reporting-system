using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.IO;
using System.Data;
using System.Net;
using System.Text;
using System.Drawing.Imaging;
using DotNet.Highcharts.Options;
using DotNet.Highcharts.Helpers;

namespace ReportingSystemV2
{
    public class ReportBuilder
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        DB db = new DB();

        public byte[] GetGeneratorReportPDF(int IdLocation, DateTime StartDate, DateTime EndDate, int PeriodType)
        {
            if (PeriodType == 0) //Default Monthly Summary Report
            {
                return CreateGeneratorReportPDF_Monthly(IdLocation, StartDate, EndDate);
            }
            else
            {
                return null;
            }
        }

        public byte[] GetGeneratorReportPDF(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            // Overload, If not PeriodType selected then set then default to 0
            return GetGeneratorReportPDF(IdLocation, StartDate, EndDate, 0);
        }

        protected List<IElement> GetGeneratorSummary(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            // Generator Site Properties
            var Generator = (from l in RsDc.HL_Locations where l.ID == IdLocation select l).FirstOrDefault();

            // Generator Contract Properties
            var contract = (from c in RsDc.ContractInformations where c.ID == Generator.ID_ContractInformation select c).FirstOrDefault();

            // Get Performance Data
            decimal hrsRun = Convert.ToInt32(RsDc.ed_Genset_GetActualHoursRunById(IdLocation, StartDate, EndDate).FirstOrDefault().Hrs);
            decimal kWh = Convert.ToInt32(RsDc.ed_Genset_GetActualkWhProducedById(IdLocation, StartDate, EndDate).FirstOrDefault().kWh);
            decimal TotHrsRun = Convert.ToInt32(RsDc.ed_Genset_GetTotalHoursRunById(IdLocation).FirstOrDefault().Hrs);
            decimal TotkWh = Convert.ToInt32(RsDc.ed_Genset_GetTotalkWhProducedById(IdLocation).FirstOrDefault().kWh);

            // Calc Average Output
            decimal avgOutput = 0;
            if (hrsRun != 0) { avgOutput = kWh / hrsRun; }

            // Populate the HTML with Values
            if (Generator != null && contract != null)
            {
                //Read in the contents of the HTML template file...
                string contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary.htm"));

                //Contract information & Generator performance
                //Replace the placeholders with the user-specified text
                //Page Header
                contents = contents.Replace("[SITENAME]", Generator.SITENAME.ToString());
                contents = contents.Replace("[ENGINENAME]", Generator.GENSETNAME.ToString());
                contents = contents.Replace("[OPERATINGPERIOD]", StartDate.ToString("dd-MM-yyyy") + " to " + EndDate.ToString("dd-MM-yyyy"));

                //Contract Information
                contents = contents.Replace("[CONTRACTTYPE]", db.GetContractType(IdLocation));
                contents = contents.Replace("[CONTRACTOUTPUT]", contract.ContractOutput.ToString());
                contents = contents.Replace("[CONTRACTAVAILABILITY]", string.Format("{0:0.000}", contract.ContractAvailability));
                contents = contents.Replace("[CONTRACTDUTYCYCLE]", contract.DutyCycle.ToString());
                contents = contents.Replace("[CONTRACTSTARTDATE]", string.Format("{0:dd-MM-yyyy}", contract.ContractStartDate));
                contents = contents.Replace("[CONTRACTLENGTH]", contract.ContractLength.ToString());

                //Generator Performance Summary
                contents = contents.Replace("[PERFDAYS]", (EndDate.AddDays(1) - StartDate).TotalDays.ToString() + " (" + (EndDate.AddDays(1) - StartDate).TotalHours.ToString() + "h)");
                contents = contents.Replace("[PERFHOURS]", hrsRun.ToString());
                contents = contents.Replace("[PERFKWH]", kWh.ToString());
                contents = contents.Replace("[PERFAVGOUTPUT]", string.Format("{0:0.00}", avgOutput));

                // Contract Performance Summary
                // Get the Exempts Totals, remove the excluded items from the calculation
                DataTable tmpDT = db.getDowntime_SplitTimes(IdLocation, StartDate, EndDate, true, false);

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

                string totalExemptDowntime = (tsTotalExempts.Days * 24 + tsTotalExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0"));
                string totalNonExemptDowntime = (tsTotalNonExempts.Days * 24 + tsTotalNonExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalNonExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0"));

                int grossdays = Convert.ToInt32((EndDate.AddDays(1) - StartDate).TotalDays);
                int grosskW = grossdays * contract.ContractOutput * contract.DutyCycle;
                decimal targetkW = grosskW * (decimal)contract.ContractAvailability;
                decimal exemptkW = (decimal)contract.ContractOutput * (decimal)tsTotalExempts.TotalHours;
                decimal totalkW = (decimal)exemptkW + kWh;
                decimal availabilitykW = totalkW / grosskW;

                contents = contents.Replace("[GROSSKW]", grosskW.ToString());
                contents = contents.Replace("[TARGETKW]", string.Format("{0:0.00}", targetkW));
                contents = contents.Replace("[EXEMPTKW]", string.Format("{0:0.00}", exemptkW));
                contents = contents.Replace("[TOTALKW]", string.Format("{0:0.00}", totalkW));
                contents = contents.Replace("[AVAILKW]", string.Format("{0:0.00}", (availabilitykW * 100)) + "%");

                decimal grosshrs = Convert.ToInt32((EndDate.AddDays(1) - StartDate).TotalHours);
                decimal targethrs = grosshrs * (decimal)contract.ContractAvailability;
                decimal exempthrs = (decimal)tsTotalExempts.TotalHours;
                decimal totalhrs = exempthrs + hrsRun;
                decimal availabilityhrs = totalhrs / grosshrs;

                contents = contents.Replace("[GROSSHRS]", grosshrs.ToString());
                contents = contents.Replace("[TARGETHRS]", string.Format("{0:0.00}", targethrs));
                contents = contents.Replace("[EXEMPTHRS]", string.Format("{0:0.00}", exempthrs));
                contents = contents.Replace("[TOTALHRS]", string.Format("{0:0.00}", totalhrs));
                contents = contents.Replace("[AVAILHRS]", string.Format("{0:0.00}", (availabilityhrs * 100)) + "%");

                // Parse the HTML string into a collection of elements...
                return iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
            }
            else
            {
                return iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(""), null);
            }

        }

        protected List<IElement> GetGeneratorSummaryAvailabilityFlag(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            // Generator Site Properties
            var Generator = (from l in RsDc.HL_Locations where l.ID == IdLocation select l).FirstOrDefault();

            // Generator Contract Properties
            var contract = (from c in RsDc.ContractInformations where c.ID == Generator.ID_ContractInformation select c).FirstOrDefault();

            // Get Performance Data
            decimal hrsRun = Convert.ToInt32(RsDc.ed_Genset_GetActualHoursRunById(IdLocation, StartDate, EndDate).FirstOrDefault().Hrs);
            decimal kWh = Convert.ToInt32(RsDc.ed_Genset_GetActualkWhProducedById(IdLocation, StartDate, EndDate).FirstOrDefault().kWh);
            decimal TotHrsRun = Convert.ToInt32(RsDc.ed_Genset_GetTotalHoursRunById(IdLocation).FirstOrDefault().Hrs);
            decimal TotkWh = Convert.ToInt32(RsDc.ed_Genset_GetTotalkWhProducedById(IdLocation).FirstOrDefault().kWh);

            // Get the hours available
            int? minsUnavailable = RsDc.GeneratorAvailabilities
                                  .Where(a => a.DtUnavailable >= StartDate && a.DtUnavailable < EndDate.AddHours(23).AddMinutes(59).AddSeconds(59)
                                    && a.IdLocation == IdLocation && (a.Exclude == false || a.Exclude == null))
                                  .Sum(a => (int?)a.TimeDifference);

            double dblMinsUnavalilable = 0.0;
            if (minsUnavailable != null)
            {
                dblMinsUnavalilable = (double)minsUnavailable;
            }
            decimal hoursAvailable = (decimal)((EndDate.AddDays(1) - StartDate).TotalMinutes - dblMinsUnavalilable) / 60;

            // Calc Average Output
            decimal avgOutput = 0;
            if (hrsRun != 0) { avgOutput = kWh / hrsRun; }

            // Populate the HTML with Values
            if (Generator != null && contract != null)
            {
                //Read in the contents of the HTML template file...
                string contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/SummaryAvailability.htm"));

                //Contract information & Generator performance
                //Replace the placeholders with the user-specified text
                //Page Header
                contents = contents.Replace("[SITENAME]", Generator.SITENAME.ToString());
                contents = contents.Replace("[ENGINENAME]", Generator.GENSETNAME.ToString());
                contents = contents.Replace("[OPERATINGPERIOD]", StartDate.ToString("dd-MM-yyyy") + " to " + EndDate.ToString("dd-MM-yyyy"));

                //Contract Information
                contents = contents.Replace("[CONTRACTTYPE]", db.GetContractType(IdLocation));
                contents = contents.Replace("[CONTRACTOUTPUT]", contract.ContractOutput.ToString());
                contents = contents.Replace("[CONTRACTAVAILABILITY]", string.Format("{0:0.000}", contract.ContractAvailability));
                contents = contents.Replace("[CONTRACTDUTYCYCLE]", contract.DutyCycle.ToString());
                contents = contents.Replace("[CONTRACTSTARTDATE]", string.Format("{0:dd-MM-yyyy}", contract.ContractStartDate));
                contents = contents.Replace("[CONTRACTLENGTH]", contract.ContractLength.ToString());

                //Generator Performance Summary
                contents = contents.Replace("[PERFDAYS]", (EndDate.AddDays(1) - StartDate).TotalDays.ToString() + " (" + (EndDate.AddDays(1) - StartDate).TotalHours.ToString() + "h)");
                contents = contents.Replace("[PERFHOURS]", hrsRun.ToString());
                contents = contents.Replace("[PERFHOURSAVAIL]", string.Format("{0:0.00}", hoursAvailable));
                contents = contents.Replace("[PERFKWH]", kWh.ToString());
                contents = contents.Replace("[PERFAVGOUTPUT]", string.Format("{0:0.00}", avgOutput));

                // Contract Performance Summary
                // Get the Exempts Totals, remove the excluded items from the calculation
                var availability = (from a in RsDc.GeneratorAvailabilities
                                    where a.IdLocation == IdLocation && a.DtUnavailable >= StartDate && a.DtAvailable < EndDate.AddHours(23).AddMinutes(59).AddSeconds(59)
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

                string totalExemptDowntime = (tsTotalExempts.Days * 24 + tsTotalExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0"));
                string totalNonExemptDowntime = (tsTotalNonExempts.Days * 24 + tsTotalNonExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalNonExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0"));

                int grossdays = Convert.ToInt32((EndDate.AddDays(1) - StartDate).TotalDays);
                int grosskW = grossdays * contract.ContractOutput * contract.DutyCycle;
                decimal targetkW = grosskW * (decimal)contract.ContractAvailability;
                decimal exemptkW = (decimal)contract.ContractOutput * (decimal)tsTotalExempts.TotalHours;
                decimal totalkW = (decimal)exemptkW + kWh;
                decimal availabilitykW = totalkW / grosskW;

                contents = contents.Replace("[GROSSKW]", grosskW.ToString());
                contents = contents.Replace("[TARGETKW]", string.Format("{0:0.00}", targetkW));
                contents = contents.Replace("[EXEMPTKW]", string.Format("{0:0.00}", exemptkW));
                contents = contents.Replace("[TOTALKW]", string.Format("{0:0.00}", totalkW));
                contents = contents.Replace("[AVAILKW]", string.Format("{0:0.00}", (availabilitykW * 100)) + "%");

                decimal grosshrs = Convert.ToInt32((EndDate.AddDays(1) - StartDate).TotalHours);
                decimal targethrs = grosshrs * (decimal)contract.ContractAvailability;
                decimal exempthrs = (decimal)tsTotalExempts.TotalHours;
                decimal totalHoursAvailable = exempthrs + hoursAvailable;
                decimal availabilityhrs = totalHoursAvailable / grosshrs;

                contents = contents.Replace("[GROSSHRS]", grosshrs.ToString());
                contents = contents.Replace("[TARGETHRS]", string.Format("{0:0.00}", targethrs));
                contents = contents.Replace("[EXEMPTHRS]", string.Format("{0:0.00}", exempthrs));
                contents = contents.Replace("[TOTALHRS]", string.Format("{0:0.00}", totalHoursAvailable));
                contents = contents.Replace("[AVAILHRS]", string.Format("{0:0.00}", (availabilityhrs * 100)) + "%");

                // Parse the HTML string into a collection of elements...
                return iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
            }
            else
            {
                return iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(""), null);
            }

        }

        protected Phrase FormatPageHeaderPhrase(string value)
        {
            return new Phrase(value, FontFactory.GetFont(FontFactory.TIMES, 10, Convert.ToInt32(iTextSharp.text.Font.BOLD), new BaseColor(255, 0, 0)));
        }

        protected Phrase FormatHeaderPhrase(string value)
        {
            return new Phrase(value, FontFactory.GetFont(FontFactory.TIMES, 8, Convert.ToInt32(iTextSharp.text.Font.BOLD), new BaseColor(0, 0, 255)));
        }

        protected Phrase FormatPhrase(string value)
        {
            return new Phrase(value, FontFactory.GetFont(FontFactory.TIMES, 8));
        }

        protected Tuple<PdfPTable, int, int> GetGeneratorDowntimeTable(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            Tuple <DataTable, int, int> result = db.getDowntime_SplitTimesPDF(IdLocation, StartDate, EndDate);

            DataTable dt = result.Item1;

            if (dt.Rows.Count > 0)
            {
                PdfPTable pdfTable = new PdfPTable(dt.Columns.Count);
                pdfTable.DefaultCell.Padding = 3;
                pdfTable.WidthPercentage = 100;
                pdfTable.DefaultCell.BorderWidth = 2;
                pdfTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

                // Loop Columns
                foreach (DataColumn col in dt.Columns)
                {
                    pdfTable.AddCell(FormatHeaderPhrase(col.ColumnName));
                }

                pdfTable.HeaderRows = 1; // this is the end of the table header
                pdfTable.DefaultCell.BorderWidth = 1;

                // Loop Rows
                foreach (DataRow row in dt.Rows)
                {
                    // Loop Cells
                    foreach (Object cell in row.ItemArray)
                    {
                        pdfTable.AddCell(FormatPhrase(cell.ToString()));
                    }
                }

                return Tuple.Create(pdfTable, result.Item2, result.Item3);
            }
            else
            {
                PdfPTable pdfTable = new PdfPTable(1);
                pdfTable.DefaultCell.Padding = 3;
                pdfTable.WidthPercentage = 100;
                pdfTable.DefaultCell.BorderWidth = 1;
                pdfTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

                pdfTable.AddCell("No Incidents/Activities in the selected period.");
                return Tuple.Create(pdfTable, 0, 0);
            }
        }

        protected Tuple<PdfPTable, int, int> GetGeneratorUnavailableTable(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            Tuple<DataTable, int, int> result = db.getAvailabilityWithSummary(IdLocation, StartDate, EndDate);

            if (result.Item1.Rows.Count > 0)
            {
                PdfPTable pdfTable = new PdfPTable(result.Item1.Columns.Count);
                pdfTable.DefaultCell.Padding = 3;
                pdfTable.WidthPercentage = 100;
                pdfTable.DefaultCell.BorderWidth = 2;
                pdfTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

                // Loop Columns
                foreach (DataColumn col in result.Item1.Columns)
                {
                    pdfTable.AddCell(FormatHeaderPhrase(col.ColumnName));
                }

                pdfTable.HeaderRows = 1; // this is the end of the table header
                pdfTable.DefaultCell.BorderWidth = 1;

                // Loop Rows
                foreach (DataRow row in result.Item1.Rows)
                {
                    // Loop Cells
                    foreach (Object cell in row.ItemArray)
                    {
                        pdfTable.AddCell(FormatPhrase(cell.ToString()));
                    }
                }
                return Tuple.Create(pdfTable, result.Item2, result.Item3);
            }
            else
            {
                PdfPTable pdfTable = new PdfPTable(1);
                pdfTable.DefaultCell.Padding = 3;
                pdfTable.WidthPercentage = 100;
                pdfTable.DefaultCell.BorderWidth = 1;
                pdfTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

                pdfTable.AddCell("No Incidents/Activities in the selected period.");
                return Tuple.Create(pdfTable, 0, 0);
            }
        }

        protected PdfPTable GetGeneratorStartUpTimeTable(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            DataTable dt = db.LINQToDataTable(RsDc.ed_LoadTimes_GetByIdPdf(IdLocation, StartDate.Date, EndDate.AddHours(23).AddMinutes(23).AddSeconds(59)));

            //doc.Add(FormatPageHeaderPhrase(dt.TableName));
            if (dt.Columns.Count > 0)
            {
                // New datetime string columns
                dt.Columns.Add("Start Up", typeof(string));
                dt.Columns.Add("Full Load", typeof(string));

                // Format them
                foreach (DataRow dr in dt.Rows)
                {
                    // Format the datetime coulmns
                    string startup = "";
                    startup = ((DateTime)dr["Start"]).ToString("dd/MM/yyyy HH:mm:ss");
                    dr["Start Up"] = startup;

                    string full = "";
                    full = ((DateTime)dr["Full_Load"]).ToString("dd/MM/yyyy HH:mm:ss");
                    dr["Full Load"] = full;
                }

                //Remove the origninal
                dt.Columns.Remove("Start");
                dt.Columns.Remove("Full_Load");

                // LINQtoDataTable corrupts symbols and whitespace -- fix here
                dt.Columns["Duration_min_"].ColumnName = "Duration (mins)";
                dt.Columns["Is_Exempt_"].ColumnName = "Is Exempt?";

                // Set column order
                dt.SetColumnsOrder("Start Up", "Full Load", "Duration (mins)", "Is Exempt?", "Notes"); 

                PdfPTable pdfTable = new PdfPTable(dt.Columns.Count);
                pdfTable.DefaultCell.Padding = 3;
                pdfTable.WidthPercentage = 100;
                pdfTable.DefaultCell.BorderWidth = 2;
                pdfTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

                // Loop Columns
                foreach (DataColumn col in dt.Columns)
                {
                    pdfTable.AddCell(FormatHeaderPhrase(col.ColumnName));
                }

                pdfTable.HeaderRows = 1; // this is the end of the table header
                pdfTable.DefaultCell.BorderWidth = 1;

                // Loop Rows
                foreach (DataRow row in dt.Rows)
                {
                    // Loop Cells
                    foreach (Object cell in row.ItemArray)
                    {
                        pdfTable.AddCell(FormatPhrase(cell.ToString()));
                    }
                }
                return pdfTable;
            }
            else
            {
                PdfPTable pdfTable = new PdfPTable(1);
                pdfTable.DefaultCell.Padding = 3;
                pdfTable.WidthPercentage = 100;
                pdfTable.DefaultCell.BorderWidth = 1;
                pdfTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

                pdfTable.AddCell("No Incidents/Activities in the selected period.");
                return pdfTable;
            }
        }

        protected List<IElement> GetGeneratorEventSummary(int totalExempts, int totalNonExempts)
        {
            // Read in the contents of the HTML template file...
            string contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_End.htm"));

            TimeSpan tsTotalExempts = new TimeSpan(0, totalExempts, 0);
            TimeSpan tsTotalNonExempts = new TimeSpan(0, totalNonExempts, 0);

            string totalExemptDowntime = (tsTotalExempts.Days * 24 + tsTotalExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0"));
            string totalNonExemptDowntime = (tsTotalNonExempts.Days * 24 + tsTotalNonExempts.Hours).ToString().PadLeft(4, Convert.ToChar("0")) + ":" + tsTotalNonExempts.Minutes.ToString().PadLeft(2, Convert.ToChar("0"));

            // Replace the placeholders with the user-specified text
            contents = contents.Replace("[TOTALEXEMPT]", totalExemptDowntime);
            contents = contents.Replace("[TOTALNONEXEMPT]", totalNonExemptDowntime);

            // Parse the HTML string into a collection of elements...
            return iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);

        }

        protected List<Series> GetPowerOverTimeData(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            List<Series> temp = new List<Series>(); // All Data stored here
            ChartBuilder Cb = new ChartBuilder();


            // Add the power over time data
            temp.Add(Cb.GetChartDatafromColumnTurbo(IdLocation, 5, StartDate, EndDate)); // 5 = Power

            return temp;
        }

        protected List<Series> GetTrendChartData(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            List<Series> temp = new List<Series>(); // All Data stored here
            ChartBuilder Cb = new ChartBuilder();

            // Get the report settings
            var ReportConfig = (from cfg in RsDc.ConfigReports where cfg.IdLocation == IdLocation select cfg).SingleOrDefault();

            if (ReportConfig.TrendChartArray != null || ReportConfig.TrendChartArray != "")
            {
                // Array of selected charts
                string[] assignedCharts = ReportConfig.TrendChartArray.Split(',');

                // For each checkbox item
                foreach (string chartId in assignedCharts)
                {
                    temp.Add(Cb.GetChartDatafromColumnTurbo(IdLocation, Convert.ToInt32(chartId), StartDate, EndDate));
                }
            }

            return temp; // Returns the series data
        }

        public byte[] CreateGeneratorReportPDF_Monthly(int IdLocation, DateTime StartDate, DateTime EndDate, bool AvailabilityFlag = false)
        {
            ChartBuilder Cb = new ChartBuilder();
            itsEvents ev = new itsEvents();

            using (MemoryStream MS = new MemoryStream()) // Create our file with an exclusive writer lock
            {
                using (Document Doc = new Document(PageSize.A4)) // Create our PDF document
                {
                    using (PdfWriter PdfWriter = PdfWriter.GetInstance(Doc, MS)) // Bind our PDF object to the physical file using a PdfWriter
                    {
                        // Watch for page events (Adds the page no.)
                        PdfWriter.PageEvent = ev;

                        // Open our document for writing
                        Doc.Open();

                        ////////////////////////////////////////////////////////
                        //////// Contract Summary & Performance Summary
                        ////////////////////////////////////////////////////////

                        Doc.NewPage();

                        // Get the Contract Summary Page and add to the document
                        if (AvailabilityFlag)
                        {
                            foreach (IElement el in GetGeneratorSummaryAvailabilityFlag(IdLocation, StartDate, EndDate))
                            {
                                Doc.Add(el);
                            }
                        }
                        else
                        {
                            foreach (IElement el in GetGeneratorSummary(IdLocation, StartDate, EndDate))
                            {
                                Doc.Add(el);
                            }
                        }

                        // Adding a header logo
                        var logo = iTextSharp.text.Image.GetInstance(HttpContext.Current.Server.MapPath("~/PDF/img/right-header-logo.png"));
                        logo.ScalePercent(10.0F);
                        logo.SetAbsolutePosition(400, 760);
                        Doc.Add(logo);

                        ////////////////////////////////////////////////////////
                        //////// Power Output Over Time Chart & 
                        ////////                     Total Runhrs per day
                        ////////////////////////////////////////////////////////

                        Doc.NewPage();

                        // Read in the contents of the HTML template file...
                        string contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_Page2.htm"));

                        // Parse the HTML string into a collection of elements...
                        List<IElement> HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                        foreach (IElement el in HTMLArrayList){
                            Doc.Add(el);
                        }

                        // Add the power over time trend graph
                        byte[] imageBytes = Cb.GetHighchartsImageExport(Cb.PopuateOverTimeChartPDFJS(GetPowerOverTimeData(IdLocation, StartDate, EndDate), false, "kWh")); // We want the JS
                        try
                        {
                            Image png = Image.GetInstance(imageBytes);
                            png.ScalePercent(42.0F);
                            Doc.Add(png);
                        }
                        catch (Exception ex)
                        {
                            //
                        }
                        
                        // Read in the contents of the HTML template file...
                        contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_Page2B.htm"));

                        // Parse the HTML string into a collection of elements...
                        HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                        foreach (IElement el in HTMLArrayList){
                            Doc.Add(el);
                        }

                        imageBytes = Cb.GetHighchartsImageExport(Cb.GetColumnDifferenceByDayChartPDFJS(IdLocation, 6, StartDate, EndDate, true, "chart1", 24)); // 6 = Runhours per day
                        try
                        {
                            Image png = Image.GetInstance(imageBytes);
                            png.ScalePercent(42.0F);
                            Doc.Add(png);
                        }
                        catch (Exception ex)
                        {
                            //
                        }

                        ////////////////////////////////////////////////////////
                        //////// kWh Per Day Chart & If required add
                        ////////                          Custom trend graph
                        ////////////////////////////////////////////////////////

                        Doc.NewPage();

                        // Read in the contents of the HTML template file...
                        contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_Page3A.htm"));

                        // Parse the HTML string into a collection of elements...
                        HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                        foreach (IElement el in HTMLArrayList){
                            Doc.Add(el);
                        }

                        imageBytes = Cb.GetHighchartsImageExport(Cb.GetColumnDifferenceByDayChartPDFJS(IdLocation, 7, StartDate, EndDate, true)); // 7 = kWh per day
                        try
                        {
                            Image png = Image.GetInstance(imageBytes);
                            png.ScalePercent(42.0F);
                            Doc.Add(png);
                        }
                        catch (Exception ex)
                        {
                            //
                        }

                        var ReportConfig = (from cfg in RsDc.ConfigReports
                                            where cfg.IdLocation == IdLocation
                                            select cfg).FirstOrDefault();

                        // Add custom trends if enabled
                        if (ReportConfig != null)
                        {
                            if (ReportConfig.TrendChartArray != null && ReportConfig.TrendChartArray != "")
                            {
                                // Read in the contents of the HTML template file...
                                contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_Page3B.htm"));

                                // Parse the HTML string into a collection of elements...
                                HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                                foreach (IElement el in HTMLArrayList)
                                {
                                    Doc.Add(el);
                                }

                                imageBytes = Cb.GetHighchartsImageExport(Cb.PopuateOverTimeChartPDFJS(GetTrendChartData(IdLocation, StartDate, EndDate), false, "Value")); // We want the JS
                                try
                                {
                                    Image png = Image.GetInstance(imageBytes);
                                    png.ScalePercent(42.0F);
                                    Doc.Add(png);
                                }
                                catch (Exception ex)
                                {
                                    //
                                }
                            }
                        }

                        ////////////////////////////////////////////////////////
                        //////// Add the performance charts and startup times
                        ////////         if they are required for this generator
                        ////////////////////////////////////////////////////////

                        if (ReportConfig != null)
                        {
                            // Get the Report Settings

                            if (ReportConfig.ShowEfficiency == true)
                            {
                                
                                // Thermal Energy Per Meter - Combined
                                // Read in the contents of the HTML template file...
                                Doc.NewPage();
                                contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/HeatChartsTop.htm"));
                                contents = contents.Replace("[CHART_TITLE]", "Heat Meters");

                                // Parse the HTML string into a collection of elements...
                                HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                                foreach (IElement el in HTMLArrayList)
                                {
                                    Doc.Add(el);
                                }

                                imageBytes = Cb.GetHighchartsImageExport(Cb.GetAllEnergyThermalMetersChartPDFJS(IdLocation, StartDate, EndDate));
                                try
                                {
                                    Image png = Image.GetInstance(imageBytes);
                                    png.ScalePercent(42.0F);
                                    Doc.Add(png);
                                }
                                catch (Exception ex)
                                {
                                    //
                                }

                                // Gas Consumption
                                // Read in the contents of the HTML template file...
                                contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/HeatChartsBottom.htm"));
                                contents = contents.Replace("[CHART_TITLE]", "Gas Consumption");

                                // Parse the HTML string into a collection of elements...
                                HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                                foreach (IElement el in HTMLArrayList)
                                {
                                    Doc.Add(el);
                                }

                                imageBytes = Cb.GetHighchartsImageExport(Cb.GetTotalGasUsageChartPDFJS(IdLocation, StartDate, EndDate));
                                try
                                {
                                    Image png = Image.GetInstance(imageBytes);
                                    png.ScalePercent(42.0F);
                                    Doc.Add(png);
                                }
                                catch (Exception ex)
                                {
                                    //
                                }

                                // Thermal Efficency
                                Doc.NewPage();
                                contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/HeatChartsTop.htm"));
                                contents = contents.Replace("[CHART_TITLE]", "Thermal Efficency");

                                // Parse the HTML string into a collection of elements...
                                HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                                foreach (IElement el in HTMLArrayList)
                                {
                                    Doc.Add(el);
                                }

                                imageBytes = Cb.GetHighchartsImageExport(Cb.GetThermalEfficencyPDFJS(IdLocation, StartDate, EndDate));
                                try
                                {
                                    Image png = Image.GetInstance(imageBytes);
                                    png.ScalePercent(42.0F);
                                    Doc.Add(png);
                                }
                                catch (Exception ex)
                                {
                                    //
                                }

                                // Electrical Efficency
                                // Read in the contents of the HTML template file...
                                contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/HeatChartsBottom.htm"));
                                contents = contents.Replace("[CHART_TITLE]", "Electrical Efficency");

                                // Parse the HTML string into a collection of elements...
                                HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                                foreach (IElement el in HTMLArrayList)
                                {
                                    Doc.Add(el);
                                }

                                imageBytes = Cb.GetHighchartsImageExport(Cb.GetElectricalEfficencyPDFJS(IdLocation, StartDate, EndDate));
                                try
                                {
                                    Image png = Image.GetInstance(imageBytes);
                                    png.ScalePercent(42.0F);
                                    Doc.Add(png);
                                }
                                catch (Exception ex)
                                {
                                    //
                                }
                            }

                            // Add in site startup times if required on a new page
                            if (ReportConfig.ShowUptime == true)
                            {
                                Doc.NewPage();

                                contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_Page5.htm"));

                                // Parse the HTML string into a collection of elements...
                                HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                                foreach (IElement el in HTMLArrayList)
                                {
                                    Doc.Add(el);
                                }

                                // Add the table to the PDF
                                Doc.Add(GetGeneratorStartUpTimeTable(IdLocation, StartDate, EndDate));
                            }

                        }

                        ////////////////////////////////////////////////////////
                        //////// Page number is dynamic and span is dynamic 
                        //////// depending upon the size of the downtime table etc
                        ////////////////////////////////////////////////////////

                        Doc.NewPage();

                        // Read in the contents of the HTML template file...
                        contents = File.ReadAllText(HttpContext.Current.Server.MapPath("~/PDF/Templates/Summary_Page4.htm"));

                        // Parse the HTML string into a collection of elements...
                        HTMLArrayList = iTextSharp.text.html.simpleparser.HTMLWorker.ParseToList(new StringReader(contents), null);
                        foreach (IElement el in HTMLArrayList)
                        {
                            Doc.Add(el);
                        }

                        // Add the downtime or unavailable table to the PDF
                        if (AvailabilityFlag)
                        {
                            Tuple<PdfPTable, int, int> result = GetGeneratorUnavailableTable(IdLocation, StartDate, EndDate);
                            Doc.Add(result.Item1);

                            foreach (IElement el in GetGeneratorEventSummary(result.Item2, result.Item3))
                            {
                                // Add the element to the document
                                Doc.Add(el);
                            }
                        }
                        else
                        {
                            Tuple<PdfPTable, int, int> result = GetGeneratorDowntimeTable(IdLocation, StartDate, EndDate);
                            Doc.Add(result.Item1);

                            // Add the Incident Summary footer
                            foreach (IElement el in GetGeneratorEventSummary(result.Item2, result.Item3))
                            {
                                // Add the element to the document
                                Doc.Add(el);
                            }
                        }

                        Doc.Close();
                    }
                }
                // Finalize the contents of the stream into an array
                return MS.ToArray();
            }
        }

    }

    // Class to insert page number each page end event
    public class itsEvents : PdfPageEventHelper
    {
        public override void OnEndPage(PdfWriter writer, Document document)
        {
            BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            PdfContentByte cb = writer.DirectContent;

            cb.BeginText();
            cb.SetFontAndSize(bf, 12);
            cb.SetTextMatrix(550, 30);
            cb.ShowText(document.PageNumber.ToString());
            cb.EndText();
        }
        
    }
}