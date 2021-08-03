package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.ContactsRemark;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface ContactService {
    PageInfo<Contacts> list(Integer page, Integer pageSize, Contacts contacts);

    List<String> queryCustomerNames(String customerName, User user);

    ResultVo saveOrUpdateContact(Contacts contacts, User user);

    Contacts queryContact(String id);

    void deleteContacts(String ids);

    Contacts toDetail(String id);

    ContactsRemark addRemark(ContactsRemark contactsRemark, User user);

}
