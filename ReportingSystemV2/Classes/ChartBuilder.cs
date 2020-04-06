using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DotNet.Highcharts;
using DotNet.Highcharts.Options;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Enums;
using System.Net;
using System.Text;
using System.IO;
using System.Drawing;
using ReportingSystemV2.Models;
using Microsoft.AspNet.Identity;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;


namespace ReportingSystemV2
{
    public class ChartBuilder
    {
        public class DateValueObj
        {
            public DateTime Date;
            public double? value;
        }

        public class EpochDateValueObj
        {
            public double? Date;
            public double? value;
        }

        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        UserSites us = new UserSites();

        #region Common

        /// <summary>
        /// Converts DotNet.Highcharts HTML to Javascript Function
        /// </summary>
        /// <param name="DotNetHighchartsHTML">HTML output from DotNet.Highcharts</param>
        /// <returns>Highcharts javascript function</returns>
        public string chartHtmltoScript(string DotNetHighchartsHTML)
        {
            return DotNetHighchartsHTML.Split(new[] { "</div>\r\n" }, StringSplitOptions.None)[1];
        }

        /// <summary>
        /// Extracts the DotNet.Highcharts Options from DotNet.Highcharts HTML
        /// </summary>
        /// <param name="DotNetHighchartsHTML">HTML output from DotNet.Highcharts</param>
        /// <returns>Highcharts Options javascript</returns>
        public string chartOptionsStringFromHTML(string DotNetHighchartsHTML)
        {
            string tmp = DotNetHighchartsHTML.Split(new[] { "Highcharts.Chart(" }, StringSplitOptions.None)[1];

            return tmp.Split(new[] { "}]\r\n" }, StringSplitOptions.None)[0] + "}]};";
        }

        /// <summary>
        /// Aquires DotNet.Highcharts image file from export.highcharts.com
        /// </summary>
        /// <param name="DotNetHighchartsHTML">HTML output from DotNet.Highcharts</param>
        /// <returns>.png image bytes[]</returns>
        public byte[] GetHighchartsImageExportOld(string DotNetHighchartsHTML)
        {
            // Create a request using a URL that can receive a post. 
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://export.highcharts.com/");
            // Set the Method property of the request to POST.
            request.Method = "POST";

            // Create POST data and convert it to a byte array. 
            // Greater than 1500 with give internal server error 500 for some exports
            string chartOptions = chartOptionsStringFromHTML(DotNetHighchartsHTML);

            string postData = string.Format("filename={0}&type={1}&width={2}&svg={3}", "chart", "image/png", 1200, HttpContext.Current.Server.UrlEncode(chartOptions));

            byte[] byteArray = Encoding.UTF8.GetBytes(postData);

            // Set the ContentType property of the WebRequest.
            request.ContentType = "application/x-www-form-urlencoded; multipart/form-data";

            //User agent is based in a normal export.js request
            request.UserAgent = @"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:19.0) Gecko/20100101 Firefox/19.0";

            // Set the ContentLength property of the WebRequest.
            request.ContentLength = byteArray.Length;
            // Get the request stream.
            Stream dataStream = request.GetRequestStream();
            // Write the data to the request stream.
            dataStream.Write(byteArray, 0, byteArray.Length);
            // Close the Stream object.
            dataStream.Close();
            // Get the response.
            WebResponse response = request.GetResponse();

            HttpWebResponse webResponse = (HttpWebResponse)request.GetResponse();
            //This is here just to read the response.
            using (BinaryReader br = new BinaryReader(webResponse.GetResponseStream()))
            {
                byteArray = br.ReadBytes(500000);
                br.Close();
            }
            return byteArray;
        }

        /// <summary>
        /// Aquires DotNet.Highcharts image file from export.highcharts.com
        /// </summary>
        /// <param name="DotNetHighchartsHTML">HTML output from DotNet.Highcharts</param>
        /// <returns>.png image bytes[]</returns>
        public byte[] GetHighchartsImageExport(string DotNetHighchartsHTML)
        {
            try
            {
                // Create a request using a URL that can receive a post. 
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://export.highcharts.com/");

                // Set the Method property of the request to POST.
                request.Method = "POST";

                // Set the ContentType property of the WebRequest.
                request.ContentType = "application/json";

                request.UserAgent = @"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0";

                request.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";

                // Create POST data and convert it to a byte array. 
                // Greater than 1500 with give internal server error 500 for some exports
                string chartOptions = chartOptionsStringFromHTML(DotNetHighchartsHTML);

                // Build JSON Parameters
                string json = new JavaScriptSerializer().Serialize(new
                                                {
                                                    async = true,
                                                    asyncRendering = false,
                                                    callback = "",
                                                    constr = "Chart",
                                                    infile = chartOptions,
                                                    scale = false,
                                                    styledMode = false,
                                                    type = "image/png",
                                                    width = 1200
                                                });

                byte[] byteArray = Encoding.UTF8.GetBytes(json);

                // Set the ContentLength property of the WebRequest.
                request.ContentLength = byteArray.Length;
                // Get the request stream.
                Stream dataStream = request.GetRequestStream();
                // Write the data to the request stream.
                dataStream.Write(byteArray, 0, byteArray.Length);
                // Close the Stream object.
                dataStream.Close();
                // Get the response.
                WebResponse response = request.GetResponse();

                HttpWebResponse webResponse = (HttpWebResponse)request.GetResponse();

                // Read the response, it should contain the destination of our image file for download
                String responseString = "";
                using (Stream stream = webResponse.GetResponseStream())
                {
                    StreamReader reader = new StreamReader(stream, Encoding.UTF8);
                    responseString = reader.ReadToEnd();
                }

                // Create a new request using a URL that can receive a post. 
                HttpWebRequest requestPng = (HttpWebRequest)WebRequest.Create("http://export.highcharts.com/" + responseString);

                // Set the Method property of the request to POST.
                requestPng.Method = "GET";

                // Request and recieve response
                WebResponse responsePng = requestPng.GetResponse();

                HttpWebResponse webResponsePng = (HttpWebResponse)requestPng.GetResponse();

                //This is here just to read the response.
                using (BinaryReader br = new BinaryReader(webResponsePng.GetResponseStream()))
                {
                    byteArray = br.ReadBytes(500000);
                    br.Close();
                }
                return byteArray;
            }
            catch(Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                return null;
            }
        }

        public double GetEpochTime(DateTime dt)
        {
            DateTime baseTime = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            return (dt - baseTime).TotalMilliseconds;
        }

        public DateTime GetTimeFromEpoch(double EpochTime)
        {
            var epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            return epoch.AddSeconds(EpochTime);
        }

        // Convert a 2D data array to a EpochDateValueObj List
        public List<EpochDateValueObj> DateValueArrayToList(object[,] source)
        {
            List<EpochDateValueObj> result = new List<EpochDateValueObj>();

            for (int i = 0; i < source.GetLength(0) - 1; i++)
            {
                EpochDateValueObj tmp = new EpochDateValueObj();

                tmp.Date = Convert.ToDouble(source[i, 0]);
                tmp.value = Convert.ToDouble(source[i, 1]);

                result.Add(tmp);
            }

            return result;
        }

        // Convert a EpochDateValueObj List to a 2D data array
        public object[,] DateValueListToArray(List<EpochDateValueObj> source)
        {
            // Return 2d array
            int length = source.Count;
            object[,] data = new object[length, 2];
            int k = 0;

            foreach (var item in source)
            {
                data[k, 0] = item.Date;
                data[k, 1] = item.value;
                k++;
            }

            return data;
        }

        // Insert empty data values to a 2D array where there is a gap of defined interval
        public object[,] InsertEmptyPointsMinutes(int interval, object[,] source, int? val = null)
        {
            // Convert array to list so that we can insert data
            List<EpochDateValueObj> SourceList = DateValueArrayToList(source);
            
