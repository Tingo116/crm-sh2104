package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
public class CustomerController {
    @Autowired
    private CustomerService customerService;

    @RequestMapping("/workbench/customer/list")
    @ResponseBody
    public PageInfo<Customer> list(Integer page, Integer pageSize, Customer customer){
        PageInfo<Customer> pageInfo = customerService.list(page,pageSize,customer);
        return pageInfo;
    }
    //客户删除
    @RequestMapping("/workbench/customer/delete")
    @ResponseBody
    public ResultVo delete(String ids){
        ResultVo resultVo = new ResultVo();
        try {
            customerService.delete(ids);
            resultVo.setOk(true);
            resultVo.setMess("删除用户信息成功！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }


    @RequestMapping("/workbench/customer/saveOrUpdate")
    @ResponseBody
    public ResultVo saveOrUpdate(Customer customer,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            resultVo =customerService.saveOrUpdate(customer,user);
            resultVo.setOk(true);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }
    //查询客户信息
    @RequestMapping("/workbench/customer/queryCustomer")
    @ResponseBody
    public Customer queryCustomer(String id){
       Customer customer =customerService.queryCustomer(id);
        return customer;
    }

//    ============================详情页业务======================================
    //显示详情页  返回客户信息
    @RequestMapping("/workbench/customer/toDetail")
    @ResponseBody
    public Customer toDetail(String id){
        //region Description
        Customer customer =customerService.toDetail(id);
        return customer;
    }

    //备注的添加

    @RequestMapping("/workbench/customer/addRemark")
    @ResponseBody
    public ResultVo addRemark(CustomerRemark customerRemark, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            resultVo =customerService.addRemark(customerRemark,user);
            resultVo.setOk(true);
            resultVo.setMess("添加客户备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //备注的删除
    @RequestMapping("/workbench/customer/deleteCustomerRemark")
    @ResponseBody
    public ResultVo deleteCustomerRemark(String id){
        ResultVo resultVo = new ResultVo();
        try {
            customerService.deleteCustomerRemark(id);
            resultVo.setOk(true);
            resultVo.setMess("删除客户备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }






}
