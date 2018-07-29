using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface IReportDB
    {
        List<Report> VehiclePrice(Report model);
        List<Report> BookingCount();
    }
}
