using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.ReportViewModels
{
    public class ReportViewModel
    {
        [Display(Name = "Araç Raporlama Türü")]
        public ReportType ReportType { get; set; }

        [Display(Name ="Başlangıç Tarihi")]
        public DateTime StartDate { get; set; }

        [Display(Name = "Bitiş Tarihi")]
        public DateTime EndDate { get; set; }

        public List<Report> Reports { get; set; }
    }

    public enum ReportType
    {
        [Description("Toplam Ücret")]
        Price =1,
        [Description("Rezervasyon Sayısı")]
        BookingCount =2
    }
}
