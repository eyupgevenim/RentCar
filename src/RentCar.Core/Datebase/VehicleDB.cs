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
    public class VehicleDB : BaseDB, IVehicleDB
    {
        public VehicleDB(IConfiguration configuration) : base(configuration)
        {
        }

        public Vehicle AddOrUpdate(Vehicle model)
        {
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleAddOrUpdate");
            db.InOutParameter(cmd, "@Id", DbType.Int32, model.Id);
            db.IntegerParameter(cmd, "@ModelYear", model.ModelYear);
            db.StringParameter(cmd, "@Plate", model.Plate);
            db.StringParameter(cmd, "@ChassisNo", model.ChassisNo);
            db.IntegerParameter(cmd, "@Color", (int)model.Color);
            db.IntegerParameter(cmd, "@VehicleModelId", model.VehicleModelId);
            db.IntegerParameter(cmd, "@VehicleTypeId", model.VehicleTypeId);
            db.DoubleParameter(cmd, "@CurrencyValue", model.CurrencyValue);
            db.IntegerParameter(cmd, "@Currency", (int)model.Currency);
            db.BooleanParameter(cmd, "@IsActive", model.IsActive);
            
            cmd.ExecuteNonQuery();

            if (cmd.Parameters["@Id"].Value != DBNull.Value)
                model.Id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
            
            return model;
        }
        
        public Vehicle Get(Vehicle model)
        {
            Vehicle result = null;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleGetDetail");
            db.IntegerParameter(cmd, "@Id", model.Id);
            
            using (var dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    result = new Vehicle
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
                        IsActive= Convert.ToBoolean(dr["IsActive"])
                    };
                }
            }

            return result;
        }

        public List<Vehicle> List(Vehicle model)
        {
            List<Vehicle> list = new List<Vehicle>();
            Vehicle item;
            
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleGetList");
            db.IntegerParameter(cmd, "@ModelYear", model.ModelYear);
            db.IntegerParameter(cmd, "@Color", (int)model.Color);
            db.IntegerParameter(cmd, "@VehicleModelId", model.VehicleModelId);
            db.IntegerParameter(cmd, "@VehicleTypeId", model.VehicleModelId);
            db.IntegerParameter(cmd, "@Currency", (int)model.Currency);
            db.BooleanParameter(cmd, "@IsActive", model.IsActive);

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new Vehicle
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        ModelYear = Convert.ToInt32(dr["ModelYear"]),
                        Plate = dr["Plate"].ToString(),
                        ChassisNo = dr["ChassisNo"].ToString(),
                        Color = dr["Color"].ToString().ToEnum<Color>(),
                        VehicleModelId = Convert.ToInt32(dr["VehicleModelId"]),
                        Model = new VehicleModel
                        {
                            Id = Convert.ToInt32(dr["VehicleModelId"]),
                            Name = dr["ModelName"].ToString()
                        },
                        Brand = new VehicleBrand
                        {
                            Id = Convert.ToInt32(dr["BrandId"]),
                            Name = dr["BrandName"].ToString()
                        },
                        VehicleTypeId = Convert.ToInt32(dr["VehicleTypeId"]),
                        VehicleType = new VehicleType
                        {
                            Id = Convert.ToInt32(dr["VehicleTypeId"]),
                            Name = dr["TypeName"].ToString()
                        },
                        CurrencyValue = Convert.ToDouble(dr["CurrencyValue"]),
                        Currency = dr["Currency"].ToString().ToEnum<Currency>(),
                        IsActive = Convert.ToBoolean(dr["IsActive"])
                    };

                    list.Add(item);
                }
            }

            return list;
        }

        public List<Vehicle> EligibilityList(Vehicle model)
        {
            List<Vehicle> list = new List<Vehicle>();
            Vehicle item;
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleEligibilityGetList");
            db.IntegerParameter(cmd, "@ModelYear", model.ModelYear);
            db.IntegerParameter(cmd, "@Color", (int)model.Color);
            db.StringParameter(cmd, "@ModelName", model.Model?.Name);
            db.StringParameter(cmd, "@TypeName", model.VehicleType?.Name);
            db.StringParameter(cmd, "@BrandName", model.Brand?.Name);
            db.IntegerParameter(cmd, "@Currency", (int)model.Currency);
            
            using (var dr=cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new Vehicle
                    {
                        Id=Convert.ToInt32(dr["Id"]),
                        Plate = dr["Plate"].ToString(),
                        ChassisNo = dr["ChassisNo"].ToString(),
                        ModelYear = Convert.ToInt32(dr["ModelYear"]),
                        BrandId = Convert.ToInt32(dr["BrandId"]),
                        Color = dr["Color"].ToString().ToEnum<Color>(),
                        Currency = dr["Currency"].ToString().ToEnum<Currency>(),
                        CurrencyValue = Convert.ToDouble(dr["CurrencyValue"]),
                        IsActive = Convert.ToBoolean(dr["IsActive"]),
                        
                        VehicleModelId = Convert.ToInt32(dr["VehicleModelId"]),
                        Model = new VehicleModel
                        {
                            Id = Convert.ToInt32(dr["VehicleModelId"]),
                            Name = dr["ModelName"].ToString()
                        },
                        Brand = new VehicleBrand
                        {
                            Id = Convert.ToInt32(dr["BrandId"]),
                            Name = dr["BrandName"].ToString()
                        },
                        VehicleTypeId = Convert.ToInt32(dr["VehicleTypeId"]),
                        VehicleType = new VehicleType
                        {
                            Id = Convert.ToInt32(dr["VehicleTypeId"]),
                            Name = dr["TypeName"].ToString()
                        }
                    };

                    if (double.TryParse(dr["BookingRemainingTime"]?.ToString(), out double remainingTime))
                        item.BookingRemainingTime = remainingTime;

                    list.Add(item);
                }
            }

            return list;
        }

        public bool Delete(int id)
        {
            throw new NotImplementedException();
        }

        public List<VehicleBrand> BrandList()
        {
            List<VehicleBrand> list = new List<VehicleBrand>();
            VehicleBrand item;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleBrandGetList");

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new VehicleBrand
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        Name=dr["Name"].ToString()
                    };

                    list.Add(item);
                }
            }

            return list;
        }

        public List<VehicleModel> ModelList(int brandId)
        {
            List<VehicleModel> list = new List<VehicleModel>();
            VehicleModel item;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleModelGetList");
            db.IntegerParameter(cmd, "@VehicleBrandId", brandId);

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new VehicleModel
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        Name = dr["Name"].ToString(),
                        VehicleBrandId = Convert.ToInt32(dr["VehicleBrandId"]),
                    };

                    list.Add(item);
                }
            }

            return list;
        }

        public List<VehicleType> VehicleTypeList()
        {
            List<VehicleType> list = new List<VehicleType>();
            VehicleType item;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_VehicleTypeGetList");

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new VehicleType
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        Name = dr["Name"].ToString()
                    };

                    list.Add(item);
                }
            }

            return list;
        }
    }
}
