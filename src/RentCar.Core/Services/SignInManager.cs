using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.AspNetCore.Http;
using RentCar.Core.Interfaces;
using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace RentCar.Core.Services
{
    public class SignInManager : ISignInManager
    {
        public bool GetClaimsPrincipal(string userName, string password, 
            User user, out ClaimsPrincipal principal)
        {
            principal = new ClaimsPrincipal();
            if (userName == user.UserName && ValidatePassword(password, user.Salt, user.Password))
            {
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Sid, user.Id.ToString()),
                    new Claim(ClaimTypes.Name, user.UserName)
                };
                var userIdentity = new ClaimsIdentity(claims, "login");
                principal.AddIdentity(userIdentity);
                
                return true;
            }

            return false;
        }

        /// <summary>
        /// Salt oluşturma ve şifreyi crptolama
        /// </summary>
        /// <param name="password"></param>
        /// <returns>
        /// Tuple<string, string>(password, salt)
        /// </returns>
        public Tuple<string, string> CreadHashedUser(string password)
        {
            string salt = CreateSalt();
            string hashedPassword = HashedPassword(password, salt);
            return new Tuple<string, string>(hashedPassword, salt);
        }

        private string HashedPassword(string password, string salt)
        => Convert.ToBase64String(KeyDerivation.Pbkdf2(
            password: password,
            salt: Encoding.UTF8.GetBytes(salt),
            prf: KeyDerivationPrf.HMACSHA1,
            iterationCount: 10000,
            numBytesRequested: 256 / 8));

        private bool ValidatePassword(string password, string salt, string hashedPassword)
            => HashedPassword(password, salt) == hashedPassword;

        private string CreateSalt()
        {
            byte[] salt = new byte[128 / 8];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            return Convert.ToBase64String(salt);
        }
    }
}
