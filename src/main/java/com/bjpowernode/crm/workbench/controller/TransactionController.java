package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TransactionController {
    @Autowired
    private TransactionService transactionService;
    @RequestMapping("/workbench/transaction/list")
    @ResponseBody
    public PageInfo<Transaction> list(Integer page,Integer pageSize,Transaction transaction){
        PageInfo<Transaction> pageInfo = transactionService.list(page,pageSize,transaction);
            return pageInfo;
        }

}
