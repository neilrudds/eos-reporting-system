using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class MQTTMonitor : System.Web.UI.Page
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var CHPTopics = (from s in RsDc.HL_Locations orderby s.GENSETNAME select new { s.GENSETNAME, s.GENSET_SN }).Distinct();
                var RTCUTopics = (from s in RsDc.HL_Locations orderby s.SITENAME select new { s.SITENAME, s.BLACKBOX_SN }).Distinct();

                // Add the CHPs
                foreach (var topic in CHPTopics)
                {
                    string text = "CHP/" + topic.GENSETNAME + "/#";
                    string value = "CHP/" + topic.GENSET_SN.ToUpper() + "/#";
                    ddlTopic.Items.Add(new ListItem(text, value, true));
                }

                // Add the RTCUs
                foreach (var rtcu in RTCUTopics)
                {
                    string text = "RTCU/" + rtcu.SITENAME + "/#";
                    string value = "RTCU/" + rtcu.BLACKBOX_SN + "/#";
                    ddlTopic.Items.Add(new ListItem(text, value, true));
                }

                // Add Defaults
                ddlTopic.Items.Insert(0, new ListItem("$SYS/#", "$SYS/#", true));
                ddlTopic.Items.Insert(1, new ListItem("$EdinaBridge/#", "EdinaBridge/#", true));
                //ddlTopic.Items.Insert(1, new ListItem("CHP/#", "CHP/#", true)); // Very slow, too many messages
                ddlTopic.Items.Insert(2, new ListItem("RTCU/#", "RTCU/#", true));
            }
        }
    }
}