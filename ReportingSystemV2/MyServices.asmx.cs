using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Web.Configuration;
using System.Configuration;

namespace ReportingSystemV2
{
    /// <summary>
    /// Summary description for MyServices
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class MyServices : System.Web.Services.WebService
    {

        public class jQueryResult
        {
            public jQueryResult()
            {
                IsValid = false;
            }
            public bool IsValid { get; set; }
            public string Payload { get; set; }
        }

        public class MQTTServerSettings
        {
            public MQTTServerSettings()
            {
            }
            public string Server { get; set; }
            public string Port { get; set; }
            public string Username { get; set; }
            public string Password { get; set; }
            public bool useTLS { get; set; }
        }

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public string getGensetAssociatedDatalogger(string gensetSerial)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (gensetSerial != "")
                {
                    var query = (from s in RsDc.HL_Locations
                                 where s.GENSET_SN == gensetSerial
                                 select s.BLACKBOX_SN).FirstOrDefault().ToString();

                    return query;
                }
                else
                {
                    return "";
                }
            }
        }

        [WebMethod]
        public string availabilityCalc(int id, System.DateTime startdt, System.DateTime enddt, object hrs)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            if (hrs == null)
                return id.ToString() + ";N/A";
            if ((Convert.ToInt32(hrs) == 0))
                return id.ToString() + ";N/A";

            //Get the Exempts from the DB
            var exempts = from h in RsDc.ed_Exempts_GetById(id, startdt, enddt)
                          select h;

            //Accumulate all Exempt Downtimes
            int totalExempts = 0;
            foreach (var item in exempts)
            {
                if (Convert.ToBoolean(item.ISEXEMPT))
                {
                    totalExempts += item.TIMEDIFFERENCE;
                }
            }

            TimeSpan ex = new TimeSpan(0, totalExempts, 0);

            //Calculate Avalibility %
            double ret = ex.TotalHours + Convert.ToInt32(hrs);
            ret = ret / (enddt.AddDays(1) - startdt).TotalHours;

            //my mod
            if (ret > 1)
            {
                ret = 1;
            }

            return id.ToString() + ";" + (ret * 100).ToString("#.##") + "%";
        }

        [WebMethod]
        public jQueryResult DecryptPayload(string cipherPayloadBase64)
        {
            jQueryResult result = new jQueryResult();

            RijndaelCrypto rc = new RijndaelCrypto();

            if (cipherPayloadBase64 == null)
            {
                result.IsValid = false;
                result.Payload = "Nothing to decrypt!";
                return result;
            }
            else
            {
                try
                {
                    byte[] cipher = Convert.FromBase64String(cipherPayloadBase64);
                    result.Payload = rc.DecryptStringFromBytes(cipher, rc.GetKey());
                    result.IsValid = true;
                    return result;
                }
                catch (Exception ex)
                {
                    LogMe.LogSystemException(ex.Message);

                    result.Payload = "Decryption error occured!";
                    result.IsValid = false;
                    return result;
                }

            }
        }

        [WebMethod]
        public jQueryResult EncryptPayload(string plainText)
        {
            jQueryResult result = new jQueryResult();

            RijndaelCrypto rc = new RijndaelCrypto();

            if (plainText.Length == 0)
            {
                result.IsValid = false;
                result.Payload = "Nothing to encrypt!";
                return result;
            }
            else
            {
                byte[] encrypted = rc.EncryptStringToBytes(plainText, rc.GetKey(), true);
                result.Payload = Convert.ToBase64String(encrypted);
                result.IsValid = true;
                return result;
            }
        }

        [WebMethod]
        public MQTTServerSettings GetMQTTServerSettings()
        {
            MQTTServerSettings result = new MQTTServerSettings();

            try
            {
                Configuration config = WebConfigurationManager.OpenWebConfiguration("/");

                if (!HttpContext.Current.Request.IsSecureConnection)
                {
                    result.Port = config.AppSettings.Settings["Port"].Value; // Use unencrypted broker
                    result.useTLS = false;
                }
                else
                {
                    result.Port = "8433"; // Use SSL Broker
                    result.useTLS = true;
                }

                result.Server = config.AppSettings.Settings["Server"].Value;
                result.Username = config.AppSettings.Settings["Username"].Value;
                result.Password = config.AppSettings.Settings["Password"].Value;

                return result;
            }
            catch (Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                return result;
            }
        }

        [WebMethod]
        public jQueryResult getGensetSitename(string serial)
        {
            jQueryResult result = new jQueryResult();

            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                try
                {
                    var query = (from s in RsDc.HL_Locations
                                 where s.GENSET_SN == serial
                                 select s.SITENAME).FirstOrDefault().ToString();

                    if (query != "")
                    {
                        result.Payload = query;
                        result.IsValid = true;
                        return result;
                    }
                    else
                    {
                        result.Payload = "-1";
                        result.IsValid = false;
                        return result;
                    }
                }
                catch (Exception ex)
                {
                    result.Payload = "-1";
                    result.IsValid = false;
                    return result;
                }
            }
        }
    }
}
