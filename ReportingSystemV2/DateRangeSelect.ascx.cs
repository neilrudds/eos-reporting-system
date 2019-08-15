using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2
{
    public partial class DateRangeSelect : System.Web.UI.UserControl
    {
        // Declare a delegate
        public delegate void dateChangedEventHandler(object sender, DateChangedEventArgs e);

        // Declare an event
        //[Category("Action")]
        //[Description("Fires when the value is changed")]
        public event dateChangedEventHandler dateChanged;

        //public DateTime startDate = DateTime.Now.AddDays(-1);
        //public DateTime endDate = DateTime.Now.AddDays(-1);

        [PersistenceMode(PersistenceMode.Attribute)]
        public DateTime StartDate
        {
            get
            {
                if (ViewState["StartDate"] == null)
                    ViewState["StartDate"] = DateTime.Now.AddDays(-1);

                return (DateTime)ViewState["StartDate"];
            }
            set
            {
                ViewState["StartDate"] = value;
            }
        }

        [PersistenceMode(PersistenceMode.Attribute)]
        public DateTime EndDate
        {
            get
            {
                if (ViewState["EndDate"] == null)
                    ViewState["EndDate"] = DateTime.Now.AddDays(-1);

                return (DateTime)ViewState["EndDate"];
            }
            set
            {
                ViewState["EndDate"] = value;
            }
        }

        protected virtual void OnDateChanged(DateChangedEventArgs e)
        {
            dateChangedEventHandler handler = dateChanged;
            // Raise the event
            if (handler != null)
                handler(this, e);
        }

        protected void UpdatePanelDateChanged_Load(object sender, EventArgs e)
        {
            if (Request["__EVENTTARGET"] == UpdatePanelDateChanged.ClientID)
            {

                string[] dates = GetDateRange();

                if (dates[0] != "" && dates[1] != "") // Start & End
                {
                    //Trigger Event
                    OnDateChanged(new DateChangedEventArgs(DateTime.Parse(dates[0]), DateTime.Parse(dates[1])));

                    StartDate = DateTime.Parse(dates[0]);
                    EndDate = DateTime.Parse(dates[1]);
                } 
                else if (dates[0] != "" && dates[1] == "") // Start only
                {
                    //Trigger Event
                    OnDateChanged(new DateChangedEventArgs(DateTime.Parse(dates[0]), DateTime.Parse("1980-1-1 00:00:00")));

                    StartDate = DateTime.Parse(dates[0]);
                    EndDate = DateTime.Parse("1980-1-1 00:00:00");
                }
            }
        }

        protected string[] GetDateRange()
        {

            string[] dates = new string[] { "", "" };

            //Start Date
            if (startDatePicker.Value != "")
            {
                dates[0] = Convert.ToDateTime(startDatePicker.Value).ToString("yyyy-MM-dd");
            }

            //End Date
            if (endDatePicker.Value != "")
            {
                dates[1] = Convert.ToDateTime(endDatePicker.Value).ToString("yyyy-MM-dd");
            }

            return dates;
        }

        public void OverideInitialStartValues(DateTime startDate, DateTime endDate)
        {
            // Set the dates
            StartDate = startDate;
            EndDate = endDate;

            // Update the clients daterange values if not for the previous day
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$(document).ready(function () {");
            sb.Append("$('#reportrange').data('daterangepicker').setStartDate(moment('" + startDate.ToString("yyyy-MM-dd") + "'));");
            sb.Append("$('#reportrange').data('daterangepicker').setEndDate(moment('" + endDate.ToString("yyyy-MM-dd") + "'));");

            if (startDate.Date == endDate.Date)
            {
                sb.Append("$('#reportrange span').html(moment('" + startDate.ToString("yyyy-MM-dd") + "').format('D MMMM, YYYY'));");
            }
            else
            {
                sb.Append("$('#reportrange span').html(moment('" + startDate.ToString("yyyy-MM-dd") + "').format('D MMMM, YYYY') + ' - ' + moment('" + (endDate.ToString("yyyy-MM-dd") + "').format('D MMMM, YYYY'));"));
            }

            sb.Append("});");
            sb.Append(@"</script>");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Guid.NewGuid().ToString()", sb.ToString(), false);
        }

    }
}

// Event Args Class
public class DateChangedEventArgs : EventArgs
{
    public DateTime startDate { get; set; }
    public DateTime endDate { get; set; }

    public DateChangedEventArgs(DateTime startDT, DateTime endDT)
    {
        startDate = startDT;
        endDate = endDT;
    }
}