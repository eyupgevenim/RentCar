using Microsoft.AspNetCore.Mvc.Rendering;
using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.CustomerViewModels
{
    public class RegisterCustomerViewModel
    {
        public int Id { get; set; }

        [Display(Name = "Adı")]
        [Required(ErrorMessage = "Adı alanı boş geçemezsiniz!")]
        [StringLength(20, ErrorMessage = "{0} minimum {2} ve maksimum {1} karakter olmalı!", MinimumLength = 3)]
        public string FirstName { get; set; }

        [Display(Name = "Soyadı")]
        [Required(ErrorMessage = "Soyadı alanı boş geçemezsiniz!")]
        [StringLength(20, ErrorMessage = "{0} minimum {2} ve maksimum {1} karakter olmalı!", MinimumLength = 3)]
        public string LastName { get; set; }

        [Display(Name = "Unvanı")]
        [Required(ErrorMessage = "Unvan alanı boş geçemezsiniz!")]
        [StringLength(50, ErrorMessage = "{0} 3-50 karakter aralıkta olmalı!", MinimumLength = 3)]
        public string Caption { get; set; }
        
        [Display(Name = "TC No")]
        [Required(ErrorMessage = "TC No alanı boş geçemezsiniz!")]
        [StringLength(11, ErrorMessage = "{0} 11 karakter olmalı!", MinimumLength = 11)]
        public string IdentityNumber { get; set; }

        [Display(Name = "Doğum Tarihi")]
        [Required(ErrorMessage = "Doğum Tarih alanı boş geçemezsiniz!")]
        public DateTime Birthdate { get; set; }

        [Display(Name = "Cinsiyet")]
        public Gender Gender { get; set; }

        [Display(Name = "Vergi No")]
        [Required(ErrorMessage = "Vergi No alanı boş geçemezsiniz!")]
        [StringLength(10, ErrorMessage = "{0} 10 karakter olmalı!", MinimumLength = 10)]
        public string TaxNumber { get; set; }

        [Display(Name = "Vergi Dairesi")]
        [Required(ErrorMessage = "Vergi Dairesi alanı boş geçemezsiniz!")]
        public string TaxOffice { get; set; }

        [Display(Name = "Cep Tel")]
        [Required(ErrorMessage = "Cep Tel alanı boş geçemezsiniz!")]
        [StringLength(10, ErrorMessage = "{0} 10 karakter olmalı!", MinimumLength = 10)]
        public string Mobile { get; set; }

        [Display(Name = "Ev Tel")]
        [StringLength(10, ErrorMessage = "{0} 10 karakter olmalı!", MinimumLength = 10)]
        public string HomePhone { get; set; }

        [Display(Name = "Office Tel")]
        [StringLength(10, ErrorMessage = "{0} 10 karakter olmalı!", MinimumLength = 10)]
        public string OfficePhone { get; set; }
        
        [Display(Name = "İlçe")]
        public int CityId { get; set; }
        public List<SelectListItem> Cities { get; set; }

        [Display(Name = "Adres")]
        [Required(ErrorMessage = "Adres alanı boş geçemezsiniz!")]
        public string Address { get; set; }

        public int StateId { get; set; }
        public List<SelectListItem> States { get; set; }

        [Display(Name = "Aktiflik")]
        public bool IsActive { get; set; }
    }
}
