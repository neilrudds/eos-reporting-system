using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class SQL_Config : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlConnectionStringBuilder builder = new System.Data.SqlClient.SqlConnectionStringBuilder();
            builder.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ReportingSystemConnectionString"].ConnectionString.ToString();

            tbServer.Text = builder.DataSource.ToString();
            tbDB.Text = builder.InitialCatalog.ToString();
            tbUser.Text = builder.UserID.ToString();
            tbPassword.Text = builder.Password.ToString();
        }

        protected void SubmitBtn_Click(object sender, EventArgs e)
        {
            var config = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration(Request.ApplicationPath);
            System.Data.SqlClient.SqlConnectionStringBuilder builder = new System.Data.SqlClient.SqlConnectionStringBuilder();

            builder.DataSource = tbServer.Text;
            builder.InitialCatalog = tbDB.Text;
            builder.UserID = tbUser.Text;
            builder.Password = tbPassword.Text;

            //alert types (alert-success = green / alert-info = blue / alert-warning = yellow / alert-danger = red)
            Page.ClientScript.RegisterStartupScript(this.GetType(), "CallInfoBar", "bootstrap_alert.warning('alert-danger', 'Warning!', 'Unable to save the web.config file..');", true);


            //System.Configuration.ConfigurationManager.ConnectionStrings["ReportingSystemConnectionString"].ConnectionString = builder.ToString();
            //config.Save();

        }
    }
}