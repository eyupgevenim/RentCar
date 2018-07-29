using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.BookingViewModels
{
    public class DetailBookingViewModel
    {
        public Vehicle Vehicle { get; set; } = new Vehicle();
        public List<BookingVehicles> Booking { get; set; } = new List<BookingVehicles>();
    }
}
