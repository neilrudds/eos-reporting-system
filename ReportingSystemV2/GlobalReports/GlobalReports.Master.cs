using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.GlobalReports
{
    public partial class GlobalReports : GlobalReportsBase
    {
        // Declare an event
        //[Category("Action")]
        //[Description("Fires when the report date is changed")]
        public event EventHandler globalReportDateChanged;

        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Attach to DateChanged Event on UserControl
            DateRangeSelect.dateChanged += new DateRangeSelect.dateChangedEventHandler(dtRgSel_dateChanged);

            if (Request.QueryString["Table"] != null)
            {
                TableName = Request.QueryString["Table"];
            }

            if (Request.QueryString["dtstart"] != null && Request.QueryString["dtend"] != null)
            {
                startDate = DateTime.ParseExact(Request.QueryString["dtstart"], "yyyy-MM-dd", null);
                endDate = DateTime.ParseExact(Request.QueryString["dtend"], "yyyy-MM-dd", null);
            }
        }

        // Called on a date change event
        protected void dtRgSel_dateChanged(object sender, DateChangedEventArgs e)
        {
            // Update the basepage & subnav
            startDate = e.startDate;
            endDate = e.endDate;

            // Raise event for content pages
            if (globalReportDateChanged != null)
                globalReportDateChanged(this, EventArgs.Empty);
        }
    }
}