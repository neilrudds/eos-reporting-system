using DotNet.Highcharts.Enums;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Options;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Reporting
{
    public partial class GensetElectPerf : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

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
                    if (f.endDate < f.startDate)
                    {
                        Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('alert-warning', 'Oops!', 'Please select a valid date range..');", true);
                    }

                    if (CheckSettings(f.IdLocation))
                    {
                        // Summary
                        BindSummary(f.IdLocation, f.startDate, f.endDate);

                        // Charts
                        chartAllMeters.Text = Cb.GetAllEnergyElectricalMetersChart(f.IdLocation, f.startDate, f.endDate);
                        chartTotGas.Text = Cb.GetTotalGasUsageChartJS(f.IdLocation, f.startDate, f.endDate);
                        chartTotElectEff.Text = Cb.GetElectricalEfficencyJS(f.IdLocation, f.startDate, f.endDate);
                    }
                    else
                    {
                        showConfigMsg(true);
                    }
                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('alert-warning', 'Oops!', 'Please select a site..');", true);

                }
            }
        }

        private void report_DateChanged(object sender, EventArgs e)
        {
            ReportingBase f = (ReportingBase)Page.Master;
            ChartBuilder Cb = new ChartBuilder();

            BindSummary(f.IdLocation, f.startDate, f.endDate);

            // Charts
            string myJSCode;
            myJSCode = Cb.GetAllEnergyElectricalMetersChart(f.IdLocation, f.startDate, f.endDate, true);
            myJSCode += Cb.GetTotalGasUsageChartJS(f.IdLocation, f.startDate, f.endDate, true);
            myJSCode += Cb.GetElectricalEfficencyJS(f.IdLocation, f.startDate, f.endDate, true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), myJSCode, false);
        }

        protected void showConfigMsg(bool show)
        {
            // Shows or Hides the missing configuration msg
            ElectricalPerfDiv.Visible = !show;

            ElectricalMissingConfigDiv.Visible = show;
        }

        protected bool CheckSettings(int location)
        {
            // Gas Meter Address
            var meterAddr = (from s in RsDc.GasMeters_Mappings
                             where s.ID_Location == location
                             select s.Modbus_Addr).SingleOrDefault();

            var meterColumnName = (from s in RsDc.ConfigEfficiencies
                                   where s.IdLocation == location
                                   select s.GasVolumeColumnName).SingleOrDefault();

            if ((meterAddr == null || meterAddr == 0 || meterAddr == -1) & (meterColumnName == "" || meterColumnName == null))
            {
                // No Gas Meter defines
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('warning', 'Oops!', 'A valid Gas Meter has not been declared. Please define a ComAp column name or E&H meter address in the sites configuration for efficiency reports!');", true);
                return false;
            }
            else
            {
                return true;
            }
        }

        protected void BindSummary(int location, DateTime startDate, DateTime endDate)
        {
            ChartBuilder ChData = new ChartBuilder();

            // Efficenct Averages
            var EffObj = ChData.GetDataEfficency(location, startDate, endDate, 2);

            double EffTotal = 0;
            int EffCount = 0;

            foreach (var Eff in EffObj)
            {
                if (Eff.value != 0)
                {
                    EffTotal += Convert.ToDouble(Eff.value);
                    EffCount++;
                }
            }

            // Remove 0's from array
            var ValidEff = EffObj.Where(x => x.value != 0).ToArray();
            var EffMax = ValidEff.Max(x => x.value);
            var EffMin = ValidEff.Min(x => x.value);

            // Avarage Energy Produced
            double EnergykWhTotal = 0;
            int EnergykWhCount = 0;

            foreach (var Energy in ChData.GetkWhProducedPerDay(location, startDate, endDate))
            {
                if (Energy.value != 0)
                {
                    EnergykWhTotal += Convert.ToDouble(Energy.value);
                    EnergykWhCount++;
                }
            }

            // Gas kWh Average
            double GaskWhTotal = 0;
            int GaskWhCount = 0;

            foreach (var kWh in ChData.GetDataGasConsumptionkWhByDay(location, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59)))
            {
                if (kWh.value != 0)
                {
                    GaskWhTotal += Convert.ToDouble(kWh.value);
                    GaskWhCount++;
                }
            }

            double GasVolTotal = 0;
            int GasVolCount = 0;

            foreach (var vol in ChData.GetDataGasConsumptionVolumeByDay(location, startDate, endDate.AddHours(23).AddMinutes(59).AddSeconds(59)))
            {
                if (vol.value != 0)
                {
                    GasVolTotal += Convert.ToDouble(vol.value);
                    GasVolCount++;
                }
            }

            // Meter Count // This needs changes if L&G meters are to be included.
            var meterIds = (from s in RsDc.EnergyMeters_Mappings
                            where s.ID_Location == location
                            orderby s.ID_Type
                            select s).ToArray();

            // Calorific Value
            var calorificVal = (from s in RsDc.ConfigEfficiencies
                                where s.IdLocation == location
                                select s.GasCalorificValue).FirstOrDefault();


            // Set Values
            lblNoMeters.Text = "N/A";
            lblCalVal.Text = calorificVal.Value.ToString();
            lblAvgEff.Text = (Math.Round(EffTotal / EffCount, 2)).ToString(); // 2DP)
            lblMaxEff.Text = string.Format("{0:f2}", EffMax);
            lblMinEff.Text = string.Format("{0:f2}", EffMin);
            lblAvgElect.Text = (Math.Round(EnergykWhTotal / EnergykWhCount, 2)).ToString(); // 2DP)
            lblAvgGasEnergy.Text = (Math.Round(GaskWhTotal / GaskWhCount, 2)).ToString(); // 2DP
            lblAvgGasVol.Text = (Math.Round(GasVolTotal / GasVolCount, 2)).ToString(); // 2DP

        }    
    }
}