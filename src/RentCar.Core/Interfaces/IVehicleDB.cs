using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface IVehicleDB
    {
        Vehicle Get(Vehicle model);
        Vehicle AddOrUpdate(Vehicle model);
        List<Vehicle> List(Vehicle model);
        List<Vehicle> EligibilityList(Vehicle model);
        bool Delete(int id);
        List<VehicleBrand> BrandList();
        List<VehicleModel> ModelList(int brandId);
        List<VehicleType> VehicleTypeList();
    }
}
