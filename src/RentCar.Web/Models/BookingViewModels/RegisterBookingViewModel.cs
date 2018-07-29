using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.BookingViewModels
{
    public class RegisterBookingViewModel
    {
        public int Id { get; set; }
        

        [Display(Name = "Araç")]
        public int VehicleId { get; set; }
        public string Vehicle { get; set; }

        [Display(Name = "Müşteri")]
        public int CustomerId { get; set; }
        public string Customer { get; set; }

        [Display(Name = "Başlangıç Tarihi")]
        [Required(ErrorMessage = "Başlangıç Tarihi alanı boş geçemezsiniz!")]
        public DateTime StartDate { get; set; }

        [Display(Name = "Bitiş Tarihi")]
        [Required(ErrorMessage = "Bitiş Tarihi alanı boş geçemezsiniz!")]
        public DateTime EndDate { get; set; }

        [Display(Name = "Süre")]
        public double Duration
        {
            get
            {
                TimeSpan diff = EndDate - StartDate;
                if (diff.TotalMinutes > 0)
                {
                    return diff.TotalMinutes / (60 * 24);
                }
                return 0;
            }
        }

        [Display(Name = "Toplam Ücret")]
        public double Price { get; set; }
        
        [Display(Name = "İptal Et")]
        public bool IsCancel { get; set; }
    }
}
