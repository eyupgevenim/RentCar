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
    public class UserDB : BaseDB, IUserDB
    {
        public UserDB(IConfiguration configuration) : base(configuration)
        {
        }

        public User Add(User user)
        {
            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_UserAddOrUpdate");
            db.InOutParameter(cmd, "@Id", DbType.Int32, user.Id);
            db.StringParameter(cmd, "@UserName", user.UserName);
            db.StringParameter(cmd, "@FirstName", user.FirstName);
            db.StringParameter(cmd, "@LastName", user.LastName);
            db.StringParameter(cmd, "@Email", user.Email);
            db.StringParameter(cmd, "@Password", user.Password);
            db.StringParameter(cmd, "@Salt", user.Salt);
            db.BooleanParameter(cmd, "@IsActive", user.IsActive);

            cmd.ExecuteNonQuery();

            if (cmd.Parameters["@Id"].Value != DBNull.Value)
                user.Id = Convert.ToInt32(cmd.Parameters["@Id"].Value);
            
            return user;
        }

        public bool Delete(int id)
        {
            throw new NotImplementedException();
        }
        
        public User Get(User user)
        {
            User result = null;

            db.OpenConnection();
            var cmd = db.CreateCommandStoredProcedure("sp_UserGetDetail");
            db.IntegerParameter(cmd, "@Id", user.Id);
            db.StringParameter(cmd, "@UserName", user.UserName);
            db.StringParameter(cmd, "@Email", user.Email);

            using (var dr = cmd.ExecuteReader())
            {
                if (dr.Read())
                {
                    result = new User
                    {
                        Id = Convert.ToInt32(dr["Id"]),
                        UserName = dr["UserName"].ToString(),
                        FirstName= dr["FirstName"].ToString(),
                        LastName= dr["LastName"].ToString(),
                        Email= dr["Email"].ToString(),
                        Password= dr["Password"].ToString(),
                        Salt= dr["Salt"].ToString()
                    };
                }
            }

            return result;
        }
    }
}
