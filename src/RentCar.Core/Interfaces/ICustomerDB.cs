using RentCar.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace RentCar.Core.Interfaces
{
    public interface ICustomerDB
    {
        Customer Get(Customer customer);
        Customer AddOrUpdate(Customer customer);
        List<Customer> List(Customer customer);
        bool Delete(int id);
    }
}
