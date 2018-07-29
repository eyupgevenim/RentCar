using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using RentCar.Web.Models.CustomerViewModels;

namespace RentCar.Web.Controllers
{
    [Authorize]
    public class CustomerController : BaseController
    {
        private readonly ICustomerDB customerDB;
        private readonly ILocationDB locationDB;
        public CustomerController(ICustomerDB customerDB, ILocationDB locationDB)
        {
            this.customerDB = customerDB;
            this.locationDB = locationDB;
        }

        public IActionResult Index()
        {
            var model = new List<CustomerViewModel>();
            try
            {
                model = customerDB.List(new Customer()).Select(s => new CustomerViewModel
                {
                    Id=s.Id.Value,
                    FirstName=s.FirstName,
                    LastName=s.LastName,
                    Caption=s.Caption,
                    IdentityNumber=s.IdentityNumber,
                    Birthdate=s.Birthdate,
                    Gender=s.Gender,
                    TaxNumber=s.TaxNumber,
                    TaxOffice=s.TaxOffice,
                    Mobile=s.Mobile,
                    HomePhone=s.HomePhone,
                    OfficePhone=s.OfficePhone,
                    State=s.State?.Name,
                    City=s.City?.Name,
                    Address=s.Address,
                    IsActive=s.IsActive.Value
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
            var model = new RegisterCustomerViewModel();
            try
            {
                var stateList = locationDB.GetStates();
                model.States = stateList.Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
                model.Cities= locationDB.GetCities(stateList.First().Id).Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
            }
            catch (Exception ex)
            {
                //loglama
            }
            return View(model);
        }

        [HttpPost]
        public IActionResult Create(RegisterCustomerViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var customer = customerDB.AddOrUpdate(new Customer
                    {
                        FirstName = model.FirstName,
                        LastName = model.LastName,
                        Caption = model.Caption,
                        IdentityNumber = model.IdentityNumber,
                        Birthdate = model.Birthdate,
                        Gender = model.Gender,
                        TaxNumber = model.TaxNumber,
                        TaxOffice = model.TaxOffice,
                        Mobile = model.Mobile,
                        HomePhone = model.HomePhone,
                        OfficePhone = model.OfficePhone,
                        CityId = model.CityId,
                        Address = model.Address,
                    });

                    if (customer.Id != null)
                        return RedirectToAction("Index");
                }

                model.States = locationDB.GetStates().Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
                model.Cities = locationDB.GetCities(model.StateId).Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
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
            var model = new RegisterCustomerViewModel();
            try
            {
                var detay = customerDB.Get(new Customer { Id = id });
                model = new RegisterCustomerViewModel
                {
                    Id = id,
                    FirstName = detay.FirstName,
                    LastName = detay.LastName,
                    Caption = detay.Caption,
                    IdentityNumber = detay.IdentityNumber,
                    Birthdate = detay.Birthdate,
                    Gender = detay.Gender,
                    TaxNumber = detay.TaxNumber,
                    TaxOffice = detay.TaxOffice,
                    Mobile = detay.Mobile,
                    HomePhone = detay.HomePhone,
                    OfficePhone = detay.OfficePhone,
                    StateId=detay.StateId,
                    CityId = detay.CityId,
                    Address = detay.Address,
                    IsActive = detay.IsActive.Value
                };
                model.States = locationDB.GetStates().Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
                model.Cities = locationDB.GetCities(detay.StateId).Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();

            }
            catch (Exception ex)
            {
                //loglama
            }

            return View(model);
        }

        [HttpPost]
        public IActionResult Edit(int id, RegisterCustomerViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var vehicle = customerDB.AddOrUpdate(new Customer
                    {
                        Id = id,
                        FirstName = model.FirstName,
                        LastName = model.LastName,
                        Caption = model.Caption,
                        IdentityNumber = model.IdentityNumber,
                        Birthdate = model.Birthdate,
                        Gender = model.Gender,
                        TaxNumber = model.TaxNumber,
                        TaxOffice = model.TaxOffice,
                        Mobile = model.Mobile,
                        HomePhone = model.HomePhone,
                        OfficePhone = model.OfficePhone,
                        CityId = model.CityId,
                        Address = model.Address,
                        IsActive = model.IsActive
                    });

                    if (vehicle.Id != null)
                        return RedirectToAction("Index");
                }

                model.States = locationDB.GetStates().Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
                model.Cities = locationDB.GetCities(model.StateId).Select(s => new SelectListItem { Value = s.Id.ToString(), Text = s.Name }).ToList();
            }
            catch (Exception ex)
            {
                //loglanmalı
            }
            

            return View(model);
        }
        
        [HttpGet]
        public JsonResult States()
        {
            var model = new List<State>();
            try
            {
                model = locationDB.GetStates();
            }
            catch (Exception ex)
            {
                //loglama
            }

            return Json(model);
        }
        
        [HttpPost("[controller]/Cities/{id}")]
        public JsonResult Cities(int id)
        {
            var model = new List<City>();
            try
            {
                model = locationDB.GetCities(id);
            }
            catch (Exception ex)
            {
                //loglama
            }

            return Json(model);
        }

        [HttpGet]
        public JsonResult SearchCustomerByName(string term)
        {
            var model = new object();
            try
            {
                model = customerDB.List(new Customer { FirstName = term, IsActive = true })
                .Select(s => new
                {
                    value = $"{s.FirstName} {s.LastName} | {s.Mobile}",
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