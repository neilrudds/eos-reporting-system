using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace ReportingSystemV2.Dashboard
{
    public partial class GensetMap : System.Web.UI.Page
    {

        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        public int location;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
                {
                    if (Request.QueryString["id"] != null)
                    {
                        DataTable dt = this.GetLocationData(int.Parse(Request.QueryString["id"]));

                        if (dt.Rows.Count == 0)
                        {
                            //mapContainer.InnerHtml = "<div id='blocker'><div>Map unavailable...</div></div>";
                            mapContainer.Attributes.Remove("class");
                            mapContainer.InnerHtml = "<div class='middle-box text-center'><div class='fa fa-info fa-5x fa-align-center'></div><h3 class='font-bold'>Nothing to see here.</h3><div class='error-desc' style='white-space:normal'>This generators location is currently unavailable. Please try again later.</div></div>";
                            //mapContainer.Attributes.Add("class", "fill blocker");
                        }
                        else
                        {
                            rptMarkers.DataSource = dt;
                            rptMarkers.DataBind();
                        }
                        
                    }
                }
        }

        private DataTable FormatTable()
        {
            DataTable dt = new DataTable();

            dt.Columns.Add(new DataColumn()
            {
                DataType = System.Type.GetType("System.String"),//or other type
                ColumnName = "Name"      //or other column name
            });

            dt.Columns.Add(new DataColumn()
            {
                DataType = System.Type.GetType("System.String"),//or other type
                ColumnName = "Latitude"      //or other column name
            });

            dt.Columns.Add(new DataColumn()
            {
                DataType = System.Type.GetType("System.String"),//or other type
                ColumnName = "Longitude"      //or other column name
            });

            dt.Columns.Add(new DataColumn()
            {
                DataType = System.Type.GetType("System.String"),//or other type
                ColumnName = "Description"      //or other column name
            });

            return dt;
        }

        private DataTable GetLocationData(int id)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
            DataTable dt = FormatTable();

            var location = from loc in RsDc.GensetLocations
                            where loc.ID_Location == id
                            select new {
                                Name = (from n in RsDc.HL_Locations where n.ID == id select n.GENSETNAME).FirstOrDefault().ToString(),
                                Latitide = loc.Latitude,
                                Longitude = loc.Longitude,
                                Description = loc.Description
                            };

            if (location != null)
            {
                foreach (var item in location)
                {
                    var row = dt.NewRow();
                    row["Name"] = item.Name;
                    row["Latitude"] = item.Latitide;
                    row["Longitude"] = item.Longitude;
                    row["Description"] = item.Description;
                    dt.Rows.Add(row);
                }
                return dt;
            }
            return dt; // Empty DT
        }
    }

    

}