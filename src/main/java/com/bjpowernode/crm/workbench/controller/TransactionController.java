package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.mapper.ContactMapper;
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class TransactionController {
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ActivityMapper activityMapper;

    @Autowired
    private ContactMapper contactMapper;
    @RequestMapping("/workbench/transaction/list")
    @ResponseBody
    public PageInfo<Transaction> list(Integer page,Integer pageSize,Transaction transaction){
        PageInfo<Transaction> pageInfo = transactionService.list(page,pageSize,transaction);
            return pageInfo;
        }

        //跳转到详情页
    @RequestMapping("/workbench/transaction/toDetail")
    @ResponseBody
    public Transaction toDetail(String id){
        Transaction transaction = transactionService.toDetail(id);
        return transaction;
    }

    //查询交易信息

    @RequestMapping("/workbench/transaction/queryTransaction")
    @ResponseBody
    public Transaction queryTransaction(String id){
        Transaction transaction = transactionService.queryTransaction(id);
        return transaction;
    }

    @RequestMapping("/workbench/transaction/updateTran")
    @ResponseBody
    public ResultVo updateTran(Transaction transaction, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            transactionService.updateTran(transaction,user);
            resultVo.setOk(true);
            resultVo.setMess("更新交易成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }
    @RequestMapping("/workbench/transaction/queryActivities")
    @ResponseBody
    public List<Activity> queryActivities(String name) {
        List<Activity> activities = transactionService.queryActivity(name);
        return activities;
    }

    @RequestMapping("/workbench/transaction/queryContacts")
    @ResponseBody
    public List<Contacts> queryContacts(String name) {
        List<Contacts> contacts = transactionService.queryContacts(name);
        return contacts;
    }


}
