using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.ModelBinding;
using ReportingSystemV2.Models;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2.Dashboard
{
    public partial class Dashboard : System.Web.UI.MasterPage
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        UserSites us = new UserSites();
        public int IdLocation;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    IdLocation = int.Parse(Request.QueryString["id"]);

                    var gensetName = (from at in RsDc.HL_Locations where at.ID == IdLocation select at).Select(a => a.GENSETNAME).Single();

                    lbl_subnavBrand.InnerHtml = gensetName;

                    Page.DataBind();

                    PopulateDropDownMenu();
                }
            }
        }

        protected void PopulateDropDownMenu()
        {

            // Comap Always Included
            string liText = "";

            liText = liText + "<li role=\"presentation\">";
            liText = liText + "<a role=\"menuitem\" tabindex=\"-1\" href=\"GensetHistory.aspx?id=" + Request.QueryString["id"] + "&" + "type=-1" +"\">";
            liText = liText + "ComAp";
            liText = liText + "</a></li>";

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                int IdLocation = int.Parse(Request.QueryString["id"]);

                var SerMeters = (from m in RsDc.EnergyMeters_Mapping_Serials
                              where m.ID_Location == IdLocation
                              join type in RsDc.EnergyMeters_Types on m.ID_Type equals type.id
                              select new { metertype = type.Meter_Type, ID_Type = type.id });

                // Add a seperator
                if (SerMeters.Count() > 0)
                {
                    liText = liText + "<li role=\"separator\" class=\"divider\"></li>";
                }

                foreach (var SerMeter in SerMeters)
                {                
                    liText = liText + "<li role=\"presentation\">";
                    liText = liText + "<a role=\"menuitem\" tabindex=\"-1\" href=\"GensetHistory.aspx?id=" + Request.QueryString["id"] + "&" + "type=" + SerMeter.ID_Type + "\">";
                    liText = liText + SerMeter.metertype;
                    liText = liText + "</a></li>";
                }

                var MbMeters = (from th in RsDc.EnergyMeters_Mappings
                               where th.ID_Location == IdLocation && th.Modbus_Addr != null && th.Modbus_Addr != -1
                               join type in RsDc.EnergyMeters_Types on th.ID_Type equals type.id
                               select new { metertype = type.Meter_Type, ID_Type = type.id });

                // Add a seperator
                if (MbMeters.Count() > 0)
                {
                    liText = liText + "<li role=\"separator\" class=\"divider\"></li>";
                }

                foreach (var MbMeter in MbMeters)
                {                
                    liText = liText + "<li role=\"presentation\">";
                    liText = liText + "<a role=\"menuitem\" tabindex=\"-1\" href=\"GensetHistory.aspx?id=" + Request.QueryString["id"] + "&" + "type=" + MbMeter.ID_Type + "\">";
                    liText = liText + MbMeter.metertype;
                    liText = liText + "</a></li>";
                }

                var GasMeters = (from gs in RsDc.GasMeters_Mappings
                                 where gs.ID_Location == IdLocation && gs.Modbus_Addr != null && gs.Modbus_Addr != -1
                                 join type in RsDc.EnergyMeters_Types on gs.ID_Type equals type.id
                                 select new { metertype = type.Meter_Type, ID_Type = type.id });

                // Add a seperator
                if (GasMeters.Count() > 0)
                {
                    liText = liText + "<li role=\"separator\" class=\"divider\"></li>";
                }

                foreach (var GasMeter in GasMeters)
                {
                    liText = liText + "<li role=\"presentation\">";
                    liText = liText + "<a role=\"menuitem\" tabindex=\"-1\" href=\"GensetHistory.aspx?id=" + Request.QueryString["id"] + "&" + "type=" + GasMeter.ID_Type + "\">";
                    liText = liText + GasMeter.metertype;
                    liText = liText + "</a></li>";
                }
            }

            litDropDown.Text = litDropDown.Text + liText;
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
    }
}