using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace ReportingSystemV2.Models
{
    public class SiteContext : DbContext
    {
        public SiteContext() : base()
        {
        }
        public DbSet<Site> Sites { get; set; } 
    }
}