            // Iterate items in the List
            for (int i = 0; i < SourceList.Count - 2; i++)
            {
                // Get the time difference between next and current array vals
                int diffInMinutes = Convert.ToInt32(((SourceList[i + 1].Date - SourceList[i].Date) / 1000) / 60);

                // Greater than interval, insert points
                if (diffInMinutes > interval)
                {
                    // Number of points to add
                    int PointsToAdd = Convert.ToInt32(diffInMinutes / interval) - 1;

                    // Add them
                    for (int j = 1; j < PointsToAdd; j++)
                    {
                        EpochDateValueObj tmp = new EpochDateValueObj();
                        tmp.Date = SourceList[i].Date + TimeSpan.FromMinutes(interval * j).TotalMilliseconds;
                        tmp.value = val; // value to insert

                        SourceList.Insert(i + j, tmp);  // Insert in sequence
                    }
                }
            }

            // Convert List back to 2D array
            return DateValueListToArray(SourceList);
        }

        public Int32 FormatData(string data)
        {
            int index = data.IndexOf("--");
            if (index >= 0)
            {
                return Int32.Parse(data.Substring(1));
            }
            else
            {
                return Int32.Parse(data);
            }
        }

        /// <summary>
        /// Creates a data object from a history column for use with DotNet.Highcharts
        /// </summary>
        /// <param name="IdLocation">Site Location ID</param>
        /// <param name="columnName">History Column Name</param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public object[] GetChartDatafromColumn(int IdLocation, string columnName, DateTime startDate, DateTime endDate) //// For the PDF.....
        {
            List<Series> SeriesData = new List<Series>();
            List<DotNet.Highcharts.Options.Point> PointsData = new List<DotNet.Highcharts.Options.Point>();

            // If the startdate and enddate are the same add 24 hours
            if (startDate.Date == endDate.Date)
            {
                endDate = endDate.AddDays(1);
            }

            // get data from db and convert it to chart data (name, value, date)
            var chartSeries = RsDc.GeneratorContents.Where(x => x.TimeStamp >= startDate.Date && x.TimeStamp <= endDate.Date)
                              .Where(x => x.IdLocation == IdLocation)
                              .GroupBy(x => x.TimeStamp)
                              .Select(g => new
                              {
                                  Data = g.Select(x => x.GetType().GetProperty(columnName).GetValue(x).ToString()).ToArray(),
                                  Date = g.Select(x => x.TimeStamp).ToArray()
                              }).ToArray();

            // Set all Array values as points
            foreach (var item in chartSeries)
            {
                int length = item.Data.Count();
                //object[,] data = new object[length, 2];
                for (int i = 0; i < length; i++)
                {
                    PointsData.Add(new DotNet.Highcharts.Options.Point
                    {
                        X = GetEpochTime(item.Date[i]),
                        Y = FormatData(item.Data[i])
                    });
                }
            }
            return PointsData.ToArray();
        } ///

        // Checks for a valid HTML Color - Returns a random color if empty
        public Color CheckColorIsValid(string HtmlColorCode)
        {
            if (HtmlColorCode == "" || HtmlColorCode == null)
            {
                // No color defined, pick at random
                var random = new Random();
                var color = String.Format("#{0:X6}", random.Next(0x1000000)); // Mask result for darker colors, & 0x7F7F7F

                return System.Drawing.ColorTranslator.FromHtml(color);
            }
            else
            {
                try
                {
                    // Color defined, convert and return if ok
                    return System.Drawing.ColorTranslator.FromHtml(HtmlColorCode);
                }
                catch (Exception ex)
                {
                    LogMe.LogSystemException(ex.ToString());

                    // If convert fails, send a random color
                    var random = new Random();
                    var color = String.Format("#{0:X6}", random.Next(0x1000000)); // Mask result for darker colors, & 0x7F7F7F
                    return System.Drawing.ColorTranslator.FromHtml(color);
                }
            }
        }

        #endregion

        #region Dashboard

        // Home Screen

        public object[] GetEnginesByContractedOutput()
        {
            var obj = new List<object>();

            // Get the users sites
            var UsersSites = (from c in RsDc.GetTable<HL_Location>()
                         select c).Where(t => us.GetUserSites_Int(System.Web.HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID));

            // Join the users sites with contracts
            var Contracts = (from g in UsersSites
                         join c in RsDc.ContractInformations on g.ID_ContractInformation equals c.ID
                         where g.ID != null
                         select c);

            // Group and order the contracted outputs for a count
            var items = (from h in Contracts
                         group h by h.ContractOutput into g
                         select new { Output = (int)g.Select(n => n.ContractOutput).First(), Count = (int)g.Count() }
                             into s
                             orderby s.Output
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.Output.ToString() + "kW", item.Count });
            }

            // Add the undefined.
            var undefined = (from s in UsersSites
                             where s.ID_ContractInformation == null
                             select s).Count();

            if (undefined > 0)
            {
                obj.Add(new object[] { "Undefined", undefined });
            }

