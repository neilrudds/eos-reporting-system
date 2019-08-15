using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Text.RegularExpressions;
using System.Drawing;
using System.Web.Services;
using System.Web.Security;

namespace ReportingSystemV2.CPanel
{
    public partial class UnitManagement : System.Web.UI.Page
    {
        CustomDataContext db = new CustomDataContext();

        protected void Page_Load(object sender, EventArgs e)
        {
           
        }


        public IQueryable<ReportingSystemV2.ed_Blackbox_GetResult> GetDataloggers()
        {
            var query = db.ed_Blackbox_Get();

            return query.AsQueryable();

        }

        public int getSelectedPort(string serial)
        {
            var query = (from u in db.Blackboxes
                         where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                if (query.CFG_PortNo == 0)
                {
                    return 0;
                }
                else if (query.CFG_PortNo == 2)
                {
                    return 2;
                }
                else
                {
                    return -1;
                }
            }
            else
            {
                return -1;
            }

        }

        // Find the current selected baud rate
        public int getSelectedBaud(string serial)
        {
            var query = (from u in db.Blackboxes
                         where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                return Convert.ToInt32(query.CFG_BaudRate);
            }
            else if (query.CFG_BaudRate == null)
            {
                return 4;
            }
            else
            {
                return 4;
            }

        }

        // Find the ethernet config
        public int getEthernetCfg(string serial)
        {
            var query = (from u in db.Blackboxes
                         where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                if (query.CFG_EthernetModuleEn == true)
                {
                    return 1;
                }
                else if (query.CFG_EthernetModuleEn == null)
                {
                    return 0;
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                return 0;
            }

        }

        // Find the ethernet config
        public string getUnitStatus(string serial)
        {
            var query = (from u in db.Blackboxes
                         where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                if (query.CFG_State == null)
                {
                    return "Configuration missing";
                }
                else if (query.CFG_State == 1)
                {
                    return "Initial configuration pending";
                }
                else if (query.CFG_State == 2)
                {
                    return "Configuration update pending";
                }
                else if (query.CFG_State == 3)
                {
                    return "Online";
                }
                else
                {
                    return "Configuration missing";
                }
            }
            else
            {
                return "Configuration missing";
            }

        }

        public string getUnitControllers(string serial)
        {

            string tmp = "";
            string[] names = new string[8];

            var query = (from u in db.Blackboxes
                         where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                if (query.CFG_GensetName01 == null)
                {
                    return "Undefined";
                }
                else
                {
                    names[0] = query.CFG_GensetName01;
                    names[1] = query.CFG_GensetName02;
                    names[2] = query.CFG_GensetName03;
                    names[3] = query.CFG_GensetName04;
                    names[4] = query.CFG_GensetName05;
                    names[5] = query.CFG_GensetName06;
                    names[6] = query.CFG_GensetName07;
                    names[7] = query.CFG_GensetName08;

                    for (int i = 0; i < query.CFG_ConnectedControllersCount; i++)
                    {
                        if (i != query.CFG_ConnectedControllersCount - 1)
                        {
                            tmp = tmp + names[i] + ", ";
                        }
                        else
                        {
                            tmp = tmp + names[i];
                        }
                       
                    }

                    return tmp;
                }
            }
            else
            {
                return "Undefined";
            }
        }

        // Get Meter MB Address
        public int getMeterAddr(string serial, int MetNum)
        {
            var query = (from u in db.Blackboxes
                         where u.BB_SerialNo == serial
                         select u).FirstOrDefault();

            if (query != null)
            {
                switch(MetNum)
                {
                    // Heat Meters
                    case 1:
                        if (query.CFG_HMAddr01 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr01);
                        }
                        else
                        {
                            return 0;
                        }
                    case 2:
                        if (query.CFG_HMAddr02 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr02);
                        }
                        else
                        {
                            return 0;
                        }
                    case 3:
                        if (query.CFG_HMAddr03 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr03);
                        }
                        else
                        {
                            return 0;
                        }
                    case 4:
                        if (query.CFG_HMAddr04 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr04);
                        }
                        else
                        {
                            return 0;
                        }
                    case 5:
                        if (query.CFG_HMAddr05 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr05);
                        }
                        else
                        {
                            return 0;
                        }
                    case 6:
                        if (query.CFG_HMAddr06 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr06);
                        }
                        else
                        {
                            return 0;
                        }
                    case 7:
                        if (query.CFG_HMAddr07 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr07);
                        }
                        else
                        {
                            return 0;
                        }
                    case 8:
                        if (query.CFG_HMAddr08 != null)
                        {
                            return Convert.ToInt32(query.CFG_HMAddr08);
                        }
                        else
                        {
                            return 0;
                        }
                    // Steam Meters
                    case 9:
                        if (query.CFG_SMAddr01 != null)
                        {
                            return Convert.ToInt32(query.CFG_SMAddr01);
                        }
                        else
                        {
                            return 0;
                        }
                    case 10:
                        if (query.CFG_SMAddr02 != null)
                        {
                            return Convert.ToInt32(query.CFG_SMAddr02);
                        }
                        else
                        {
                            return 0;
                        }
                    case 11:
                        if (query.CFG_SMAddr03 != null)
                        {
                            return Convert.ToInt32(query.CFG_SMAddr03);
                        }
                        else
                        {
                            return 0;
                        }
                    case 12:
                        if (query.CFG_SMAddr04 != null)
                        {
                            return Convert.ToInt32(query.CFG_SMAddr04);
                        }
                        else
                        {
                            return 0;
                        }
                    // Gas Meters
                    case 13:
                        if (query.CFG_GMAddr01 != null)
                        {
                            return Convert.ToInt32(query.CFG_GMAddr01);
                        }
                        else
                        {
                            return 0;
                        }
                    case 14:
                        if (query.CFG_GMAddr02 != null)
                        {
                            return Convert.ToInt32(query.CFG_GMAddr02);
                        }
                        else
                        {
                            return 0;
                        }
                    default:
                        return 0;
                }
            }
            else
            {
                return 0;
            }
        }

        [WebMethod]
        public static String TestMethod(string name, string pk, string value)
        {
            //access params here
            return "Resp:" + name + "/" + pk + "/" + value;
        }

        
        protected void lstDataloggers_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            // Add values to the meter dropdown lists
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                DropDownList[] ddl = new DropDownList[15];

                // Assign controls
                for (int i = 1; i < 9; i++)
                {
                    ddl[i] = (DropDownList)e.Item.FindControl("ddlHM_0" + i.ToString());
                }

                // Steam
                for (int i = 9; i < 13; i++)
                {
                    ddl[i] = (DropDownList)e.Item.FindControl("ddlSM_0" + (i - 8).ToString());
                }

                for (int i = 13; i < 15; i++)
                {
                    ddl[i] = (DropDownList)e.Item.FindControl("ddlGM_0" + (i - 12).ToString());
                }

                // Gas
                
                // Apply to all
                for (int i = 1; i < 15; i++)
                {
                    List<ListItem> items = new List<ListItem>();

                    items.Add(new ListItem { Value = "0", Text = "-" });

                    for (int j = 1; j < 33; j++)
                    {
                        items.Add(new ListItem
                        {
                            Value = j.ToString(),
                            Text = j.ToString()
                        });
                    }

                    ddl[i].Items.AddRange(items.ToArray());
                    ddl[i].DataBind();
                }
            }
        }
    }
}