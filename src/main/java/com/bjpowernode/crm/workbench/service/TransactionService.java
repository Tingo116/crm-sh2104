package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.bean.Transaction;
import com.github.pagehelper.PageInfo;

public interface TransactionService {
    PageInfo<Transaction> list(Integer page, Integer pageSize, Transaction transaction);

}
