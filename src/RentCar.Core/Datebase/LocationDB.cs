using Microsoft.Extensions.Configuration;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Datebase
{
    public class LocationDB : BaseDB, ILocationDB
    {
        public LocationDB(IConfiguration configuration) : base(configuration)
        {
        }

        public List<City> GetCities(int stateId)
        {
            List<City> list = new List<City>();
            City item = null;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_CityGetList");
            db.IntegerParameter(cmd, "@StateId", stateId);

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new City
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        Name = dr["Name"].ToString()
                    };

                    list.Add(item);
                }
            }

            return list;
        }

        public List<State> GetStates()
        {
            List<State> list = new List<State>();
            State item = null;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_StateGetList");

            using (var dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    item = new State
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
