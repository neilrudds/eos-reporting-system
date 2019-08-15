using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ReportingSystemV2.Startup))]
namespace ReportingSystemV2
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
