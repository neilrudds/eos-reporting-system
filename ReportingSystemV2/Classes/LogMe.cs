using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using ReportingSystemV2.Models;
using System.IO;


namespace ReportingSystemV2
{
    public class LogMe
    {
        public static void LogUserMessage(string msg, string username = "")
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                string user = HttpContext.Current.User.Identity.Name;
                if (user == "")
                {
                    user = username;
                }

                LogUser LogU = new LogUser
                {
                    Time_Stamp = DateTime.Now,
                    UserName = user,
                    UserAction = msg
                };
                RsDc.LogUsers.InsertOnSubmit(LogU);

                try
                {
                    RsDc.SubmitChanges();
                }
                catch (Exception e)
                {
                    LogSystemException(e.ToString());
                }
            }
        }

        public static void LogSystemException(string msg)
        {
            LogSystemMessage("Exception", msg);
        }

        public static void LogSystemError(string msg)
        {
            LogSystemMessage("Error", msg);
        }

        protected static void LogSystemMessage(string category, string msg)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                string sPath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;

                LogSystem LogS = new LogSystem
                {
                    Time_Stamp = DateTime.Now,
                    UserName = HttpContext.Current.User.Identity.Name,
                    Category = category,
                    Action = msg,
                    ActionPage = sPath.Substring(sPath.LastIndexOf("/"))
                };
                
                RsDc.LogSystems.InsertOnSubmit(LogS);

                try
                {
                    RsDc.SubmitChanges();
                }
                catch
                {
                    // Not much more we can do to log....
                }
            }
        }
    }
}