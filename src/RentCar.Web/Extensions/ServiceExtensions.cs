using Microsoft.Extensions.DependencyInjection;
using RentCar.Core.Datebase;
using RentCar.Core.Interfaces;
using RentCar.Core.Services;

namespace RentCar.Web.Extensions
{
    public static class ServiceExtensions
    {
        public static IServiceCollection AddDatabaseServices(this IServiceCollection services)
        {
            services
                .AddScoped<IUserDB, UserDB>()
                .AddScoped<ICustomerDB, CustomerDB>()
                .AddScoped<ILocationDB, LocationDB>()
                .AddScoped<IVehicleDB, VehicleDB>()
                .AddScoped<IBookingDB, BookingDB>()
                .AddScoped<IReportDB, ReportDB>();

            services
                .AddScoped<ISignInManager, SignInManager>();

            return services;
        }
    }
}
