using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using RentCar.Core.Models;

namespace RentCar.Web.Controllers
{
    public class BaseController : Controller
    {
        protected User GetLoginUser
        {
            get
            {
                if (HttpContext.User.Identity.IsAuthenticated)
                {
                    try
                    {
                        var claims = HttpContext.User.Claims.ToList();

                        int.TryParse(claims.Single(s => s.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid").Value, out int UserId);
                        string UserName = claims.Single(s => s.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name").Value;

                        return new User
                        {
                            Id = UserId,
                            UserName = UserName
                        };
                    }
                    catch(Exception ex)
                    {
                        //loglama
                    }
                }
                return null;
            }
        }
    }
}