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
    public class CustomerDB : BaseDB, ICustomerDB
    {
        public CustomerDB(IConfiguration configuration) : base(configuration)
        {
        }

        public Customer AddOrUpdate(Customer customer)
        {
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_CustomerAddOrUpdate");
            db.InOutParameter(cmd, "@Id", DbType.Int32, customer.Id);
            db.StringParameter(cmd, "@FirstName", customer.FirstName);
            db.StringParameter(cmd, "@LastName", customer.LastName);
            db.StringParameter(cmd, "@Caption", customer.Caption);
            db.StringParameter(cmd, "@IdentityNumber", customer.IdentityNumber);
            db.DateParameter(cmd, "@Birthdate", customer.Birthdate);
            db.IntegerParameter(cmd, "@Gender", (int)customer.Gender);
            db.StringParameter(cmd, "@TaxNumber", customer.TaxNumber);
            db.StringParameter(cmd, "@TaxOffice", customer.TaxOffice);
            db.StringParameter(cmd, "@Mobile", customer.Mobile);
            db.StringParameter(cmd, "@HomePhone", customer.HomePhone);
            db.StringParameter(cmd, "@OfficePhone", customer.OfficePhone);
            db.IntegerParameter(cmd, "@CityId", customer.CityId);
            db.StringParameter(cmd, "@Address", customer.Address);
            db.BooleanParameter(cmd, "@IsActive", customer.IsActive);
            
            cmd.ExecuteNonQuery();

            if (cmd.Parameters["@Id"].Value != DBNull.Value)
                customer.Id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
            
            return customer;
        }
        
        public Customer Get(Customer customer)
        {
            Customer result = null;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_CustomerGetDetail");
            db.IntegerParameter(cmd, "@Id", customer.Id);

            using (var dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    result = new Customer
                    {
                        Id = Convert.ToInt32(dr["Id"]),
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
                        CityId = Convert.ToInt32(dr["CityId"]),
                        City = new City
                        {
                            Id = Convert.ToInt32(dr["CityId"]),
                            Name = dr["CityName"].ToString()
                        },
                        StateId = Convert.ToInt32(dr["StateId"]),
                        State = new State
                        {
                            Id = Convert.ToInt32(dr["StateId"]),
                            Name = dr["StateName"].ToString()
                        },
                        Address = dr["Address"].ToString(),
                        IsActive = Convert.ToBoolean(dr["IsActive"])
                    };
                }
            }

            return result;
        }

        public List<Customer> List(Customer customer)
        {
            List<Customer> list = new List<Customer>();
            Customer item;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_CustomerGetList");
            db.StringParameter(cmd, "@FirstName", customer.FirstName);
            db.StringParameter(cmd, "@LastName", customer.LastName);
            db.StringParameter(cmd, "@Caption", customer.Caption);
            db.StringParameter(cmd, "@Mobile", customer.Mobile);
            db.StringParameter(cmd, "@HomePhone", customer.HomePhone);
            db.StringParameter(cmd, "@OfficePhone", customer.OfficePhone);
            db.BooleanParameter(cmd, "@IsActive", customer.IsActive);

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new Customer
                    {
                        Id = Convert.ToInt32(dr["Id"]),
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
                        CityId = Convert.ToInt32(dr["CityId"]),
                        City =new City
                        {
                            Id = Convert.ToInt32(dr["CityId"]),
                            Name = dr["CityName"].ToString()
                        },
                        StateId = Convert.ToInt32(dr["StateId"]),
                        State=new State
                        {
                            Id = Convert.ToInt32(dr["StateId"]),
                            Name = dr["StateName"].ToString()
                        },
                        Address= dr["Address"].ToString(),
                        IsActive = Convert.ToBoolean(dr["IsActive"]),
                    };

                    list.Add(item);
                }
            }

            return list;
        }

        public bool Delete(int id)
        {
            throw new NotImplementedException();
        }
    }
}
