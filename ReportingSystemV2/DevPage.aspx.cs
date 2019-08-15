using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace ReportingSystemV2
{
    public partial class DevPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                createAccordianUsingRepeater();
            }

        }

        public void createAccordianUsingRepeater()
        {
            repAccordian.DataSource = createDataTable();
            repAccordian.DataBind();
        }

        public DataTable createDataTable()
        {
            DataTable dt = new DataTable();
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ID";
            dc.DataType = typeof(string);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Name";
            dc.DataType = typeof(string);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Description";
            dc.DataType = typeof(string);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Email";
            dc.DataType = typeof(string);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Phone";
            dc.DataType = typeof(string);

            dt.Columns.Add(dc);

            dt.Rows.Add(new object[] {"1", "AC Shropshire", "Hello my name is Max and I am software engineer.", "Demo@Gmail.com", "My Phone is 123456789" });
            dt.Rows.Add(new object[] {"2", "Afan", "Hello my name is Albert and I am software engineer.", "Demo@Gmail.com", "My Phone is 123456789" });
            dt.Rows.Add(new object[] {"3", "Poplars", "Hello my name is Destin and I am software engineer.", "Demo@Gmail.com", "My Phone is 123456789" });
            dt.Rows.Add(new object[] {"4", "Mater Hospital", "Hello my name is Jessie and I am software engineer.", "Demo@Gmail.com", "My Phone is 123456789" });
            dt.Rows.Add(new object[] {"5", "Hunniford", "Hello my name is Joe and I am software engineer.", "Demo@Gmail.com", "My Phone is 123456789" });


            return dt;

        }
    }
}