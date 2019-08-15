using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace ReportingSystemV2.Models
{
    public class ReportSummary
    {

        [Display(Name = "Generator")]
        public string Generator { get; set; }

        [Display(Name = "Run Hours")]
        public string Runhours { get; set; }
    }
}