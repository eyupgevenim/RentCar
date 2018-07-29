using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using RentCar.Core.Services;
using RentCar.Web.Models.AccountViewModels;

namespace RentCar.Web.Controllers
{
    public class AccountController : BaseController
    {
        private readonly IUserDB userDb;
        private readonly ISignInManager signInManager;
        public AccountController(IUserDB userDb, ISignInManager signInManager)
        {
            this.userDb = userDb;
            this.signInManager = signInManager;
        }

        [HttpGet]
        [AllowAnonymous]
        public IActionResult Login(string returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model, string returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            if (ModelState.IsValid)
            {
                var user = userDb.Get(new User { UserName = model.UserName });
                if (user == null)
                {
                    ViewData["Message"] = "Kullanıcı adı yanlış! ";
                    return View(model);
                }
                
                if (signInManager.GetClaimsPrincipal(model.UserName, model.Password, 
                    user, out ClaimsPrincipal principal))
                {
                    await HttpContext.SignInAsync(principal);
                    return RedirectToLocal(returnUrl);
                }
                else
                {
                    ViewData["Message"] = "Yanlış şifre! ";
                }
            }
            
            return View(model);
        }

        [HttpGet]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Login");
        }
        

        #region Helpers
        
        private IActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
                return Redirect(returnUrl);

            return Redirect("/");
        }

        #endregion

    }
}