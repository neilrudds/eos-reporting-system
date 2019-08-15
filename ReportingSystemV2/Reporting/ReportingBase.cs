using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace ReportingSystemV2.Reporting
{
    public class ReportingBase : System.Web.UI.MasterPage
    {
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
        public DateTime startDate
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
        public DateTime endDate
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
    }
}