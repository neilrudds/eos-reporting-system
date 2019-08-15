using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNet.Highcharts;
using DotNet.Highcharts.Options;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Enums;
using System.Drawing;
using ReportingSystemV2.Models;

namespace ReportingSystemV2.Reporting
{
    public partial class ReportingOverview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.reportDateChanged += new EventHandler(report_DateChanged);
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;

            if (!Page.IsPostBack)
            {
                PopulateGrid(f.startDate, f.endDate);
                LitChartUpdates.Text = GetSiteUpdates();
                LitChartShutdownCat.Text = GetShutdownCategories();
                LitChartShutdownReas.Text = GetShutdownReasons();
            }
        }

        private void report_DateChanged(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;

            PopulateGrid(f.startDate, f.endDate);
        }

        protected void PopulateGrid(DateTime startDT, DateTime endDT)
        {
            CustomDataContext db = new CustomDataContext();

            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));
            
            // Get the current logged in User and look up the user in ASP.NET Identity
            var currentUser = manager.FindById(User.Identity.GetUserId());

            // Get the site access array to list for query
            var SiteAccessList = currentUser.SiteAccessArray.Split(',').ToList();

            var query = from h in db.GetMembersMatchingSites(SiteAccessList, startDT, endDT)
                        orderby h.GENSETNAME
                        select new
                        {
                            Id = h.ID_LOCATION,
                            GensetName = h.GENSETNAME,
                            HoursRun = h.HOURSRUN,
                            KwProduced = h.KWPRODUCED,
                            NoStops = h.NOSTOPS,
                            FirstStart = h.FIRSTSTART,
                            LastStop = h.LASTSTOP,
                            StartDate = startDT,
                            EndDate = endDT
                        };

            gridSummary.DataSource = query.ToList();
            gridSummary.DataBind();

            //CSS Header Sytle
            gridSummary.UseAccessibleHeader = true;
            gridSummary.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        #region Gridview Links
        //Grid Link Creators
        protected string linkGenerator(string genname, string id, object startDT, object endDT)
        {
            return string.Format("<a href=\"GensetReport.aspx?id={0}&dtstart={1:yyyy-MM-dd}&dtend={2:yyyy-MM-dd}\">{3}</a>", id, startDT, endDT, genname);
        }

        protected string linkHoursRun(object hrs, string id, object startDT, object endDT)
        {
            if (hrs == null)
                return "N/A";

            return string.Format("<a href=\"GensetReport.aspx?id={0}&dtstart={1:yyyy-MM-dd}&dtend={2:yyyy-MM-dd}\">{3}</a>", id, startDT, endDT, hrs);
            //return string.Format("<a href=\"chartView.aspx?id={0}&dtstart={1:yyyy-MM-dd}&dtend={2:yyyy-MM-dd}\">{3}</a>", id, startDT, endDT, hrs);
        }

        protected string linkKWProduced(object kw, string id, object startDT, object endDT)
        {
            if (kw == null)
                return "N/A";

            return string.Format("<a href=\"GensetReport.aspx?id={0}&dtstart={1:yyyy-MM-dd}&dtend={2:yyyy-MM-dd}\">{3}</a>", id, startDT, endDT, kw);
            //return string.Format("<a href=\"chartView.aspx?id={0}&dtstart={1:yyyy-MM-dd}&dtend={2:yyyy-MM-dd}\">{3}</a>", id, startDT, endDT, kw);
        }

        protected string linkNoStops(object no, string id, object startDT, object endDT)
        {
            if (no == null)
                return "0";

            return string.Format("<a href=\"GensetDowntime.aspx?id={0}&dtstart={1:yyyy-MM-dd}&dtend={2:yyyy-MM-dd}\">{3}</a>", id, startDT, endDT, no.ToString());
        }

        protected string callAvailability(string id, object hrsrun, object startDT, object endDT)
        {
            string str = "availability(" + id + ",'" + string.Format("{0:yyyy-MM-dd}", startDT) + "','" + string.Format("{0:yyyy-MM-dd}", endDT) + "','" + (hrsrun ?? string.Empty).ToString() + "');";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "avail" + id, str, true);
            return "";
        }

        #endregion

        #region Charts

        protected string GetShutdownCategories()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
                .InitChart(new Chart { DefaultSeriesType = ChartTypes.Column })
                .SetTitle(new Title { Text = "Shutdown Categories" })
                .SetSubtitle(new Subtitle { Text = "Categorized shutdowns for the past 7 days" })
                .SetCredits(new Credits { Text = "" , Href = "" })
                .SetXAxis(new XAxis { Type = AxisTypes.Datetime })
                .SetYAxis(new YAxis
                {
                    Min = 0,
                    Title = new YAxisTitle { Text = "No. of shutdowns" }
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
                .SetSeries(ChData.GetExemptChartData(ChartTypes.Column, DateTime.Now.AddDays(-7).Date, DateTime.Now.Date).Select(s => new Series { Name = s.Name, Data = s.Data }).ToArray()
                );
                return chart.ToHtmlString();
        }

        protected string GetSiteUpdates()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart2")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Updates" })
            .SetSubtitle(new Subtitle { Text = "Sites updated in the past 24 hours" })
            .SetCredits(new Credits { Text = "", Href = "" })
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
                Name = "Updates",
                Data = new Data(ChData.GetUpdatesChartData())
           });
            return chart.ToHtmlString();
        }

        protected string GetShutdownReasons()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart10")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Shutdown Reasons" })
            .SetSubtitle(new Subtitle { Text = "Shutdown reasons for the past 24 hours" })
            .SetCredits(new Credits { Text = "", Href = "" })
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
               Data = new Data(ChData.GetTopTenReasonsForAll())
           });
            return chart.ToHtmlString();
        }

        #endregion
    }
}