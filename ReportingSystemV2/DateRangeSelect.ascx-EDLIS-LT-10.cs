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

        public DateTime startDate = DateTime.Now.AddDays(-1);
        public DateTime endDate = DateTime.Now;

        protected void Page_Load(object sender, EventArgs e)
        {
            
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
             string[] dates = GetDateRange();

             if (dates[0] != "" && dates[1] != "")
             {
                 //Trigger Event
                 OnDateChanged(new DateChangedEventArgs(DateTime.Parse(dates[0]), DateTime.Parse(dates[1])));
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

    }
}

//Event Args Class
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