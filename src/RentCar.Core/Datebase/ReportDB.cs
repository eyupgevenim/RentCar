using Microsoft.Extensions.Configuration;
using RentCar.Core.Helpers;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Datebase
{
    public class ReportDB : BaseDB, IReportDB
    {
        public ReportDB(IConfiguration configuration) : base(configuration)
        {
        }
        
        public List<Report> VehiclePrice(Report model)
        {
            List<Report> list = new List<Report>();
            Report item = null;
            
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_ReportVehiclePrice");
            db.DateParameter(cmd, "@StartDate", model.StartDate);
            db.DateParameter(cmd, "@EndDate", model.EndDate);

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new Report
                    {
                        Vehicle=new Vehicle
                        {
                            Id = Convert.ToInt32(dr["Id"]),
                            Plate = dr["Plate"].ToString(),
                            ChassisNo = dr["ChassisNo"].ToString(),
                            ModelYear = Convert.ToInt32(dr["ModelYear"]),
                            BrandId = Convert.ToInt32(dr["BrandId"]),
                            Brand = new VehicleBrand
                            {
                                Id = Convert.ToInt32(dr["BrandId"]),
                                Name = dr["BrandName"].ToString()
                            },
                            VehicleModelId = Convert.ToInt32(dr["VehicleModelId"]),
                            Model = new VehicleModel
                            {
                                Id = Convert.ToInt32(dr["VehicleModelId"]),
                                Name = dr["ModelName"].ToString()
                            },
                            VehicleTypeId = Convert.ToInt32(dr["VehicleTypeId"]),
                            VehicleType = new VehicleType
                            {
                                Id = Convert.ToInt32(dr["VehicleTypeId"]),
                                Name = dr["TypeName"].ToString()
                            },
                            Color = dr["Color"].ToString().ToEnum<Color>(),
                            Currency = dr["Currency"].ToString().ToEnum<Currency>(),
                            CurrencyValue = Convert.ToDouble(dr["CurrencyValue"]),
                            IsActive = Convert.ToBoolean(dr["IsActive"])
                        }
                    };
                    if (double.TryParse(dr["TotalPrice"].ToString(), out double result))
                        item.TotalPrice = result;

                    list.Add(item);
                }
            }

            return list;
        }

        public List<Report> BookingCount()
        {
            List<Report> list = new List<Report>();
            Report item = null;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_ReportBookingCount");

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new Report
                    {
                        Vehicle = new Vehicle
                        {
                            Id = Convert.ToInt32(dr["Id"]),
                            Plate = dr["Plate"].ToString(),
                            ChassisNo = dr["ChassisNo"].ToString(),
                            ModelYear = Convert.ToInt32(dr["ModelYear"]),
                            BrandId = Convert.ToInt32(dr["BrandId"]),
                            Brand = new VehicleBrand
                            {
                                Id = Convert.ToInt32(dr["BrandId"]),
                                Name = dr["BrandName"].ToString()
                            },
                            VehicleModelId = Convert.ToInt32(dr["VehicleModelId"]),
                            Model = new VehicleModel
                            {
                                Id = Convert.ToInt32(dr["VehicleModelId"]),
                                Name = dr["ModelName"].ToString()
                            },
                            VehicleTypeId = Convert.ToInt32(dr["VehicleTypeId"]),
                            VehicleType = new VehicleType
                            {
                                Id = Convert.ToInt32(dr["VehicleTypeId"]),
                                Name = dr["TypeName"].ToString()
                            },
                            Color = dr["Color"].ToString().ToEnum<Color>(),
                            Currency = dr["Currency"].ToString().ToEnum<Currency>(),
                            CurrencyValue = Convert.ToDouble(dr["CurrencyValue"]),
                            IsActive = Convert.ToBoolean(dr["IsActive"])
                        }
                    };

                    if (int.TryParse(dr["TotalBookingCount"].ToString(), out int result))
                        item.TotalBookingCount = result;

                    list.Add(item);
                }
            }

            return list;
        }
    }
}
