using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface ISignInManager
    {
        bool GetClaimsPrincipal(string userName, string password, User user, out ClaimsPrincipal principal);
        Tuple<string, string> CreadHashedUser(string password);
    }
}
