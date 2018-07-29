using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Models
{
    public class Report
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public Vehicle Vehicle { get; set; }
        public double TotalPrice { get; set; }
        public int TotalBookingCount { get; set; }
        public double TotalBookingPercent { get; set; }
    }
}