            return obj.ToArray();
        }

        public object[] GetEnginesByContractType()
        {
            var obj = new List<object>();

            // Get the users sites
            var UsersSites = (from c in RsDc.GetTable<HL_Location>()
                              select c).Where(t => us.GetUserSites_Int(System.Web.HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID));

            // Join the users sites with contracts
            var Contracts = (from g in UsersSites
                             join c in RsDc.ContractInformations on g.ID_ContractInformation equals c.ID
                             where g.ID != null
                             select c);

            // Group and order the contract types for a count
            var items = (from h in Contracts
                         join t in RsDc.ContractTypes on h.ID_ContractType equals t.ID
                         group t by h.ID_ContractType into g
                         select new { ContractType = g.Select(n => n.Contract_Type).First(), Count = (int)g.Count() }
                             into s
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.ContractType.ToString(), item.Count });
            }

            // Add the undefined.
            var undefined = (from s in UsersSites
                             where s.ID_ContractInformation == null
                             select s).Count();

            if (undefined > 0)
            {
                obj.Add(new object[] { "Undefined", undefined });
            }

            return obj.ToArray();
        }

        public object[] GetEnginesByTypeDescription()
        {
            var obj = new List<object>();

            // Get the users sites
            var UsersSites = (from c in RsDc.GetTable<HL_Location>()
                              select c).Where(t => us.GetUserSites_Int(System.Web.HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID));

            // Join the users sites with contracts
            var Engines = (from g in UsersSites
                             join c in RsDc.EngineTypes on g.ID_EngineType equals c.ID
                             where g.ID != null
                             select c);

            // Group and order the engine types for a count
            var items = (from h in Engines
                         group h by h.Description into g
                         select new { Description = g.Select(n => n.Description).First(), Count = (int)g.Count() }
                             into s
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.Description.ToString(), item.Count });
            }

            // Add the undefined.
            var undefined = (from s in UsersSites
                             where s.ID_EngineType == null
                             select s).Count();

            if (undefined > 0)
            {
                obj.Add(new object[] { "Undefined", undefined });
            }

            return obj.ToArray();
        }

        public object[] GetEnginesByTypeMake()
        {
            var obj = new List<object>();

            // Get the users sites
            var UsersSites = (from c in RsDc.GetTable<HL_Location>()
                              select c).Where(t => us.GetUserSites_Int(System.Web.HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID));

            // Join the users sites with contracts
            var Engines = (from g in UsersSites
                           join c in RsDc.EngineTypes on g.ID_EngineType equals c.ID
                           where g.ID != null
                           select c);

            // Group and order the engine types for a count
            var items = (from h in Engines
                         group h by h.Make into g
                         select new { Make = g.Select(n => n.Make).First(), Count = (int)g.Count() }
                             into s
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.Make.ToString(), item.Count });
            }

            // Add the undefined.
            var undefined = (from s in UsersSites
                             where s.ID_EngineType == null
                             select s).Count();

            if (undefined > 0)
            {
                obj.Add(new object[] { "Undefined", undefined });
            }

            return obj.ToArray();
        }

        public object[] GetEnginesByGasType()
        {
            var obj = new List<object>();

            // Get the users sites
            var UsersSites = (from c in RsDc.GetTable<HL_Location>()
                              select c.ID).Where(t => us.GetUserSites_Int(System.Web.HttpContext.Current.User.Identity.GetUserId()).Contains(t));

            // Get the users sites
            var UsersGasSites = (from c in RsDc.GasTypes_Mappings
                              select c).Where(t => us.GetUserSites_Int(System.Web.HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID_Location));

            // Join the users sites with contracts
            var Gases = (from g in UsersGasSites
                           join c in RsDc.GasTypes on g.ID_GasType equals c.ID
                           select c);

            // Group and order the engine types for a count
            var items = (from h in Gases
                         group h by h.Gas_Type into g
                         select new { Gas = g.Select(n => n.Gas_Type).First(), Count = (int)g.Count() }
                             into s
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.Gas.ToString(), item.Count });
            }

            // Add the undefined.
            var undefined = (from s in UsersSites select s).ToList().Except(from b in UsersGasSites select b.ID_Location);
           
            if (undefined.Count() > 0)
            {
                obj.Add(new object[] { "Undefined", undefined.Count() });
            }

            return obj.ToArray();
        }

        // Historical Charts

        public List<DateValueObj> GetDataColumnDifferenceByDay(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();
            var objResult = new List<DateValueObj>();

            // Get the columns comap name 
            var Col = (from s in RsDc.ComAp_Headers
                       where s.id == IdColumn
                       select s).SingleOrDefault();

            // We have a valid column in comap.
            // Lets get the pulsed gas usage
            var TotalPerDay = (from s in RsDc.ed_Genset_GetColumnDifferenceByDays_GeneratorContent(IdLocation, Col.History_Header, startDate, endDate)
                               select s).ToArray();

            foreach (var Day in TotalPerDay)
            {
                objResult.Add(new DateValueObj { Date = DateTime.ParseExact(Day.TimeStamp, "dd/MM/yyyy", null), value = Day.TotalEnergy });
            }
            return objResult;
        }

        public string GetColumnDifferenceByDayChartJS(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate, bool ScriptIt = false, string ChartId = "chart1")
        {
            // Get the columns settings
            var ColPro = (from s in RsDc.ColumnNames where s.HeaderId == IdColumn
                          select s).SingleOrDefault();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts(ChartId)
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column, ClassName = "fill" })
                .SetTitle(new Title { Text = "Difference By Day" })
                //.SetSubtitle(new Subtitle { Text =  })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = ColPro.ColumnUnits }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Data = new Data(GetDataColumnDifferenceByDay(IdLocation, IdColumn, startDate, endDate).Select(s => new object[] { s.Date, s.value }).ToArray()),
                    Name = ColPro.ColumnLabel,
                    Color = CheckColorIsValid(ColPro.ColumnHtmlColor)
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public List<DateValueObj> GetDataColumnDifferenceByHour(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();
            var objResult = new List<DateValueObj>();

            // Get the columns comap name 
            var Col = (from s in RsDc.ComAp_Headers
                       where s.id == IdColumn
                       select s).SingleOrDefault();

            // We have a valid column in comap.
            // Lets get the pulsed gas usage
            var TotalPerHour = (from s in RsDc.ed_Genset_GetColumnDifferenceByHoursofDays_GeneratorContent(IdLocation, Col.History_Header, startDate, endDate)
                                select s).ToArray();

            foreach (var Hour in TotalPerHour)
            {
                string dt = Hour.HR.ToString().PadLeft(2, '0') + ":00:00 " + Hour.DY.ToString().PadLeft(2, '0') + "/" + Hour.MTH.ToString().PadLeft(2, '0') + "/" + Hour.YR.ToString();
                objResult.Add(new DateValueObj { Date = DateTime.ParseExact(dt, "HH:mm:ss dd/MM/yyyy", null), value = Hour.TotalEnergy });
            }
            return objResult;
        }

        public string GetColumnDifferenceByHourChartJS(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            // Get the columns settings
            var ColPro = (from s in RsDc.ColumnNames where s.HeaderId == IdColumn
                          select s).SingleOrDefault();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column, ClassName = "fill" })
                .SetTitle(new Title { Text = "Difference By Hour" })
                //.SetSubtitle(new Subtitle { Text = "Difference By Hour" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = ColPro.ColumnUnits }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Data = new Data(GetDataColumnDifferenceByHour(IdLocation, IdColumn, startDate, endDate).Select(s => new object[] { s.Date, s.value }).ToArray()),
                    Name = ColPro.ColumnLabel,
                    Color = CheckColorIsValid(ColPro.ColumnHtmlColor)
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public List<DateValueObj> GetDataColumnDifferenceByMonth(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();
            var objResult = new List<DateValueObj>();

            // Get the columns comap name 
            var Col = (from s in RsDc.ComAp_Headers
                       where s.id == IdColumn
                       select s).SingleOrDefault();

            // We have a valid column in comap.
            // Lets get the pulsed gas usage
            var TotalPerMonth = (from s in RsDc.ed_Genset_GetColumnDifferenceByMonthsOfYear_GeneratorContent(IdLocation, Col.History_Header, startDate, endDate)
                                 select s).ToArray();

            foreach (var Month in TotalPerMonth)
            {
                string dt = Month.MTH.ToString().PadLeft(2, '0') + "/" + Month.YR.ToString();
                objResult.Add(new DateValueObj { Date = DateTime.ParseExact(dt, "MM/yyyy", null), value = Month.TotalEnergy });
            }

            return objResult;
        }

        public string GetColumnDifferenceByMonthChartJS(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            // Get the columns settings
            var ColPro = (from s in RsDc.ColumnNames where s.HeaderId == IdColumn
                          select s).SingleOrDefault();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column, ClassName = "fill" })
                .SetTitle(new Title { Text = "Difference By Month" })
                //.SetSubtitle(new Subtitle { Text = "Difference By Month" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = ColPro.ColumnUnits }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Data = new Data(GetDataColumnDifferenceByMonth(IdLocation, IdColumn, startDate, endDate).Select(s => new object[] { s.Date, s.value }).ToArray()),
                    Name = ColPro.ColumnLabel,
                    Color = CheckColorIsValid(ColPro.ColumnHtmlColor)
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public Series GetChartDatafromColumnTurbo(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate)
        {
            // Returns a 2d array
            List<Series> SeriesData = new List<Series>();

            RsDc.CommandTimeout = 60 * 3; // Change the timeout period          

            // Get the columns comap name 
            var Col = (from s in RsDc.ComAp_Headers where s.id == IdColumn
                       select s).SingleOrDefault();

            // Get the columns settings
            var ColPro = (from s in RsDc.ColumnNames where s.HeaderId == IdColumn
                          select s).SingleOrDefault();

            // If the startdate and enddate are the same add 24 hours
            if (startDate.Date == endDate.Date)
            {
                endDate = endDate.AddDays(1);
            }

            // get data from db and convert it to chart data (name, value, date)
            var chartSeries = (from s in RsDc.ed_Genset_GetColumnOverTimePlot_GeneratorContent(IdLocation, Col.History_Header, startDate, endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)) select s).ToArray();
                
            int length = chartSeries.Count();
            object[,] data = new object[length, 2];
            int i = 0;
            
            foreach (var item in chartSeries)
            {
                if (item.Data != null)
                {
                    data[i, 0] = (item.TimeStamp.Value - new DateTime(1970, 1, 1, 0, 0, 0)).TotalMilliseconds;
                    data[i, 1] = item.Data;
                }
                i++;
            }

            Series localSeries = new Series { Name = ColPro.ColumnLabel, Data = new Data(data), Color = CheckColorIsValid(ColPro.ColumnHtmlColor) };
            return localSeries;
        }

        public string PopuateOverTimeChartJS(List<Series> chartData, string ChartTitle = "Trend Chart", bool BottomLegend = false, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Spline, ClassName = "fill", ZoomType = ZoomTypes.X })
                .SetTitle(new Title { Text = ChartTitle })
                .SetSubtitle(new Subtitle { Text = "Click and drag in the plot area to zoom in" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "Value" }
                })
                .SetTooltip(new Tooltip
                {
                    Formatter = @"function() { return Highcharts.dateFormat('%e %b %Y %I:%M %p',
                                          new Date(this.x)) + '<br>' + this.series.name + ': <b>'+ this.y + '</b>'; }"
                })
                .SetPlotOptions(new PlotOptions
                {
                    Spline = new PlotOptionsSpline
                    {
                        LineWidth = 1                         
                    }
                })
                .SetSeries(chartData.Select(s => new Series { Name = s.Name, Data = s.Data, Color = s.Color }).ToArray()
                );

            // Apply custom legend as default
            if (!BottomLegend)
            {
                chart.SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true,
                });
            }

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        #endregion

        #region ReportingOverview
        public List<Series> GetExemptChartData(ChartTypes ChartType, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();

            // Get the Unverified reasons
            var items = (from h in RsDc.ed_Exempts_Get(startDate, endDate.Date)
                         where h.ISEXEMPT == null
                         group h by h.DTDOWN.Date into g
                         select new { Day = (DateTime)g.Select(n => n.DTDOWN.Date).First(), Count = (int)g.Count() }
                             into s
                             orderby s.Day
                             select s).ToArray();

            // Add Unverified to an object
            var unVerified = new List<object>();
            foreach (var item in items)
            {
                unVerified.Add(new object[] { item.Day, item.Count });
            }

            // Define Unverified Series
            Series localSeries = new Series { Name = "Unverified", Data = new Data(unVerified.ToArray()), Type = ChartType };
            Series.Add(localSeries);

            // Get the Exempts
            items = (from h in RsDc.ed_Exempts_Get(startDate, endDate)
                     where h.ISEXEMPT == true
                     group h by h.DTDOWN.Date into g
                     select new { Day = (DateTime)g.Select(n => n.DTDOWN.Date).First(), Count = (int)g.Count() }
                         into s
                         orderby s.Day
                         select s).ToArray();

            // Add Exempt to an object
            var exempt = new List<object>();
            foreach (var item in items)
            {
                exempt.Add(new object[] { item.Day, item.Count });
            }

            // Define Exempt Series
            localSeries = new Series { Name = "Exempt", Data = new Data(exempt.ToArray()), Type = ChartType };
            Series.Add(localSeries);

            // Get the Non-Exempts
            items = (from h in RsDc.ed_Exempts_Get(startDate, endDate)
                     where h.ISEXEMPT == false
                     group h by h.DTDOWN.Date into g
                     select new { Day = (DateTime)g.Select(n => n.DTDOWN.Date).First(), Count = (int)g.Count() }
                         into s
                         orderby s.Day
                         select s).ToArray();

            // Add Non-Exempts to an object
            var nonexempt = new List<object>();
            foreach (var item in items)
            {
                nonexempt.Add(new object[] { item.Day, item.Count });
            }

            // Define Non-Exempt Series
            localSeries = new Series { Name = "Non-Exempt", Data = new Data(nonexempt.ToArray()), Type = ChartType };
            Series.Add(localSeries);

            return Series;
        }

        public List<DateValueObj> GetkWhProducedPerDay(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var objResult = new List<DateValueObj>();

            //Get the Unverified reasons
            var items = (from h in RsDc.ed_Genset_GetColumnDifferenceByDays_GeneratorContent(IdLocation, "kWhour", startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59))
                         select new { Day = (String)h.TimeStamp, kWh = (int)h.TotalEnergy }
                             into s
                             orderby s.Day
                             select s).ToArray();

            foreach (var item in items)
            {
                objResult.Add(new DateValueObj { Date = DateTime.ParseExact(item.Day, "dd/MM/yyyy", null), value = item.kWh });
            }
            return objResult;
        }

        public object[] GetRunHoursPerDay(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var obj = new List<object>();

            //Get the Unverified reasons
            var items = (from h in RsDc.ed_Genset_GetColumnDifferenceByDays_GeneratorContent(IdLocation, "Runhrs", startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59))
                         select new { Day = (String)h.TimeStamp, RunHours = (int)h.TotalEnergy }
                             into s
                             orderby s.Day
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { DateTime.ParseExact(item.Day, "dd/MM/yyyy", null), item.RunHours });
            }
            return obj.ToArray();
        }

        public object[] GetUpdatesChartData()
        {
            // Get the counts of updated and non-updated sites
            var obj = new List<object>();
            int updated = 0;
            int failed = 0;

            //Get the number of updated and non updated sites
            var updateTimes = (from l in RsDc.HL_Locations
                               join t in RsDc.GeneratorContentUpdates
                               on l.ID equals t.IdLocation
                               into GeneratorTimeGroup
                               from time in GeneratorTimeGroup.DefaultIfEmpty()
                               where l.GensetEnabled == true
                               select new { l.ID, l.GENSETNAME, l.SITENAME, l.GENSET_SN, TimeStamp = ((DateTime?)time.TimeStamp != null ? time.TimeStamp : l.LASTUPDATE) }).Where(t => us.GetUserSites_Int(HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID));

            updated = updateTimes.Where(t => t.TimeStamp >= DateTime.Today.Date.AddHours(-24)).Count();

            failed = (from h in RsDc.HL_Locations.Where(t => us.GetUserSites_Int(HttpContext.Current.User.Identity.GetUserId()).Contains(t.ID)) // Filter Users Sites
                      where h.GensetEnabled == true
                       select h).Count() - updated;

            //Create the object
            obj.Add(new object[] { "Succeeded", updated });
            obj.Add(new object[] { "Failed", failed });

            return obj.ToArray();
        }

        public object[] GetShutdownReasons(int IdLocation, DateTime startDate, DateTime endDate)
        {
            // Group & Count the downtime reasons by location
            var obj = new List<object>();

            //Get the Unverified reasons
            var items = (from h in RsDc.ed_Exempts_GetWithReasonById(IdLocation, startDate, endDate.Date.AddHours(23).AddMinutes(23).AddSeconds(59))
                         group h by h.REASON into g
                         select new { Reason = (string)g.Select(n => n.REASON).First(), Count = (int)g.Count() }
                             into s
                             orderby s.Reason
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.Reason.Replace("'", "") , item.Count });
            }

            return obj.ToArray();
        }

        public object[] GetTopTenReasonsForAll()
        {
            var obj = new List<object>();

            //Get the Unverified reasons
            var items = (from h in RsDc.ed_Exempts_GetWithReason(DateTime.Today.AddDays(-1), DateTime.Today)
                         group h by h.REASON into g
                         select new { Reason = (string)g.Select(n => n.REASON).First(), Count = (int)g.Count() }
                             into s
                             orderby s.Reason
                             select s).ToArray();

            foreach (var item in items)
            {
                obj.Add(new object[] { item.Reason.Replace("'", ""), item.Count });
            }

            return obj.ToArray();
        }
        #endregion

        #region Meters
        
        // GetAllEnergyMeters
        // Gets the Total kWh generated by day for each E&H Heat Meter associated with a site to seperate series'.
        public List<Series> GetDataHeatEnergyGeneratedByDayByMeterkWh(ChartTypes ChartType, int IdLocation, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();

            // First get a list of the energy meters for the site
            var meterIds = (from s in RsDc.EnergyMeters_Mappings
                            where s.ID_Location == IdLocation
                            orderby s.ID_Type
                            select s).ToArray();

            var primarySiteID = (from s in RsDc.ed_Genset_GetPrimaryGensetIdByGensetId(IdLocation)
                                 select s).FirstOrDefault();

            // Loop all meters in the list and create a data series for each
            foreach (var meter in meterIds)
            {
                var tempObj = new List<object>();

                if (meter.Modbus_Addr != -1)
                {
                    // Get the total kWh value for the meter
                    var values = (from s in RsDc.ed_EnergyMeters_GetColumnDifferenceByDays(primarySiteID.ID, meter.Modbus_Addr, startDate, endDate)
                                  select s).ToArray();

                    foreach (var value in values)
                    {
                        tempObj.Add(new object[] { DateTime.ParseExact(value.TIME_STAMP, "dd/MM/yyyy", null), value.TotalEnergy });
                    }

                    var MeterTypeName = (from s in RsDc.EnergyMeters_Types
                                         where s.id == meter.ID_Type
                                         select s.Meter_Type).SingleOrDefault();

                    // Add the Series with Meter type name
                    Series localSeries = new Series { Name = MeterTypeName, Data = new Data(tempObj.ToArray()), Type = ChartType };
                    Series.Add(localSeries);
                }
            }
            return Series;
        }

        public string GetAllEnergyThermalMetersChartJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("AllHeatMetersChart")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "Heat Meters" })
                .SetSubtitle(new Subtitle { Text = "kWh of Heat produced by Meter" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "kWh (Thermal)" }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(GetDataHeatEnergyGeneratedByDayByMeterkWh(ChartTypes.Column, IdLocation, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59))
                    .Select(s => new Series { Name = s.Name, Data = s.Data }).ToArray()
                );

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        // GetHeatEnergyGeneratedByDayTotalkWh
        // Gets the Total kWh generated by day for each E&H Heat Meter associated with a site.
        public List<DateValueObj> GetDataHeatEnergyGeneratedByDayTotalkWh(int IdLocation, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            var objResult = new List<DateValueObj>();

            // Create a basic object for the date range
            for(DateTime date = startDate; date.Date < endDate.Date; date = date.AddDays(1))
            {
                objResult.Add(new DateValueObj { Date = date, value = 0.000 });
            }

            // First get a list of the energy meters for the site
            var meterIds = (from s in RsDc.EnergyMeters_Mappings
                            where s.ID_Location == IdLocation
                            orderby s.ID_Type
                            select s).ToArray();

            var primarySiteID = (from s in RsDc.ed_Genset_GetPrimaryGensetIdByGensetId(IdLocation)
                                 select s).FirstOrDefault();

            // Loop all meters in the list and create a data series for each
            foreach (var meter in meterIds)
            {
                var tempObj = new List<object>();

                if (meter.Modbus_Addr != -1)
                {
                    // Get the total kWh value for the meter
                    var values = (from s in RsDc.ed_EnergyMeters_GetColumnDifferenceByDays(primarySiteID.ID, meter.Modbus_Addr, startDate, endDate)
                                  select s).ToArray();

                    foreach (var value in values)
                    {
                        // Add to total by date
                        // Search for the date entry
                        var item = objResult.FirstOrDefault(o => o.Date == DateTime.ParseExact(value.TIME_STAMP, "dd/MM/yyyy", null));
                        if (item != null)
                        {
                            item.value += value.TotalEnergy;
                        }
                    }
                }
            }
            return objResult;
        }

        // GetGasConsumptionVolumeByDay
        // Gets the Total Gas Consumption by day for a specific site, from either a ComAp column or E&H Gas Meter (Includes the RSG40 Logger)
        public List<DateValueObj> GetDataGasConsumptionVolumeByDay(int IdLocation, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();
            var objResult = new List<DateValueObj>();

            // Where are we getting the totalised gas volume from?
            // Check for E&H first as it has better accuracy
            var meterAddr = (from s in RsDc.GasMeters_Mappings
                             where s.ID_Location == IdLocation
                           select s.Modbus_Addr).SingleOrDefault();

            if (meterAddr == null || meterAddr == 0 || meterAddr == -1)
            {
                // No E&H, check for ComAp column name
                var meterColumnName = (from s in RsDc.ConfigEfficiencies
                                       where s.IdLocation == IdLocation
                                       select s.GasVolumeColumnName).SingleOrDefault();

                if (meterColumnName != "")
                {
                    // We have a valid column in comap.
                    // Lets get the pulsed gas usage
                    var gasVolumeComAp = (from s in RsDc.ed_Genset_GetColumnDifferenceByDays_GeneratorContent(IdLocation, meterColumnName, startDate, endDate)
                                    select s).ToArray();
                    
                    foreach (var vol in gasVolumeComAp)
                    {
                        objResult.Add(new DateValueObj { Date = DateTime.ParseExact(vol.TimeStamp, "dd/MM/yyyy", null), value = vol.TotalEnergy });
                    }

                }
                                      
            }
            else
            {
                // Get the Gas data from the E&H Meters
                // Get the primary site id
                var primarySiteID = (from s in RsDc.ed_Genset_GetPrimaryGensetIdByGensetId(IdLocation)
                                     select s).FirstOrDefault();

                // Add both Vol & kWh to objects
                // Get the data from the GasMeters table
                var gasVolume = (from s in RsDc.ed_EnergyMeters_GetGasDifferenceByDays(primarySiteID.ID, meterAddr, startDate, endDate)
                              select s).ToArray();

                foreach (var vol in gasVolume)
                {
                    objResult.Add(new DateValueObj { Date = DateTime.ParseExact(vol.TIME_STAMP, "dd/MM/yyyy", null), value = vol.TotalVolume });
                }
            }
            return objResult;
        }

        // GetGasConsumptionkWhByDay
        // Gets the Total Gas Consumption by day for a specific site, from either a ComAp column or E&H Gas Meter (Includes the RSG40 Logger)
        public List<DateValueObj> GetDataGasConsumptionkWhByDay(int IdLocation, DateTime startDate, DateTime endDate)
        {
            // Count the downtime types into there specific categories
            List<Series> Series = new List<Series>();
            var objResult = new List<DateValueObj>();
            double correctionFactor = 1.0;

            //Get the Calorific Value for the Gas
            var calorificVal = (from s in RsDc.ConfigEfficiencies
                                where s.IdLocation == IdLocation
                               select s.GasCalorificValue).FirstOrDefault();

            //Find out if the correction factor is to be applied
            var IsGasCorrected = (from s in RsDc.ConfigEfficiencies
                                  where s.IdLocation == IdLocation
                                     select s.IsGasVolumeCorrected).FirstOrDefault();

            if (!IsGasCorrected.GetValueOrDefault(false) == true)
            {
                correctionFactor = 1.02264;
            }


            // Where are we getting the totalised gas volume from?
            // Check for E&H first as it has better accuracy
            var meterAddr = (from s in RsDc.GasMeters_Mappings
                             where s.ID_Location == IdLocation
                             select s.Modbus_Addr).SingleOrDefault();

            if (meterAddr == null || meterAddr == 0 || meterAddr == -1)
            {
                // No E&H, check for ComAp column name
                var meterColumnName = (from t1 in RsDc.HL_Locations
                                       join t2 in RsDc.ConfigEfficiencies on t1.ID equals t2.IdLocation
                                       where t1.ID == IdLocation
                                       select t2.GasVolumeColumnName).SingleOrDefault();

                if (meterColumnName != "")
                {
                    // We have a valid column in comap.
                    // Lets get the pulsed gas usage
                    var gasVolumeComAp = (from s in RsDc.ed_Genset_GetColumnDifferenceByDays_GeneratorContent(IdLocation, meterColumnName, startDate, endDate)
                                          select s).ToArray();

                    foreach (var vol in gasVolumeComAp)
                    {
                        objResult.Add(new DateValueObj { Date = DateTime.ParseExact(vol.TimeStamp, "dd/MM/yyyy", null), value = ((Convert.ToDouble(vol.TotalEnergy) * correctionFactor) * calorificVal.Value) / 3.6 });
                    }
                }

            }
            else
            {
                // Get the Gas data from the E&H Meters
                // Get the primary site id
                var primarySiteID = (from s in RsDc.ed_Genset_GetPrimaryGensetIdByGensetId(IdLocation)
                                     select s).FirstOrDefault();

                // Add both Vol & kWh to objects
                // Get the data from the GasMeters table
                var gasVolume = (from s in RsDc.ed_EnergyMeters_GetGasDifferenceByDays(primarySiteID.ID, meterAddr, startDate, endDate)
                                 select s).ToArray();

                foreach (var vol in gasVolume)
                {
                    objResult.Add(new DateValueObj { Date = DateTime.ParseExact(vol.TIME_STAMP, "dd/MM/yyyy", null), value = ((Convert.ToDouble(vol.TotalVolume) * correctionFactor) * calorificVal.Value) / 3.6 });
                }
            }
            return objResult;
        }

        public string GetTotalGasUsageChartJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("TotalGasConsumption")
                .InitChart(new Chart { ZoomType = ZoomTypes.Xy })
                .SetTitle(new Title { Text = "Gas Consumption" })
                .SetSubtitle(new Subtitle { Text = "Gas usage for this period" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
               .SetYAxis(new[]
                {
                    new YAxis
                    {
                        Labels = new YAxisLabels
                        {
                            Formatter = "function() { return this.value +' m3'; }",
                            Style = "color: '#89A54E'"
                        },
                        Title = new YAxisTitle
                        {
                            Text = "Comsumption (m3)",
                            Style = "color: '#89A54E'"
                        }
                    },
                    new YAxis
                    {
                        Labels = new YAxisLabels
                        {
                            Formatter = "function() { return this.value +' kWh'; }",
                            Style = "color: '#4572A7'"
                        },
                        Title = new YAxisTitle
                        {
                            Text = "Comsumption (kWh)",
                            Style = "color: '#4572A7'"
                        },
                        Opposite = true
                    }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new[]
                {
                    new Series
                    {
                        Name = "Gas Consumption (kWh)",
                        Color = ColorTranslator.FromHtml("#4572A7"),
                        Type = ChartTypes.Column,
                        YAxis = "1",
                        Data = new Data(GetDataGasConsumptionkWhByDay(IdLocation, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59)).Select(s => new object[] { s.Date, s.value }).ToArray())
                    },
                    new Series
                    {
                        Name = "Gas Consumption (m3)",
                         Color = ColorTranslator.FromHtml("#89A54E"),
                        Type = ChartTypes.Spline,
                        Data = new Data(GetDataGasConsumptionVolumeByDay(IdLocation, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59)).Select(s => new object[] { s.Date, s.value }).ToArray())
                    }
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        //Calculate the total efficency of 2 objects
        public List<DateValueObj> GetDataEfficency(int IdLocation, DateTime startDate, DateTime endDate, int type)
        {
            // Count the downtime types into there specific categories
            var objResult = new List<DateValueObj>();

            // Create a basic object for the date range
            for (DateTime date = startDate; date.Date < endDate.Date; date = date.AddDays(1))
            {
                objResult.Add(new DateValueObj { Date = date, value = 0.000 });
            }

            // Get the total meter values
            List<DateValueObj> MeterTotals = new List<DateValueObj>();

            if (type == 1) // Thermal
            {
                MeterTotals = GetDataHeatEnergyGeneratedByDayTotalkWh(IdLocation, startDate, endDate);
            }
            else if (type == 2) // Electrical
            {
                MeterTotals = GetkWhProducedPerDay(IdLocation, startDate, endDate);
            }

            // Get the Gas kWh
            List<DateValueObj> GasTotals = GetDataGasConsumptionkWhByDay(IdLocation, startDate, endDate);

            // Loop each Date Item
            foreach (var result in objResult)
            {
                // Find corresponding meter and gas value to date
                var MeterItem = MeterTotals.FirstOrDefault(o => o.Date == result.Date);

                var GasItem = GasTotals.FirstOrDefault(o => o.Date == result.Date);

                // Find corresponding date item by date
                var item = objResult.FirstOrDefault(o => o.Date == result.Date);
                if (item != null && MeterItem != null && GasItem != null)
                {
                    item.value = (MeterItem.value / GasItem.value) * 100;

                    //Check for Infinity Vals
                    if (double.IsInfinity(item.value.Value))
                    {
                        item.value = 0;
                    }

                }
            }

            return objResult;
        }

        public string GetThermalEfficencyJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("TotalEfficency")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "Thermal Efficency" })
                .SetSubtitle(new Subtitle { Text = "Total Thermal Efficency for this period" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "%" }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
           .SetSeries(new Series
           {
               Type = ChartTypes.Column,
               Name = "Thermal Efficency",
               Data = new Data(GetDataEfficency(IdLocation, startDate, endDate, 1).Select(s => new object[] { s.Date, s.value }).ToArray())
           });
           
            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetElectricalEfficencyJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("TotalEfficency")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "Electrical Efficency" })
                .SetSubtitle(new Subtitle { Text = "Total Electrical Efficency for this period" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "%" }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
           .SetSeries(new Series
           {
               Type = ChartTypes.Column,
               Name = "Electrical Efficency",
               Data = new Data(GetDataEfficency(IdLocation, startDate, endDate, 2).Select(s => new object[] { s.Date, s.value }).ToArray())
           });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetAllEnergyElectricalMetersChart(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("AllElectricalMetersChart")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "Electrical Meters" })
                .SetSubtitle(new Subtitle { Text = "kWh produced by Meter" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "kWh (Electrical)" }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                 .SetSeries(new Series
                 {
                     Type = ChartTypes.Column,
                     Color = System.Drawing.ColorTranslator.FromHtml("#f7a35c"),
                     Name = "kWh",
                     Data = new Data(GetkWhProducedPerDay(IdLocation, startDate, endDate).Select(s => new object[] { s.Date, s.value }).ToArray())
                 });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        #endregion

        #region Reporting

        public string GetColumnDifferenceByDayChartNoFillJS(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate, bool ScriptIt = false, string ChartId = "chart1", string ChartTitle = "", string SubTitle = "")
        {
            // Get the columns settings
            var ColPro = (from s in RsDc.ColumnNames
                          where s.HeaderId == IdColumn
                          select s).SingleOrDefault();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts(ChartId)
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = ChartTitle })
                .SetSubtitle(new Subtitle { Text = SubTitle })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = ColPro.ColumnUnits }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    //BackgroundColor = ColorTranslator.FromHtml("#FFFFFF"),
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Data = new Data(GetDataColumnDifferenceByDay(IdLocation, IdColumn, startDate, endDate.AddDays(1)).Select(s => new object[] { s.Date, s.value }).ToArray()),
                    Name = ColPro.ColumnLabel,
                    Color = CheckColorIsValid(ColPro.ColumnHtmlColor)
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetkWhPerDayChartJS(int IdLocation, DateTime startDate, DateTime endDate)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("kWhPerDay")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "kWh" })
                .SetSubtitle(new Subtitle { Text = "kWh produced by day for this period" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "kWh (Electrical)" },
                    Labels = new YAxisLabels { Formatter = "function() { return this.value +' kWh'; }" }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    Shadow = true
                })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>' + this.series.name +'</b><br/>' + Highcharts.dateFormat('%e %b', new Date(this.x)) + ', ' + this.y + ' kWh';}" })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.x +'</b>: '+ this.y + ' ' + this.series.name; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Color = System.Drawing.ColorTranslator.FromHtml("#f7a35c"),
                    Name = "kWh",
                    Data = new Data(GetkWhProducedPerDay(IdLocation, startDate, endDate).Select(s => new object[] { s.Date, s.value }).ToArray())
                });


            return chart.ToHtmlString();
        }

        public string GetDowntimeReasonsChartJS(int IdLocation, DateTime startDate, DateTime endDate)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("ShutdownReasons")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Shutdown Reasons" })
            .SetSubtitle(new Subtitle { Text = "Shutdown reasons for this period" })
            .SetCredits(new Credits { Text = "" })
            .SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
            .SetPlotOptions(new PlotOptions
            {
                Pie = new PlotOptionsPie
                {
                    AllowPointSelect = true,
                    Cursor = Cursors.Pointer,
                    DataLabels = new PlotOptionsPieDataLabels
                    {
                        //Enabled = false,
                        Color = ColorTranslator.FromHtml("#000000"),
                        ConnectorColor = ColorTranslator.FromHtml("#000000"),
                        //Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %'; }"
                    },
                    //ShowInLegend = true
                }
            })
           .SetSeries(new Series
           {
               Type = ChartTypes.Pie,
               Name = "Shutdowns",
               Data = new Data(GetShutdownReasons(IdLocation, startDate, endDate))
           });
           
           return chart.ToHtmlString();
        }

        public string GetRunHoursPerDayChartJS(int IdLocation, DateTime startDate, DateTime endDate)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("RunHoursPerDay")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "Run Hours" })
                .SetSubtitle(new Subtitle { Text = "Running hours per day for this period" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })

                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "Hours" }
                })
                .SetLegend(new Legend
                {
                    Layout = Layouts.Vertical,
                    Align = HorizontalAligns.Left,
                    VerticalAlign = VerticalAligns.Top,
                    X = 100,
                    Y = 70,
                    Floating = true,
                    Shadow = true
                })
                .SetTooltip(new Tooltip { Formatter = "function() { return '<b>' + this.series.name +'</b><br/>' + Highcharts.dateFormat('%e %b', new Date(this.x)) + ', ' + this.y + ' Hours';}" })
                //.SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.x +'</b>: '+ this.y + ' ' + this.series.name; }" })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Color = System.Drawing.ColorTranslator.FromHtml("#90ed7d"),
                    Name = "Run Hours",
                    Data = new Data(GetRunHoursPerDay(IdLocation, startDate, endDate))
                });

            return chart.ToHtmlString();
        }

        // PDFs
        public string PopuateOverTimeChartPDFJS(List<Series> chartData, bool ScriptIt = false, string YAxisTitle = "")
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Spline })
                .SetTitle(new Title { Text = "" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis
                {
                    Type = AxisTypes.Datetime,
                    TickInterval = 172800000,
                    Labels = new XAxisLabels
                       {
                           Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'",
                           Rotation = -45,
                           Step = 1
                       }
                })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = YAxisTitle },
                    Labels = new YAxisLabels
                    {
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                    },
                })
                .SetNavigation(new Navigation
                {
                    ButtonOptions = new NavigationButtonOptions
                    {
                        Enabled = false
                    }
                })
                .SetLegend(new Legend
                {
                    Enabled = false
                })
                .SetPlotOptions(new PlotOptions
                {
                    Spline = new PlotOptionsSpline
                    {
                        LineWidth = 0.5
                    }
                })
                .SetSeries(chartData.Select(s => new Series { Name = s.Name, Data = s.Data, Color = s.Color }).ToArray()
                );

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetColumnDifferenceByDayChartPDFJS(int IdLocation, int IdColumn, DateTime startDate, DateTime endDate, bool ScriptIt = false, string ChartId = "chart1", Number? Y_Max = null)
        {
            // Get the columns settings
            var ColPro = (from s in RsDc.ColumnNames
                          where s.HeaderId == IdColumn
                          select s).SingleOrDefault();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts(ChartId)
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "" })
                .SetSubtitle(new Subtitle { Text = "" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis
                {
                    Type = AxisTypes.Datetime,
                    TickInterval = 172800000,
                    Labels = new XAxisLabels
                       {
                           Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'",
                           Rotation = -45,
                           Step = 1
                       }
                })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Max = Y_Max,
                    Title = new YAxisTitle { Text = ColPro.ColumnUnits },
                    Labels = new YAxisLabels
                    {
                        Formatter = "function() { return this.value; }",
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                    },
                })
                .SetNavigation(new Navigation
                {
                    ButtonOptions = new NavigationButtonOptions
                    {
                        Enabled = false
                    }
                })
                .SetLegend(new Legend
                {
                    Enabled = false
                })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.1,
                        BorderWidth = 0,
                        DataLabels = new PlotOptionsColumnDataLabels
                        {
                            Enabled = true,
                            Rotation = -65,
                            Align = HorizontalAligns.Center,
                            VerticalAlign = VerticalAligns.Top,
                            Format = "{point.y:,.0f}",
                            Y = -15,
                            Shadow = false,
                            Style = "color: '#000000', fontSize: '6px', fontFamily: 'Verdana, sans-serif'",
                            Crop = false
                        }
                    },
                })
                .SetSeries(new Series
                {
                    Type = ChartTypes.Column,
                    Data = new Data(GetDataColumnDifferenceByDay(IdLocation, IdColumn, startDate, endDate.AddDays(1)).Select(s => new object[] { s.Date, s.value }).ToArray()),
                    Name = ColPro.ColumnLabel,
                    Color = CheckColorIsValid(ColPro.ColumnHtmlColor)
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetAllEnergyThermalMetersChartPDFJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("AllHeatMetersChart")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "" })
                .SetSubtitle(new Subtitle { Text = "" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis
                {
                    Type = AxisTypes.Datetime,
                    TickInterval = 172800000,
                    Labels = new XAxisLabels
                    {
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'",
                        Rotation = -45,
                        Step = 1
                    }
                })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "kWh (Thermal)" },
                    Labels = new YAxisLabels
                    {
                        Formatter = "function() { return this.value; }",
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                    },
                    StackLabels = new YAxisStackLabels
                    {
                        Enabled = true,
                        Rotation = -65,
                        Align = HorizontalAligns.Center,
                        VerticalAlign = VerticalAligns.Top,
                        Y = -15,
                        Formatter = @"function() { return ((Math.round(this.total)) + '').replace(/(\d)(?=(\d{3})+$)/g, '$1 ');; }",
                        Style = "color: '#000000', fontSize: '6px', fontFamily: 'Verdana, sans-serif'"
                    }
                })
                .SetNavigation(new Navigation
                {
                    ButtonOptions = new NavigationButtonOptions
                    {
                        Enabled = false
                    }
                })
                .SetLegend(new Legend
                {
                    Style = "fontSize: '6px', fontFamily: 'Verdana, sans-serif'"
                })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.2,
                        BorderWidth = 0
                    }
                })
                .SetSeries(GetDataHeatEnergyGeneratedByDayByMeterkWh(ChartTypes.Column, IdLocation, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59))
                    .Select(s => new Series { Name = s.Name, Data = s.Data }).ToArray()
                );

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetTotalGasUsageChartPDFJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("TotalGasConsumption")
                .InitChart(new Chart { ZoomType = ZoomTypes.Xy })
                .SetTitle(new Title { Text = "" })
                .SetSubtitle(new Subtitle { Text = "" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { 
                    Type = AxisTypes.Datetime,
                    TickInterval = 172800000,
                    Labels = new XAxisLabels
                    {
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'",
                        Rotation = -45,
                        Step = 1
                    }
                })
                .SetNavigation(new Navigation 
                { 
                    ButtonOptions = new NavigationButtonOptions
                    { 
                        Enabled = false
                    }
                })
                .SetLegend(new Legend
                {
                    Enabled = false
                })
               .SetYAxis(new[]
                {
                    new YAxis
                    {
                        Labels = new YAxisLabels
                        {
                            Formatter = "function() { return this.value +' m3'; }",
                            Style = "color: '#89A54E', fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                        },
                        Title = new YAxisTitle
                        {
                            Text = "Comsumption (m3)",
                            Style = "color: '#89A54E', fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                        },
                        MaxPadding = 0.1,
                    },
                    new YAxis
                    {
                        Labels = new YAxisLabels
                        {
                            Formatter = "function() { return this.value +' kWh'; }",
                            Style = "color: '#4572A7', fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                        },
                        Title = new YAxisTitle
                        {
                            Text = "Comsumption (kWh)",
                            Style = "color: '#4572A7', fontSize: '8px', fontFamily: 'Verdana, sans-serif'"
                        },
                        MaxPadding = 0.1,
                        Opposite = true
                    }
                })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.1,
                        BorderWidth = 0,
                        DataLabels = new PlotOptionsColumnDataLabels
                        {
                            Enabled = true,
                            Rotation = -65,
                            Align = HorizontalAligns.Center,
                            VerticalAlign = VerticalAligns.Top,
                            Format = "{point.y:,.0f}",
                            Y = -15,
                            Shadow = false,
                            Style = "color: '#4572A7', fontSize: '6px', fontFamily: 'Verdana, sans-serif'",
                            Crop = false
                        }
                    },
                    Spline = new PlotOptionsSpline
                    {
                        Stacking = Stackings.Normal,
                        DataLabels = new PlotOptionsSplineDataLabels
                        {
                            Enabled = true,
                            Rotation = -65,
                            Align = HorizontalAligns.Center,
                            VerticalAlign = VerticalAligns.Top,
                            Y = -15,
                            Format = "{point.y:,.0f}",
                            Shadow = false,
                            Style = "color: '#89A54E', fontSize: '6px', fontFamily: 'Verdana, sans-serif'",
                            Crop = false
                        }
                    }
                })
                .SetSeries(new[]
                {
                    new Series
                    {
                        Name = "Gas Consumption (kWh)",
                        Color = ColorTranslator.FromHtml("#4572A7"),
                        Type = ChartTypes.Column,
                        YAxis = "1",
                        Data = new Data(GetDataGasConsumptionkWhByDay(IdLocation, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59)).Select(s => new object[] { s.Date, s.value }).ToArray())
                    },
                    new Series
                    {
                        Name = "Gas Consumption (m3)",
                        Color = ColorTranslator.FromHtml("#89A54E"),
                        Type = ChartTypes.Spline,
                        Data = new Data(GetDataGasConsumptionVolumeByDay(IdLocation, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59)).Select(s => new object[] { s.Date, s.value }).ToArray())
                    }
                });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetThermalEfficencyPDFJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("TotalEfficency")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "" })
                .SetSubtitle(new Subtitle { Text = "" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { 
                    Type = AxisTypes.Datetime,
                    TickInterval = 172800000,
                    Labels = new XAxisLabels
                    {
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'",
                        Rotation = -45,
                        Step = 1
                    } })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "Percent (%)" },
                    Labels = new YAxisLabels { Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'" }
                })
                .SetNavigation(new Navigation
                {
                    ButtonOptions = new NavigationButtonOptions
                    {
                        Enabled = false
                    }
                })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.1,
                        BorderWidth = 0,
                        DataLabels = new PlotOptionsColumnDataLabels
                        {
                            Enabled = true,
                            Rotation = -65,
                            Align = HorizontalAligns.Center,
                            VerticalAlign = VerticalAligns.Top,
                            Y = -10,
                            Format = "{point.y:,.1f}",
                            Shadow = false,
                            Style = "fontSize: '6px', fontFamily: 'Verdana, sans-serif'",
                            Crop = false
                        }
                    }
                })
                .SetLegend(new Legend
                {
                    Enabled = false
                })
               .SetSeries(new Series
               {
                   Type = ChartTypes.Column,
                   Name = "Thermal Efficency",
                   Data = new Data(GetDataEfficency(IdLocation, startDate, endDate, 1).Select(s => new object[] { s.Date, s.value }).ToArray())
               });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public string GetElectricalEfficencyPDFJS(int IdLocation, DateTime startDate, DateTime endDate, bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("TotalEfficency")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "" })
                .SetSubtitle(new Subtitle { Text = "" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis
                {
                    Type = AxisTypes.Datetime,
                    TickInterval = 172800000,
                    Labels = new XAxisLabels
                    {
                        Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'",
                        Rotation = -45,
                        Step = 1
                    }
                })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "Percent (%)" },
                    Labels = new YAxisLabels { Style = "fontSize: '8px', fontFamily: 'Verdana, sans-serif'" }
                })
                .SetNavigation(new Navigation
                {
                    ButtonOptions = new NavigationButtonOptions
                    {
                        Enabled = false
                    }
                })
                .SetPlotOptions(new PlotOptions
                {
                    Column = new PlotOptionsColumn
                    {
                        Stacking = Stackings.Normal,
                        PointPadding = 0.1,
                        BorderWidth = 0,
                        DataLabels = new PlotOptionsColumnDataLabels
                        {
                            Enabled = true,
                            Rotation = -65,
                            Align = HorizontalAligns.Center,
                            VerticalAlign = VerticalAligns.Top,
                            Y = -10,
                            Format = "{point.y:,.1f}",
                            Shadow = false,
                            Style = "fontSize: '6px', fontFamily: 'Verdana, sans-serif'",
                            Crop = false
                        }
                    }
                })
                .SetLegend(new Legend
                {
                    Enabled = false
                })
               .SetSeries(new Series
               {
                   Type = ChartTypes.Column,
                   Name = "Electrical Efficency",
                   Data = new Data(GetDataEfficency(IdLocation, startDate, endDate, 2).Select(s => new object[] { s.Date, s.value }).ToArray())
                   
               });

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        #endregion        

        #region Dataloggers

        public string PopuateOverTimeChartDataloggersJS(List<Series> chartData, string ChartTitle = "Trend Chart", bool ScriptIt = false)
        {
            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
                .InitChart(new Chart { Type = ChartTypes.Spline, ClassName = "fill", ZoomType = ZoomTypes.X })
                .SetTitle(new Title { Text = ChartTitle })
                .SetSubtitle(new Subtitle { Text = "Click and drag in the plot area to zoom in" })
                .SetCredits(new Credits { Text = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "Value (%)" }
                })
                .SetTooltip(new Tooltip
                {
                    Formatter = @"function() { return Highcharts.dateFormat('%e %b %Y %I:%M %p',
                                          new Date(this.x)) + '<br>' + this.series.name + ': <b>'+ this.y + '</b>'; }"
                })
                .SetPlotOptions(new PlotOptions
                {
                    Spline = new PlotOptionsSpline
                    {
                        LineWidth = 1
                    }
                })
                .SetSeries(chartData.Select(s => new Series { Name = s.Name, Data = s.Data, Color = s.Color }).ToArray()
                );

            if (ScriptIt)
            {
                return chartHtmltoScript(chart.ToHtmlString());
            }
            else
            {
                return chart.ToHtmlString();
            }
        }

        public Series GetGSMSignalTurbo(int IdBlackbox, DateTime startDate, DateTime endDate)
        {
            // Returns a 2d array
            List<Series> SeriesData = new List<Series>();

            RsDc.CommandTimeout = 60 * 3; // Change the timeout period          

            // If the startdate and enddate are the same add 24 hours
            if (startDate.Date == endDate.Date)
            {
                endDate = endDate.AddDays(1);
            }

            // get data from db and convert it to chart data (name, value, date)

            var chartSeries = RsDc.Blackboxes_Status.Where(x => x.Timestamp >= startDate && x.Timestamp <= endDate)
                                .Where(x => x.ID_Blackbox == IdBlackbox)
                                .OrderBy(x => x.Timestamp)
                                .Select(g => new
                                {
                                    Data = g.ST_GSMSignalLevel,
                                    Date = g.Timestamp
                                }).ToArray();

            // create 2D array => [value, date]
            int length = chartSeries.Count();
            object[,] data = new object[length, 2];
            int i = 0;

            foreach (var item in chartSeries)
            {
                if (item.Data != null)
                {
                    data[i, 0] = (item.Date - new DateTime(1970, 1, 1, 0, 0, 0)).TotalMilliseconds;
                    data[i, 1] = item.Data;
                }
                i++;
            }

            Series localSeries = new Series { Name = "GSM Signal (%)", Data = new Data(InsertEmptyPointsMinutes(5, data)) };
            return localSeries;
        }

        public Series GetBatteryChargeLevelTurbo(int IdBlackbox, DateTime startDate, DateTime endDate)
        {
            // Returns a 2d array
            List<Series> SeriesData = new List<Series>();

            RsDc.CommandTimeout = 60 * 3; // Change the timeout period          

            // If the startdate and enddate are the same add 24 hours
            if (startDate.Date == endDate.Date)
            {
                endDate = endDate.AddDays(1);
            }

            // get data from db and convert it to chart data (name, value, date)

            var chartSeries = RsDc.Blackboxes_Status.Where(x => x.Timestamp >= startDate && x.Timestamp <= endDate)
                                .Where(x => x.ID_Blackbox == IdBlackbox)
                                .OrderBy(x => x.Timestamp)
                                .Select(g => new
                                {
                                    Data = g.ST_BatteryChargeLevel,
                                    Date = g.Timestamp
                                }).ToArray();

            // create 2D array => [value, date]
            int length = chartSeries.Count();
            object[,] data = new object[length, 2];
            int i = 0;

            foreach (var item in chartSeries)
            {
                if (item.Data != null)
                {
                    data[i, 0] = (item.Date - new DateTime(1970, 1, 1, 0, 0, 0)).TotalMilliseconds;
                    data[i, 1] = item.Data * 20;
                }
                i++;
            }

            Series localSeries = new Series { Name = "Charge Level (%)", Data = new Data(InsertEmptyPointsMinutes(5, data)) };
            return localSeries;
        }

        #endregion
    }
}