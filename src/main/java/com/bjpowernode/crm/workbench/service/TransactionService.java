package com.bjpowernode.crm.workbench.service;

import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.bean.TransactionRemark;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    PageInfo<Transaction> list(Integer page, Integer pageSize, Transaction transaction);

    Transaction toDetail(String id);

    Transaction queryTransaction(String id);

    void updateTran(Transaction transaction, User user);

    List<Activity> queryActivity(String name);

    List<Contacts> queryContacts(String name);

    ResultVo stageList(String id, Integer position, User user, Map<String, String> stage2Possibility);

    TransactionRemark addRemark(TransactionRemark transactionRemark, User user);

    void addTran(Transaction transaction, User user);

    ExcelWriter exportExcel(ExcelWriter writer);
}
