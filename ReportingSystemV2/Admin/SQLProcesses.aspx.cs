using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class SQLProcesses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProcesses();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (SQLProcessesGrid.Rows.Count > 0)
            {
                //CSS Header Sytle
                SQLProcessesGrid.UseAccessibleHeader = true;
                SQLProcessesGrid.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void BindProcesses()
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var query = (from s in RsDc.ed_DB_GetRunningProcesses()
                             select s);

                SQLProcessesGrid.DataSource = query;
                SQLProcessesGrid.DataBind();

                lblLastRefresh.Text = DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss");
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            BindProcesses();
        }

    }
}