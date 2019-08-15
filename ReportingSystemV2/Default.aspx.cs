using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Collections.ObjectModel;
using DotNet.Highcharts.Options;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Enums;
using System.Drawing;
using ReportingSystemV2.Models;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2

{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int[] Charts = Shared.getUsersDashboardCharts(Page.User.Identity.GetUserId());

            LitTopLeft.Text = getChartByNo(Charts[0]);
            LitTopRight.Text = getChartByNo(Charts[1]);
            LitBottomLeft.Text = getChartByNo(Charts[2]);
            LitBottomRight.Text = getChartByNo(Charts[3]);
        }

        protected string getChartByNo(int Chart)
        {
            switch (Chart)
            {
                case 1:
                    return ContractOutputChart();
                case 2:
                    return ContractTypeChart();
                case 3:
                    return GeneratorGasTypeChart();
                case 4:
                    return GeneratorMakeChart();
                case 5:
                    return GeneratorModelChart();
                default:
                    return "";
            }
        }

        protected string GeneratorModelChart()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart1")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Model" })
            .SetSubtitle(new Subtitle { Text = "Generators by Model" })
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
                        Enabled = true,
                        Color = ColorTranslator.FromHtml("#000000"),
                        ConnectorColor = ColorTranslator.FromHtml("#000000"),
                        Format = "<b>{point.name}</b>: {point.percentage:.1f} %"
                    },
                    //ShowInLegend = true
                }
            })
           .SetSeries(new Series
           {
               Type = ChartTypes.Pie,
               Name = "Model",
               Data = new Data(ChData.GetEnginesByTypeDescription())
           });
            return chart.ToHtmlString();
        }

        protected string ContractOutputChart()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart2")
            .InitChart(new Chart { PlotBackgroundColor = null, PlotBorderWidth = null, PlotShadow = false })
            .SetTitle(new Title { Text = "Output" })
            .SetSubtitle(new Subtitle { Text = "Generators by Contracted Output" })
            .SetCredits(new Credits { Text = "", Href = "" })
            .SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.point.y; }" })
            .AddJavascripVariable("colors", "Highcharts.getOptions().colors")
            .SetPlotOptions(new PlotOptions
            {
                Pie = new PlotOptionsPie
                {
                    AllowPointSelect = true,
                    Cursor = Cursors.Pointer,
                    DataLabels = new PlotOptionsPieDataLabels
                    {
                        //Enabled = false,
                        //Color = ColorTranslator.FromHtml("#000000"),
                        //ConnectorColor = ColorTranslator.FromHtml("#000000"),
                        Style = "color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'"
                        //Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %'; }"
                    },
                    //ShowInLegend = true
                }
            })
           .SetSeries(new Series
           {
               Type = ChartTypes.Pie,
               Name = "Output (kWh)",
               Data = new Data(ChData.GetEnginesByContractedOutput())
           });
            return chart.ToHtmlString();
        }

        protected string ContractTypeChart()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart3")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Type" })
            .SetSubtitle(new Subtitle { Text = "Generators by Contract Type" })
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
                        Enabled = true,
                        Color = ColorTranslator.FromHtml("#000000"),
                        ConnectorColor = ColorTranslator.FromHtml("#000000"),
                        Format = "<b>{point.name}</b>: {point.percentage:.1f} %"
                    },
                    //ShowInLegend = true
                }
            })
           .SetSeries(new Series
           {
               Type = ChartTypes.Pie,
               Name = "Contract Type",
               Data = new Data(ChData.GetEnginesByContractType())
           });
            return chart.ToHtmlString();
        }

        protected string GeneratorMakeChart()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart4")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Manufacturer" })
            .SetSubtitle(new Subtitle { Text = "Generators by Manufacturer" })
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
                        Enabled = true,
                        Color = ColorTranslator.FromHtml("#000000"),
                        ConnectorColor = ColorTranslator.FromHtml("#000000"),
                        Format = "<b>{point.name}</b>: {point.percentage:.1f} %"
                    },
                    //ShowInLegend = true
                }
            })
           .SetSeries(new Series
           {
               Type = ChartTypes.Pie,
               Name = "Manufacturer",
               Data = new Data(ChData.GetEnginesByTypeMake())
           });
           return chart.ToHtmlString();
        }

        protected string GeneratorGasTypeChart()
        {
            ChartBuilder ChData = new ChartBuilder();

            DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart5")
            .InitChart(new Chart { PlotShadow = false })
            .SetTitle(new Title { Text = "Gas" })
            .SetSubtitle(new Subtitle { Text = "Generators by Gas Supply" })
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
                        Enabled = true,
                        Color = ColorTranslator.FromHtml("#000000"),
                        ConnectorColor = ColorTranslator.FromHtml("#000000"),
                        Format = "<b>{point.name}</b>: {point.percentage:.1f} %"
                    },
                    //ShowInLegend = true
                }
            })
           .SetSeries(new Series
           {
               Type = ChartTypes.Pie,
               Name = "Gas",
               Data = new Data(ChData.GetEnginesByGasType())
           });
            return chart.ToHtmlString();
        }

        protected void print_click(object sender, EventArgs e)
        {
          //when i click this button i need to call javascript function
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append(@"<script language='javascript'>");
                    sb.Append(@"example();");
                    sb.Append(@"</script>");
             System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), "JCall1", sb.ToString(), false);
        }  
    }
}