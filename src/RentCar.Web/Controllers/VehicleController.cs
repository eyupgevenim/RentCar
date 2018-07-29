using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using RentCar.Web.Models.VehicleViewModels;

namespace RentCar.Web.Controllers
{
    [Authorize]
    public class VehicleController : BaseController
    {
        private readonly IVehicleDB vehicleDB;
        public VehicleController(IVehicleDB vehicleDB)
        {
            this.vehicleDB = vehicleDB;
        }

        public IActionResult Index()
        {
            var model = new List<VehicleViewModel>();
            try
            {
                model = vehicleDB.List(new Vehicle()).Select(s => new VehicleViewModel
                {
                    Id = s.Id.Value,
                    Plate = s.Plate,
                    ChassisNo = s.ChassisNo,
                    Brand = s.Brand?.Name,
                    Model = s.Model?.Name,
                    ModelYear = s.ModelYear,
                    VehicleType = s.VehicleType?.Name,
                    Color = s.Color,
                    CurrencyValue = s.CurrencyValue,
                    Currency = s.Currency,
                    IsActive = s.IsActive.Value
                }).ToList();
            }
            catch (Exception ex)
            {
                // loglanmalı
            }
            return View(model);
        }
        
        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Create(RegisterViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var vehicle = vehicleDB.AddOrUpdate(new Vehicle
                    {
                        Plate = model.Plate,
                        ChassisNo = model.ChassisNo,
                        ModelYear = model.ModelYear,
                        VehicleModelId = model.ModelId,
                        VehicleTypeId = model.TypeId,
                        Color = model.Color,
                        CurrencyValue = model.CurrencyValue,
                        Currency = model.Currency
                    });

                    if (vehicle.Id != null)
                        return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                //loglanmalı
            }
            

            return View(model);
        }

        [HttpGet]
        public IActionResult Edit(int id)
        {
            var model = new EditViewModel();
            try
            {
                var detay = vehicleDB.Get(new Vehicle { Id = id });
                model = new EditViewModel
                {
                    Plate=detay.Plate,
                    ChassisNo=detay.ChassisNo,
                    ModelId=detay.VehicleModelId,
                    TypeId=detay.VehicleTypeId,
                    Color=detay.Color,
                    ModelYear=detay.ModelYear,
                    CurrencyValue=detay.CurrencyValue,
                    Currency=detay.Currency,
                    IsActive=detay.IsActive.Value
                };

                model.Brands = vehicleDB.BrandList().Select(s=> new SelectListItem { Value=s.Id.ToString(), Text=s.Name }).ToList();
                model.Models = vehicleDB.ModelList(detay.BrandId).Select(s=> new SelectListItem { Value=s.Id.ToString(), Text=s.Name }).ToList();
                model.Types = vehicleDB.VehicleTypeList().Select(s=> new SelectListItem { Value=s.Id.ToString(), Text=s.Name }).ToList();

            }
            catch (Exception ex)
            {
                //loglama
            }
            
            return View(model);
        }

        [HttpPost]
        public IActionResult Edit(int id, EditViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var vehicle = vehicleDB.AddOrUpdate(new Vehicle
                    {
                        Id = id,
                        Plate = model.Plate,
                        ChassisNo = model.ChassisNo,
                        ModelYear = model.ModelYear,
                        VehicleModelId = model.ModelId,
                        VehicleTypeId = model.TypeId,
                        Color = model.Color,
                        CurrencyValue = model.CurrencyValue,
                        Currency = model.Currency,
                        IsActive = model.IsActive
                    });

                    if (vehicle.Id != null)
                        return RedirectToAction("Index");
                }
                
                model.Brands = vehicleDB.BrandList().Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
                model.Models = vehicleDB.ModelList(model.BrandId).Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
                model.Types = vehicleDB.VehicleTypeList().Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
            }
            catch (Exception ex)
            {
                //loglanmalı
            }

            return View(model);
        }
        
        [HttpGet]
        public JsonResult Brands()
        {
            var model = new List<VehicleBrand>();
            try
            {
                model = vehicleDB.BrandList();
            }
            catch (Exception ex)
            {
                //loglama
            }

            return Json(model);
        }

        [HttpPost]
        [Route("[controller]/BrandModels/{id}")]
        public JsonResult BrandModels(int id)
        {
            var model = new List<VehicleModel>();
            try
            {
                model = vehicleDB.ModelList(id);
            }
            catch (Exception ex)
            {
                //loglama
            }

            return Json(model);
        }

        [HttpGet]
        public JsonResult VehicleTypes()
        {
            var model = new List<VehicleType>();
            try
            {
                model = vehicleDB.VehicleTypeList();
            }
            catch (Exception ex)
            {
                //loglama
            }

            return Json(model);
        }

        [HttpGet]
        public JsonResult SearchVehicleByBrandName(string term)
        {
            var model = new object();
            try
            {
                model = vehicleDB.EligibilityList(new Vehicle { Brand = new VehicleBrand { Name = term } })
                .Where(s=>s.BookingRemainingTime == null)
                .Select(s => new
                {
                    value = $"{s.Plate} | {s.Brand?.Name} {s.Model?.Name} | {s.ModelYear}",
                    id = s.Id
                }).ToList();
            }
            catch (Exception ex)
            {
                //loglama
            }

            return Json(model);
        }

    }
}