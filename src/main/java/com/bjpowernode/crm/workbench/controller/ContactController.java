package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.ContactsRemark;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.service.ContactService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class ContactController {
    @Autowired
    private ContactService contactService;

    @RequestMapping("/workbench/contacts/list")
    @ResponseBody
    public PageInfo<Contacts> list(Contacts contacts, Integer page, Integer pageSize) {
        PageInfo<Contacts> pageInfo = contactService.list(page, pageSize, contacts);
        return pageInfo;
    }


    //自动补全功能   没有该客户时要创建新的客户
    @RequestMapping("/workbench/contact/queryCustomerNames")
    @ResponseBody
    public List<String> queryCustomerNames(String customerName, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<String> customerNames = contactService.queryCustomerNames(customerName, user);
        return customerNames;
    }

    //点击添加或者修改  保存信息
    @RequestMapping("/workbench/contact/saveOrUpdateContact")
    @ResponseBody
    public ResultVo saveOrUpdateContact(Contacts contacts, HttpSession session) {
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            resultVo = contactService.saveOrUpdateContact(contacts, user);
            resultVo.setOk(true);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //查询联系人信息
    @RequestMapping("/workbench/contact/queryContact")
    @ResponseBody
    public Contacts queryContact(String id) {
        Contacts contact = contactService.queryContact(id);
        return contact;
    }

    //批量删除联系人
    @RequestMapping("/workbench/contact/deleteContacts")
    @ResponseBody
    public ResultVo deleteContacts(String ids) {
        ResultVo resultVo = new ResultVo();
        try {
            contactService.deleteContacts(ids);
            resultVo.setOk(true);
            resultVo.setMess("删除成功！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //点进详情页
    @RequestMapping("/workbench/contact/toDetail")
    @ResponseBody
    public Contacts toDetail(String id) {
        Contacts contacts = contactService.toDetail(id);
        return contacts;
    }
    // 备注的添加
    @RequestMapping("/workbench/contacts/addRemark")
    @ResponseBody
    public ResultVo addRemark(ContactsRemark contactsRemark, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            contactsRemark = contactService.addRemark(contactsRemark,user);
            resultVo.setOk(true);
            resultVo.setT(contactsRemark);
            resultVo.setMess("添加联系人备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }






}
