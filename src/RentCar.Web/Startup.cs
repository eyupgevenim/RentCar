using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using RentCar.Web.Extensions;

namespace RentCar.Web
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);

            //my services
            services.AddDatabaseServices();

            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
            .AddCookie(options => {
                options.LoginPath = "/Account/Login/";
                options.LogoutPath = "/Account/Logout/";
            });

        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler($"/Booking/Error");
            }

            app.UseStaticFiles();

            app.UseAuthentication();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Booking}/{action=Index}/{id?}");
            });
        }
    }

    public static class InitializeData
    {
        public static void CreateTestUsers(HttpContext httpContext)
        {
            var signInManager = httpContext.RequestServices.GetService<Core.Interfaces.ISignInManager>();
            var userDb = httpContext.RequestServices.GetService<Core.Interfaces.IUserDB>();

            var r1Hashed = signInManager.CreadHashedUser("123");
            var r1 = userDb.Add(new Core.Models.User
            {
                UserName = "eyup",
                FirstName = "Eyüp",
                LastName = "Gevenim",
                Email = "eyupgevenim@gmail.com",
                Password = r1Hashed.Item1,
                Salt = r1Hashed.Item2
            });

            var r2Hashed = signInManager.CreadHashedUser("12345");
            var r2 = userDb.Add(new Core.Models.User
            {
                UserName = "test",
                FirstName = "Test Name",
                LastName = "Test Surname",
                Email = "test@test.com",
                Password = r2Hashed.Item1,
                Salt = r2Hashed.Item2
            });
        }
    }

}
