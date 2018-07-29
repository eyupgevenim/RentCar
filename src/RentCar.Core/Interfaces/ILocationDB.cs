using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface ILocationDB
    {
        List<State> GetStates();
        List<City> GetCities(int stateId);
    }
}
