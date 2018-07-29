using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

namespace RentCar.Core.Models
{
    //taşıt
    public class Vehicle
    {
        public int? Id { get; set; }
        public int ModelYear { get; set; }
        public string Plate { get; set; }
        public string ChassisNo  { get; set; }
        public Color Color { get; set; }
        
        public int BrandId { get; set; }
        public VehicleBrand Brand { get; set; }

        public int VehicleModelId { get; set; }
        public VehicleModel Model { get; set; }

        public int VehicleTypeId { get; set; }
        public VehicleType VehicleType { get; set; }

        public double CurrencyValue { get; set; }
        public Currency Currency { get; set; }

        public bool? IsActive { get; set; }

        public double? BookingRemainingTime { get; set; }
    }

    //marka
    public class VehicleBrand
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    //model
    public class VehicleModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int VehicleBrandId { get; set; }
    }

    //renk
    public enum Color
    {
        [Description("Siyah")]
        Siyah =1,
        [Description("Kırmızı")]
        Kirmizi=2,
        [Description("Yeşil")]
        Yesil =3,
        [Description("Sarı")]
        Sari =4,
        [Description("Mavi")]
        Mavi =5,
        [Description("Gri")]
        Gri =6,
        [Description("Beyaz")]
        Beyaz = 7
    }

    //tipi
    public class VehicleType
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    //para birimi
    public enum Currency
    {
        [Description("TL")]
        TL=1,
        [Description("USD")]
        USD =2,
        [Description("EUR")]
        EUR = 3
    }
}
