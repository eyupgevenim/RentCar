using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Models
{
    public class Customer
    {
        public int? Id { get; set; }
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

        public int CityId { get; set; }
        public City City { get; set; }

        public int StateId { get; set; }
        public State State { get; set; }

        public string Address { get; set; }

        public bool? IsActive { get; set; }
    }

    public enum Gender
    {
        Erkek = 1,
        Kadın = 2
    }
}
