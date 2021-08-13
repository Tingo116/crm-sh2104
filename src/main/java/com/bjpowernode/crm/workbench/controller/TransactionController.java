package com.bjpowernode.crm.workbench.controller;

import cn.hutool.core.io.IoUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.*;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.mapper.ContactMapper;
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

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

    //根据交易状态  查询可能性
    @RequestMapping("/workbench/transaction/bindPossibility")
    @ResponseBody
    public String bindPossibility(String stage,HttpSession session){
        Map<String,String> stage2Possibilities = (Map<String, String>) session.getServletContext().getAttribute("stage2Possibility");
        return stage2Possibilities.get(stage);
    }

    //显示交易阶段进度
    @RequestMapping("/workbench/transaction/stageList")
    @ResponseBody
    public ResultVo stageList(String id,Integer position,HttpSession session){
        User user = (User) session.getAttribute("user");
        Map<String,String> stage2Possibility = (Map<String, String>) session.getServletContext().getAttribute("stage2Possibility");
        ResultVo resultVo = transactionService.stageList(id, position, user, stage2Possibility);
        return resultVo;
    }


    //备注的添加
    @RequestMapping("/workbench/transaction/saveRemark")
    @ResponseBody
    public ResultVo addRemark(TransactionRemark transactionRemark, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            transactionRemark = transactionService.addRemark(transactionRemark,user);
            resultVo.setOk(true);
            resultVo.setT(transactionRemark);
            resultVo.setMess("添加交易备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    @RequestMapping("/workbench/transaction/addTran")
    @ResponseBody
    public ResultVo addTran(Transaction transaction, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            transactionService.addTran(transaction,user);
            resultVo.setOk(true);
            resultVo.setMess("添加交易成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //    导出报表
    @RequestMapping("/workbench/transaction/exportExcel")
    public void exportExcel(HttpServletResponse response) throws IOException {
        ExcelWriter writer = ExcelUtil.getWriter(true);
        writer = transactionService.exportExcel(writer);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setHeader("Content-Disposition","attachment;filename=transaction.xlsx");
        ServletOutputStream outputStream = response.getOutputStream();
        writer.flush(outputStream, true);
        writer.close();
        IoUtil.close(outputStream);

    }
}
