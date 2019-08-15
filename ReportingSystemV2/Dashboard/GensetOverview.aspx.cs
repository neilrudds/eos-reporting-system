using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ReportingSystemV2.Models;
using Microsoft.AspNet.Identity;

namespace ReportingSystemV2.Dashboard
{
    public partial class Overview : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
        UserSites us = new UserSites();

        protected void Page_Load(object sender, EventArgs e)
        {
            UserSites userSites = new UserSites();

            var query = (from h in RsDc.HL_Locations
                        where h.GensetEnabled == true
                        orderby h.GENSETNAME
                        select new
                        {
                            Id = h.ID,
                            Serial = h.GENSET_SN,
                            Generator = h.GENSETNAME,
                            Communications = 0,
                            RPM = 0,
                            Status = 0
                        }).Where(t => userSites.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.Id));

            gridOverview.DataSource = query.ToList();
            gridOverview.DataBind();

            //CSS Header Sytle
            gridOverview.UseAccessibleHeader = true;
            gridOverview.HeaderRow.TableSection = TableRowSection.TableHeader;
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

        public IQueryable<ReportingSystemV2.HL_Location> GetSites()
        {
            var query = (from c in RsDc.GetTable<HL_Location>()
                         orderby c.SITENAME
                         group c by c.SITENAME into uniqueSites
                         select uniqueSites.FirstOrDefault()).Where(t => us.GetUserSites_Int(Page.User.Identity.GetUserId()).Contains(t.ID));
            return query;
        }
    }
}