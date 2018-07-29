using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RentCar.Web.Models.CustomerViewModels
{
    public class CustomerViewModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Caption { get; set; }
        public string IdentityNumber { get; set; }
        public DateTime Birthdate { get; set; }
        public Gender Gender { get; set; }
        public string TaxNumber { get; set; }
        public string TaxOffice { get; set; }

        public string Mobile { get; set; }
        public string HomePhone { get; set; }
        public string OfficePhone { get; set; }

        public string State { get; set; }
        public string City { get; set; }
        public string Address { get; set; }

        public bool IsActive { get; set; }
    }
}
