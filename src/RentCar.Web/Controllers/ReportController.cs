using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using RentCar.Web.Models;
using RentCar.Web.Models.ReportViewModels;

namespace RentCar.Web.Controllers
{
    public class ReportController : BaseController
    {
        private readonly IReportDB reportDB;
        public ReportController(IReportDB reportDB)
        {
            this.reportDB = reportDB;
        }

        public IActionResult Index()
        {
            return View(new ReportViewModel());
        }

        [HttpPost]
        public IActionResult Index(ReportViewModel model)
        {
            try
            {
                if(model.ReportType == ReportType.Price)
                {
                    model.Reports = reportDB.VehiclePrice(new Report
                    {
                        StartDate =model.StartDate,
                        EndDate =model.EndDate
                    });
                }
                else if(model.ReportType == ReportType.BookingCount)
                {
                    model.Reports = reportDB.BookingCount();
                }
            }
            catch (Exception ex)
            {
                //loglama
            }
            return View(model);
        }

    }
}
