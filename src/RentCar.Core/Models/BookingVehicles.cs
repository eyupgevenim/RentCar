using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Models
{
    public class BookingVehicles
    {
        public int? Id { get; set; }
        public int VehicleId { get; set; }
        public Vehicle Vehicle { get; set; }
        public int CustomerId { get; set; }
        public Customer Customer { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public double Duration { get; set; }
        public double Price { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }

        public bool IsCancel { get; set; }
    }
}
