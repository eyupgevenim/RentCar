using Microsoft.Extensions.Configuration;
using RentCar.Core.Helpers;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace RentCar.Core.Datebase
{
    public class BookingDB : BaseDB, IBookingDB
    {
        public BookingDB(IConfiguration configuration) : base(configuration)
        {
        }

        public BookingVehicles AddOrUpdate(BookingVehicles model)
        {
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_BookingVehicleAddOrUpdate");
            db.InOutParameter(cmd, "@Id", DbType.Int32, model.Id);
            db.DateParameter(cmd, "@StartDate", model.StartDate);
            db.DateParameter(cmd, "@EndDate", model.EndDate);
            db.DoubleParameter(cmd, "@Duration", model.Duration);
            db.IntegerParameter(cmd, "@VehicleId", model.VehicleId);
            db.IntegerParameter(cmd, "@CustomerId", model.CustomerId);
            db.IntegerParameter(cmd, "@UserId", model.UserId);
            db.DoubleParameter(cmd, "@Price", model.Price);
            db.BooleanParameter(cmd, "@IsCancel", model.IsCancel);

            cmd.ExecuteNonQuery();

            if (cmd.Parameters["@Id"].Value != DBNull.Value)
                model.Id = Convert.ToInt32(cmd.Parameters["@Id"].Value);

            return model;
        }

        public BookingVehicles Get(BookingVehicles model)
        {
            BookingVehicles item = null;
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_BookingVehicleGetDetail");
            db.IntegerParameter(cmd, "@Id", model.Id);

            using (var dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    item = new BookingVehicles
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        StartDate = Convert.ToDateTime(dr["StartDate"]),
                        EndDate = Convert.ToDateTime(dr["EndDate"]),
                        Duration = Convert.ToDouble(dr["Duration"]),
                        Price = Convert.ToDouble(dr["Price"]),
                        IsCancel = Convert.ToBoolean(dr["IsCancel"]),
                        VehicleId= Convert.ToInt32(dr["VehicleId"]),
                        Customer = new Customer
                        {
                            Id = Convert.ToInt32(dr["CustomerId"]),
                            FirstName = dr["FirstName"].ToString(),
                            LastName = dr["LastName"].ToString(),
                            Caption = dr["Caption"].ToString(),
                            IdentityNumber = dr["IdentityNumber"].ToString(),
                            Birthdate = Convert.ToDateTime(dr["Birthdate"]),
                            Gender = dr["Gender"].ToString().ToEnum<Gender>(),
                            TaxNumber = dr["TaxNumber"].ToString(),
                            TaxOffice = dr["TaxOffice"].ToString(),
                            Mobile = dr["Mobile"].ToString(),
                            HomePhone = dr["HomePhone"].ToString(),
                            OfficePhone = dr["OfficePhone"].ToString(),
                            IsActive = Convert.ToBoolean(dr["IsActiveCustomer"])
                        },
                        User = new User
                        {
                            Id = Convert.ToInt32(dr["UserId"]),
                            UserName = dr["UserName"].ToString(),
                            FirstName = dr["uFirstName"].ToString(),
                            LastName = dr["uLastName"].ToString(),
                            Email = dr["uEmail"].ToString(),
                            IsActive = Convert.ToBoolean(dr["IsActiveUser"])
                        }
                    };
                }
            }

            return item;
        }

        public List<BookingVehicles> List(BookingVehicles model)
        {
            List<BookingVehicles> list = new List<BookingVehicles>();
            BookingVehicles item;
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_BookingVehicleGetList");
            db.IntegerParameter(cmd, "@VehicleId", model.VehicleId);

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new BookingVehicles
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        StartDate = Convert.ToDateTime(dr["StartDate"]),
                        EndDate = Convert.ToDateTime(dr["EndDate"]),
                        Duration= Convert.ToDouble(dr["Duration"]),
                        Price = Convert.ToDouble(dr["Price"]),
                        IsCancel = Convert.ToBoolean(dr["IsCancel"]),
                        Customer = new Customer
                        {
                            Id = Convert.ToInt32(dr["CustomerId"]),
                            FirstName = dr["FirstName"].ToString(),
                            LastName = dr["LastName"].ToString(),
                            Caption = dr["Caption"].ToString(),
                            IdentityNumber = dr["IdentityNumber"].ToString(),
                            Birthdate = Convert.ToDateTime(dr["Birthdate"]),
                            Gender = dr["Gender"].ToString().ToEnum<Gender>(),
                            TaxNumber = dr["TaxNumber"].ToString(),
                            TaxOffice = dr["TaxOffice"].ToString(),
                            Mobile = dr["Mobile"].ToString(),
                            HomePhone = dr["HomePhone"].ToString(),
                            OfficePhone = dr["OfficePhone"].ToString(),
                            IsActive = Convert.ToBoolean(dr["IsActiveCustomer"])
                        },
                        User=new User
                        {
                            Id = Convert.ToInt32(dr["UserId"]),
                            UserName = dr["UserName"].ToString(),
                            FirstName = dr["uFirstName"].ToString(),
                            LastName = dr["uLastName"].ToString(),
                            Email = dr["uEmail"].ToString(),
                            IsActive = Convert.ToBoolean(dr["IsActiveUser"])
                        }
                    };

                    list.Add(item);
                }
            }

            return list;
        }
    }
}
