using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface IBookingDB
    {
        BookingVehicles AddOrUpdate(BookingVehicles model);
        BookingVehicles Get(BookingVehicles model);
        List<BookingVehicles> List(BookingVehicles model);
    }
}
