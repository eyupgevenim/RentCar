using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface IUserDB
    {
        User Get(User user);
        User Add(User user);
        bool Delete(int id);
    }
}
