package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface TransactionService {
    PageInfo<Transaction> list(Integer page, Integer pageSize, Transaction transaction);

    Transaction toDetail(String id);

    Transaction queryTransaction(String id);

    void updateTran(Transaction transaction, User user);

    List<Activity> queryActivity(String name);

    List<Contacts> queryContacts(String name);
}
