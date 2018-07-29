using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using RentCar.Web.Models.BookingViewModels;

namespace RentCar.Web.Controllers
{
    [Authorize]
    public class BookingController : BaseController
    {
        private readonly IBookingDB bookingDB;
        private readonly IVehicleDB vehicleDB;
        public BookingController(IBookingDB bookingDB, IVehicleDB vehicleDB)
        {
            this.bookingDB = bookingDB;
            this.vehicleDB = vehicleDB;
        }

        public IActionResult Index()
        {
            var model = new List<BookingViewModel>();
            try
            {
                model = vehicleDB.EligibilityList(new Vehicle { IsActive = true })
                .Select(s => new BookingViewModel
                {
                    Id = s.Id.Value,
                    Plate = s.Plate,
                    ChassisNo = s.ChassisNo,
                    BrandId=s.BrandId,
                    Brand = s.Brand,
                    VehicleModelId=s.VehicleModelId,
                    Model = s.Model,
                    ModelYear = s.ModelYear,
                    VehicleTypeId=s.VehicleTypeId,
                    VehicleType = s.VehicleType,
                    Color = s.Color,
                    CurrencyValue = s.CurrencyValue,
                    Currency = s.Currency,
                    BookingRemainingTime=s.BookingRemainingTime
                }).ToList();
                
            }
            catch (Exception ex)
            {
                //loglama
            }
            
            return View(model);
        }

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Create(RegisterBookingViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var user = GetLoginUser;
                    var booking = bookingDB.AddOrUpdate(new BookingVehicles
                    {
                        CustomerId = model.CustomerId,
                        VehicleId = model.VehicleId,
                        UserId = user != null ? user.Id : 0,
                        Price = model.Price,
                        StartDate = model.StartDate,
                        EndDate = model.EndDate,
                        Duration = model.Duration
                    });

                    if (booking.Id != null)
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
        public IActionResult Detail(int id)
        {
            var model = new DetailBookingViewModel();
            try
            {
                model.Vehicle = vehicleDB.Get(new Vehicle { Id = id });
                model.Booking = bookingDB.List(new BookingVehicles { Id = id });

            }
            catch (Exception ex)
            {
                //loglama
            }

            return View(model);
        }

        [HttpGet]
        public IActionResult Edit(int id)
        {
            var model = new RegisterBookingViewModel();
            try
            {
                var detay = bookingDB.Get(new BookingVehicles { Id = id });
                var vehicle = vehicleDB.Get(new Vehicle { Id = detay.VehicleId });
                model = new RegisterBookingViewModel
                {
                    CustomerId = detay.CustomerId,
                    VehicleId = detay.VehicleId,
                    Price = detay.Price,
                    StartDate = detay.StartDate,
                    EndDate = detay.EndDate,
                    Customer = $"{detay.Customer.FirstName} {detay.Customer.LastName} | {detay.Customer.Mobile}",
                    Vehicle = $"{vehicle.Plate} | {vehicle.Brand?.Name} {vehicle.Model?.Name} | {vehicle.ModelYear}"
                };
                
            }
            catch (Exception ex)
            {
                //loglama
            }

            return View(model);
        }

        [HttpPost]
        public IActionResult Edit(int id, RegisterBookingViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var user = GetLoginUser;
                    var booking = bookingDB.AddOrUpdate(new BookingVehicles
                    {
                        Id = id,
                        CustomerId = model.CustomerId,
                        VehicleId = model.VehicleId,
                        UserId = user != null ? user.Id : 0,
                        Price = model.Price,
                        StartDate = model.StartDate,
                        EndDate = model.EndDate,
                        Duration = model.Duration
                    });

                    if (booking.Id != null)
                        return RedirectToAction("Index");
                }

                
            }
            catch (Exception ex)
            {
                //loglanmalı
            }

            return View(model);
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View();
        }
    }
}