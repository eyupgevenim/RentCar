using Microsoft.Extensions.Configuration;
using RentCar.Core.Helpers;
using RentCar.Core.Interfaces;
using System;
using System.Data.SqlClient;

namespace RentCar.Core.Datebase
{
#pragma warning disable S3881 // "IDisposable" should be implemented correctly
    public abstract class BaseDB : IDisposable
#pragma warning restore S3881 // "IDisposable" should be implemented correctly
    {
        protected readonly DBHelper db;
        protected IConfiguration Configuration { get; }

        protected BaseDB(IConfiguration configuration)
        {
            Configuration = configuration;
            db = new DBHelper(new SqlConnection(Configuration.GetConnectionString("DefaultDatabase")));
        }
        
        public virtual void Dispose()
        {
            db?.CloseConnection();
        }
    }
}
