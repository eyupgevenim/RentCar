using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.VehicleViewModels
{
    public class VehicleViewModel
    {
        public int Id { get; set; }
        public int ModelYear { get; set; }
        public string Plate { get; set; }
        public string ChassisNo { get; set; }
        public Color Color { get; set; }
        public string Brand { get; set; }
        public string Model { get; set; }
        public string VehicleType { get; set; }
        public double CurrencyValue { get; set; }
        public Currency Currency { get; set; }
        public bool IsActive { get; set; }
    }
}
