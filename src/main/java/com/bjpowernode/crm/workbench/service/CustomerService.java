package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.CustomerRemark;
import com.github.pagehelper.PageInfo;

public interface CustomerService {
    PageInfo<Customer> list(Integer page, Integer pageSize, Customer customer);

    void delete(String ids);

    ResultVo saveOrUpdate(Customer customer, User user);

    Customer queryCustomer(String id);

    Customer toDetail(String id);

    ResultVo addRemark(CustomerRemark customerRemark, User user);

    void deleteCustomerRemark(String id);
}
