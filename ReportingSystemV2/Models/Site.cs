using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace ReportingSystemV2.Models
{
    public class Site
    {
        [ScaffoldColumn(false)]
        public int ID { get; set; }

        [Display(Name = "Site Name")]
        public string SITENAME { get; set; }

        [Display(Name = "Generator Name")]
        public string GENSETNAME { get; set; }
    }

    public partial class UserSites
    {
        public List<string> GetUserSites_String(string UserId)
        {
            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            // Get the current logged in User and look up the user in ASP.NET Identity
            var currentUser = manager.FindById(UserId);

            // Get the site access array to list for query
            return currentUser.SiteAccessArray.Split(',').ToList();
        }

        public List<int> GetUserSites_Int(string UserId)
        {
            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));

            // Get the current logged in User and look up the user in ASP.NET Identity
            var currentUser = manager.FindById(UserId);

            // Get the site access array to list for query
            return currentUser.SiteAccessArray.Split(',').Select(Int32.Parse).ToList();
        }
    }
}