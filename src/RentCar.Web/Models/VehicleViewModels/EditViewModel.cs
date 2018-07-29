using Microsoft.AspNetCore.Mvc.Rendering;
using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.VehicleViewModels
{
    public class EditViewModel
    {
        [Display(Name = "Plaka")]
        [Required(ErrorMessage = "Plaka alanı boş geçemezsiniz!")]
        [StringLength(8, ErrorMessage = "{0} minimum {2} ve maksimum {1} karakter olmalı!", MinimumLength = 7)]
        public string Plate { get; set; }

        [Display(Name = "Şasi No")]
        [Required(ErrorMessage = "Şasi No alanı boş geçemezsiniz!")]
        [StringLength(17, ErrorMessage = "{0} 17 karakter olmalı!", MinimumLength = 17)]
        public string ChassisNo { get; set; }

        [Display(Name = "Model Yıllı")]
        [Required(ErrorMessage = "Model Yıllı alanı boş geçemezsiniz!")]
        [Range(1950, 2050, ErrorMessage ="{0}, {1} - {2} yıllar arasında olmalı!")]
        public int ModelYear { get; set; }

        [Display(Name = "Renk")]
        public Color Color { get; set; }

        [Display(Name = "Model")]
        public int ModelId { get; set; }
        public List<SelectListItem> Models { get; set; }

        [Display(Name = "Tip")]
        public int TypeId { get; set; }
        public List<SelectListItem> Types { get; set; }

        [Display(Name = "Günlük Ücret")]
        [Required(ErrorMessage = "Günlük Ücret alanı boş geçemezsiniz!")]
        public double CurrencyValue { get; set; }

        [Display(Name = "Para Birimi")]
        public Currency Currency { get; set; }

        [Display(Name = "Marka")]
        public int BrandId { get; set; }
        public List<SelectListItem> Brands { get; set; }

        [Display(Name = "Aktiflik")]
        public bool IsActive { get; set; }
    }
}
