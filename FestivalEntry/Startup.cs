using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(FestivalEntry.Startup))]
namespace FestivalEntry
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
