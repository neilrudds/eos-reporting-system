using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.ModelBinding;
using ReportingSystemV2.Models;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2.Reporting
{
    public partial class Reporting : ReportingBase
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        UserSites us = new UserSites();

        // Declare an event
        //[Category("Action")]
        //[Description("Fires when the report date is changed")]
        public event EventHandler reportDateChanged;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Attach to DateChanged Event on UserControl
            DateRangeSelect.dateChanged += new DateRangeSelect.dateChangedEventHandler(dtRgSel_dateChanged);

            if (Request.QueryString["id"] != null)
            {
                IdLocation = int.Parse(Request.QueryString["id"]);

                var genset = (from at in RsDc.HL_Locations where at.ID == IdLocation select at).FirstOrDefault();

                SubNav_Brand.InnerHtml = genset.GENSETNAME;
                lblsubHeader.InnerText = "serial." + genset.GENSET_SN;
            }

            if (!Page.IsPostBack)
            {
                if (Request.QueryString["dtstart"] != null && Request.QueryString["dtend"] != null)
                {
                    startDate = DateTime.ParseExact(Request.QueryString["dtstart"], "yyyy-MM-dd", null);
                    endDate = DateTime.ParseExact(Request.QueryString["dtend"], "yyyy-MM-dd", null);
                }

                if (!System.IO.Path.GetFileName(Request.Path).Contains("ReportingOverview"))
                {
                    updSubNav.Visible = true;
                }
                else
                {
                    updSubNav.Visible = false;
                }
            }

            updSubNav.DataBind();
            //Page.DataBind();
        }

        // Called on a date change event
        protected void dtRgSel_dateChanged(object sender, DateChangedEventArgs e)
        {
            // Update the basepage & subnav
            startDate = e.startDate;
            endDate = e.endDate;

            updSubNav.DataBind();

            // Raise event for content pages
            if (reportDateChanged != null)
                reportDateChanged(this, e);
        }

        // List of Users Sites
        public IQueryable<ReportingSystemV2.HL_Location> GetSites()
        {
            var query = (from c in RsDc.GetTable<HL_Location>()
                         orderby c.SITENAME
                         group c by c.SITENAME into uniqueSites
                         select uniqueSites.FirstOrDefault()).Where(t => us.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));
            return query;
        }

        // List of User Generators
        public IQueryable<HL_Location> GetSiteGenerators([Control]string SiteName)
        {
            var query = (from c in RsDc.GetTable<HL_Location>()
                         where c.SITENAME == SiteName
                         orderby c.GENSETNAME
                         select c).Where(t => us.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));
            return query;
        }

        // List of Users Generators
        public IQueryable<ReportingSystemV2.HL_Location> GetGenerators()
        {
            var query = (from c in RsDc.GetTable<HL_Location>()
                         orderby c.GENSETNAME
                         select c into uniqueGensets
                         select uniqueGensets).Where(t => us.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));

            return query;
        }

        // Check enabled report options
        public bool IsEfficencyReportsEnabled()
        {
            try
            {
                var ReportConfig = (from cfg in RsDc.ConfigReports
                                    where cfg.IdLocation == IdLocation
                                    select cfg).FirstOrDefault();

                if (ReportConfig.ShowEfficiency == true)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        public bool IsStartupTimesEnabled()
        {
            try
            {
                var ReportConfig = (from cfg in RsDc.ConfigReports
                                    where cfg.IdLocation == IdLocation
                                    select cfg).FirstOrDefault();

                if (ReportConfig.ShowUptime == true)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        // Update for new availability menu
        public bool IsAvailabilityEnabled()
        {
            try
            {
                var ReportConfig = (from cfg in RsDc.ConfigReports
                                    where cfg.IdLocation == IdLocation
                                    select cfg).FirstOrDefault();

                if (ReportConfig.AvailabilityBasedOnUnitUnavailableFlag == true)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}