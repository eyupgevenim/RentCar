using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.BookingViewModels
{
    public class BookingViewModel
    {
        public int? Id { get; set; }
        public int ModelYear { get; set; }
        public string Plate { get; set; }
        public string ChassisNo { get; set; }
        public Color Color { get; set; }

        public int BrandId { get; set; }
        public VehicleBrand Brand { get; set; }

        public int VehicleModelId { get; set; }
        public VehicleModel Model { get; set; }

        public int VehicleTypeId { get; set; }
        public VehicleType VehicleType { get; set; }

        public double CurrencyValue { get; set; }
        public Currency Currency { get; set; }
        
        public double? BookingRemainingTime { get; set; }
        public string RemainingTimeFormed
        {
            get
            {
                if(BookingRemainingTime != null)
                {
                    double d = (double)BookingRemainingTime / (60 * 24);
                    return d.ToString("#.00 gün");
                }
                return "";
            }
        }
    }
}
