using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ReportingSystemV2.Admin
{
    public partial class MQTT_Config : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Configuration config = WebConfigurationManager.OpenWebConfiguration("/");
                    tbServer.Text = config.AppSettings.Settings["Server"].Value;
                    tbPort.Text = config.AppSettings.Settings["Port"].Value;
                    tbEncryptionKey.Text = config.AppSettings.Settings["Key"].Value;
                    tbUser.Text = config.AppSettings.Settings["Username"].Value;
                    tbPassword.Text = config.AppSettings.Settings["Password"].Value;
                }
                catch (Exception ex)
                {
                    LogMe.LogSystemException(ex.Message);
                    Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('danger', 'Error!', 'The requested settings are missing from the web.config file..');", true);
                }
            }            
        }

        protected void SubmitBtn_Click(object sender, EventArgs e)
        {
            try
            {
                AddOrUpdateAppSettings("Server", tbServer.Text);
                AddOrUpdateAppSettings("Port", tbPort.Text);
                AddOrUpdateAppSettings("Key", tbEncryptionKey.Text);
                AddOrUpdateAppSettings("Username", tbUser.Text);
                AddOrUpdateAppSettings("Password", tbPassword.Text);
                LogMe.LogUserMessage(string.Format("Web.Config settings updated. Server:{0}, Port:{1}, Encryption Key:{2} Username:{3}, Password:{4}", tbServer.Text, tbPort.Text, "********", tbUser.Text, "********"));
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('success', 'Success!', 'The settings have been saved to the web.config file..');", true);
            }
            catch (Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                Page.ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), "bootstrap_alert.warning('danger', 'Error!', 'The settings could not be updated in the web.config file..');", true);
            }
        }

        public static void AddOrUpdateAppSettings(string key, string value)
        {
            Configuration config = WebConfigurationManager.OpenWebConfiguration("/");
            var settings = config.AppSettings.Settings;
            if (settings[key] == null)
            {
                settings.Add(key, value);
            }
            else
            {
                settings[key].Value = value;
            }
            config.Save(ConfigurationSaveMode.Modified);
            ConfigurationManager.RefreshSection(config.AppSettings.SectionInformation.Name);
        }
    }
}