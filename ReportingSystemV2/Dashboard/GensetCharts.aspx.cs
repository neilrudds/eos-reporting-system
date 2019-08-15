using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNet.Highcharts;
using DotNet.Highcharts.Options;
using DotNet.Highcharts.Helpers; // for Data
using DotNet.Highcharts.Enums;
using ReportingSystemV2.Reporting;

namespace ReportingSystemV2.Dashboard
{
    public partial class GensetCharts : System.Web.UI.Page
    {
        DB db = new DB(); //Instance of the DB Class

        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        public string GensetSerial;

        [PersistenceMode(PersistenceMode.Attribute)]
        public int IdLocation
        {
            get
            {
                if (ViewState["IdLocation"] == null)
                    ViewState["IdLocation"] = 0;

                return (int)ViewState["IdLocation"];
            }
            set
            {
                ViewState["IdLocation"] = value;
            }
        }

        [PersistenceMode(PersistenceMode.Attribute)]
        protected DateTime startDate
        {
            get
            {
                if (ViewState["startDate"] == null)
                    ViewState["startDate"] = DateTime.Now.AddDays(-1);

                return (DateTime)ViewState["startDate"];
            }
            set
            {
                ViewState["startDate"] = value;
            }
        }

        [PersistenceMode(PersistenceMode.Attribute)]
        protected DateTime endDate
        {
            get
            {
                if (ViewState["endDate"] == null)
                    ViewState["endDate"] = DateTime.Now.AddDays(-1);

                return (DateTime)ViewState["endDate"];
            }
            set
            {
                ViewState["endDate"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle date change
            DateRangeSelect.dateChanged += new DateRangeSelect.dateChangedEventHandler(report_DateChanged);

            // Handle checkbox clicks
            chklstPlot.Attributes.Add("onclick", "return radioMe(event)");

            if (Request.QueryString["id"] != null)
            {
                IdLocation = int.Parse(Request.QueryString["id"]);
                GensetSerial = (from at in RsDc.HL_Locations where at.ID == IdLocation select at).Select(a => a.GENSET_SN).Single();
                lbl_subHeader.InnerHtml = "serial." + GensetSerial;
                Page.DataBind();
            }

            if (!Page.IsPostBack)
            {
                // Startup views
                if (ddlChartType.SelectedValue == "0")
                {
                    bindInstantaneousList();
                    checkDefault();
                    bindGraph(IdLocation, DateTime.Now.AddDays(-1), DateTime.Now, true);
                }
                else
                {
                    bindCumulativeList();
                    bindGraph(IdLocation, DateTime.Now.AddDays(-7), DateTime.Now.AddDays(-1), true);
                }
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Rebind the default checked items
            if (!Page.IsPostBack)
            {
                checkDefault();
            }
        }

        protected void bindInstantaneousList()
        {
            chklstPlot.DataSource = (from c in RsDc.ColumnNames
                                     where c.IsInstantaneousPlot == true
                                     orderby c.ColumnLabel
                                     select new
                                     {
                                         c.ColumnLabel,
                                         c.HeaderId
                                     });

            chklstPlot.DataTextField = "ColumnLabel";
            chklstPlot.DataValueField = "HeaderId";
            chklstPlot.DataBind();
        }

        protected void bindCumulativeList()
        {
            chklstPlot.DataSource = (from c in RsDc.ColumnNames
                                     where c.IsCumulativePlot == true
                                     orderby c.ColumnLabel
                                     select new
                                     {
                                         c.ColumnLabel,
                                         c.HeaderId
                                     });

            chklstPlot.DataTextField = "ColumnLabel";
            chklstPlot.DataValueField = "HeaderId";
            chklstPlot.DataBind();
        }

        protected void checkDefault()
        {
            // Select an initial value on load
            if (chklstPlot != null)
            {
                foreach (ListItem item in chklstPlot.Items)
                {
                    if (item.Text == "Power" || item.Text == "Energy Generated (kWh)")
                    {
                        item.Selected = true;
                    }
                }
            }
        }

        // Chart type has changed
        protected void ddlChartType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlChartType.SelectedValue == "0")
            {
                // Instantaneous chart, show yesterdays power graph as default
                bindInstantaneousList();
                checkDefault();
                bindGraph(IdLocation, DateTime.Now.AddDays(-1), DateTime.Now);
            }
            else if (ddlChartType.SelectedValue == "1")
            {
                // Cumulative per hour, show yesterdays hourly kWh readings as default
                bindCumulativeList();
                checkDefault();
                bindGraph(IdLocation, DateTime.Now.AddDays(-1).Date, DateTime.Now.Date);

                // Change the date time range displayed.....               
                // Update the client
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#reportrange span').html(moment('" + DateTime.Now.AddDays(-1).ToString("MM/dd/yyyy") + "').format('D MMMM, YYYY') + ' - ' + moment('" + (DateTime.Now.AddDays(-1).ToString("MM/dd/yyyy") + "').format('D MMMM, YYYY'));"));
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);
            }
            else if (ddlChartType.SelectedValue == "2")
            {
                // Cumulative per day, show the previous 7 days kWh readings as default
                bindCumulativeList();
                checkDefault();
                bindGraph(IdLocation, DateTime.Now.AddDays(-7).Date, DateTime.Now.Date);

                // Change the date time range displayed.....               
                // Update the client
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#reportrange span').html(moment('" + DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy") + "').format('D MMMM, YYYY') + ' - ' + moment('" + (DateTime.Now.AddDays(-1).ToString("MM/dd/yyyy") + "').format('D MMMM, YYYY'));"));
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);
            }
            else if (ddlChartType.SelectedValue == "3")
            {
                // Cumulative per month, show the previous 6 months kWh readings as default
                bindCumulativeList();
                checkDefault();
                bindGraph(IdLocation, DateTime.Now.AddMonths(-5), DateTime.Now.Date);

                // Change the date time range displayed.....               
                // Update the client
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("$('#reportrange span').html(moment('" + DateTime.Now.AddMonths(-5).ToString("MM/dd/yyyy") + "').format('D MMMM, YYYY') + ' - ' + moment('" + (DateTime.Now.AddDays(-1).ToString("MM/dd/yyyy") + "').format('D MMMM, YYYY'));"));
                sb.Append(@"</script>");

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);
            }
        }

        // Detect changes in date selection
        private void report_DateChanged(object sender, DateChangedEventArgs e)
        {
            startDate = e.startDate;
            endDate = e.endDate;
            bindGraph(IdLocation, e.startDate, e.endDate);
        }

        // Detect changes in plot selection
        protected void chklstPlot_SelectedIndexChanged(object sender, EventArgs e)
        {
            bindGraph(IdLocation, startDate, endDate);
        }

        // Bind a graph for the client
        protected void bindGraph(int IdLoc, DateTime startDate, DateTime endDate, bool PostBack = false)
        {
            List<Series> SeriesData = new List<Series>(); //Store for the trend series'
            ChartBuilder Cb = new ChartBuilder();
            System.Text.StringBuilder eb = new System.Text.StringBuilder(); //String of faulty columns
            string myJSCode;
            bool error = false;

            foreach (ListItem listItem in chklstPlot.Items)
            {
                if (listItem.Selected) // For each selected item get the data
                {
                    try
                    {
                        if (ddlChartType.SelectedValue == "0") // Trend Graph
                        {
                            try
                            {
                                // Add the data to series of data
                                SeriesData.Add(Cb.GetChartDatafromColumnTurbo(IdLoc, Int32.Parse(listItem.Value), startDate, endDate));
                            }
                            catch (Exception ex)
                            {
                                eb.Append("{"+ listItem.Text +"}"); // If the column failed, add it to a list for the error msg
                                error = true;
                            }
                        }
                        else if (ddlChartType.SelectedValue == "1") // Per Hour
                        {
                            if (PostBack) {
                                chartLiteral.Text = Cb.GetColumnDifferenceByHourChartJS(IdLoc, Int32.Parse(listItem.Value), startDate, endDate);
                            } else {
                                myJSCode = Cb.GetColumnDifferenceByHourChartJS(IdLoc, Int32.Parse(listItem.Value), startDate, endDate, true);
                                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
                            }
                        }
                        else if (ddlChartType.SelectedValue == "2") // Per Day
                        {
                            // Always show at least 7 days
                            if ((endDate - startDate).TotalDays < 7)
                            {
                                startDate = startDate.AddDays((6 - (endDate - startDate).TotalDays) * -1);
                            }
                            if (PostBack)
                            {
                                chartLiteral.Text = Cb.GetColumnDifferenceByDayChartJS(IdLoc, Int32.Parse(listItem.Value), startDate, endDate);
                            }
                            else
                            {
                                myJSCode = Cb.GetColumnDifferenceByDayChartJS(IdLoc, Int32.Parse(listItem.Value), startDate, endDate, true);
                                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
                            }
                        }
                        else if (ddlChartType.SelectedValue == "3") // Per Month
                        {
                            // Always show at least 6 months
                            if ((endDate - startDate).TotalDays < 180)
                            {
                                startDate = startDate.AddDays((179 - (endDate - startDate).TotalDays) * -1);
                            }
                            if (PostBack)
                            {
                                chartLiteral.Text = Cb.GetColumnDifferenceByMonthChartJS(IdLoc, Int32.Parse(listItem.Value), startDate, endDate);
                            }
                            else
                            {
                                myJSCode = Cb.GetColumnDifferenceByMonthChartJS(IdLoc, Int32.Parse(listItem.Value), startDate, endDate, true);
                                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append(@"<script type='text/javascript'>");
                        sb.Append("bootstrap_alert.warning('warning', 'Oops!', 'Unable to add the column. The data is either currently unavaliable or incorrectly formatted.');");
                        sb.Append(@"</script>");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);

                        LogMe.LogSystemException(ex.Message);
                    }

                }
            }

            // Apply Trends
            if (ddlChartType.SelectedValue == "0") // OverTime Plot
            {
                if (error && eb.Length != 0)
                {
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append(@"<script type='text/javascript'>");
                    sb.Append("bootstrap_alert.warning('warning', 'Oops!', 'Unable to add one or more columns "+ eb.ToString() +". The data is either currently unavaliable or incorrectly formatted.');");
                    sb.Append(@"</script>");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);
                }
                else
                {
                    // Clear errors
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Guid.NewGuid().ToString()", "<script type='text/javascript'>bootstrap_alert.clear();</script>", false);
                }

                if (PostBack)
                {
                    chartLiteral.Text = Cb.PopuateOverTimeChartJS(SeriesData);
                }
                else
                {
                    myJSCode = Cb.PopuateOverTimeChartJS(chartData:SeriesData, ScriptIt:true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
                }
            }
        }
    }
}