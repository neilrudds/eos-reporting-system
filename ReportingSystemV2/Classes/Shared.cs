using ReportingSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.ComponentModel.DataAnnotations;

namespace ReportingSystemV2
{
    public class Shared
    {
        // Create HTML for the bootstrap alert
        public static string createAlertMessage(string CssClass, string Topic, string Message)
        {
            System.Text.StringBuilder errMsg = new System.Text.StringBuilder();

            errMsg.Append("<div class='error-notice'>");
            errMsg.Append(string.Format("<div class='edina-error {0}'>", CssClass));
            errMsg.Append(string.Format("<strong>{0} </strong>{1}", Topic, Message));
            errMsg.Append("</div></div>");

            return errMsg.ToString();
        }

        private static int[] StringToIntArray(string myNumbers)
        {
            List<int> myIntegers = new List<int>();
            Array.ForEach(myNumbers.Split(",".ToCharArray()), s =>
            {
                int currentInt;
                if (Int32.TryParse(s, out currentInt))
                    myIntegers.Add(currentInt);
            });
            return myIntegers.ToArray();
        }

        // Get Users Dashboard Charts
        public static int[] getUsersDashboardCharts(string UserId)
        {
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindById(UserId);

            int[] temp = new int[4];

            if (u.DashboardChartsArray == null)
            {
                // Set Default Charts
                temp[0] = 1;
                temp[1] = 2;
                temp[2] = 3;
                temp[3] = 4;

                return temp;
            }
            else
            {
                // Split the array string
                StringToIntArray(u.DashboardChartsArray).CopyTo(temp, 0);

                // Check everything is popuated, if not fill with charts not already used.
                int nextNo = 1;
                for (int i = 0; i < 4; i++)
                {
                   if (temp[i] == 0)
                   {
                       while (temp[i] == 0)
                       {
                           int idx = Array.IndexOf<int>(temp, nextNo);
                           if (idx < 0)
                           {
                               temp[i] = nextNo;
                           }
                           else
                           {
                               nextNo++;
                           }
                       }
                   }
                }

                return temp;
            }
        }

        public static int[] getUsersDashboardChartsSetting(string UserId)
        {
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindById(UserId);

            int[] temp = new int[4];

            if (u.DashboardChartsArray != null)
            {
                // Split the array string
                StringToIntArray(u.DashboardChartsArray).CopyTo(temp, 0);
                return temp;
            }
            else
            {
                return temp;
            }
        }

        public static bool setUsersDashboardCharts(string[] UserCharts, string UserId)
        {
            UserManager manager = new UserManager();
            ApplicationUser u = manager.FindById(UserId);

            var result = string.Join(",", UserCharts);
            if (result != "")
            {
                try
                {
                    u.DashboardChartsArray = result;
                    manager.Update(u);
                    return true;
                }
                catch
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }

        // Check if the users associsted roles can access a specific function
        public static bool canUserAccessFunction(string FunctionName)
        {
            UserManager manager = new UserManager();
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();
            var rm = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));

            var userId = System.Web.HttpContext.Current.User.Identity.GetUserId();
            var assignedRoles = manager.GetRoles(userId);

            var roleIdsList = new List<string> { };
            foreach (var role in assignedRoles)
            {
                var r = rm.FindByName(role.ToString());
                roleIdsList.Add(r.Id);
            }  


            // Loop each of the users assigned roles
            foreach (var role in roleIdsList)
            {
                // Get the roles function access
                var roleFunctions = from s in RsDc.IdentityRoleFunctionAccesses
                                    where s.RoleId == role
                                    select s;
                
                // Loop the roles functions
                foreach (var funct in roleFunctions)
                {
                    string FunctName = (from s in RsDc.IdentityRoleFunctions
                                       where s.Id == funct.FunctionId
                                       select s.FunctionName).SingleOrDefault().ToString();

                    // If one matched then return to allow user
                    if (FunctName.Equals(FunctionName, StringComparison.InvariantCultureIgnoreCase))
                    {
                        return true;
                    }
                }
            }

            return false;

        }
    }
}