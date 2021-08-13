package com.bjpowernode.crm.workbench.controller;


import cn.hutool.core.io.IoUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Controller
public class activityController {
    @Autowired
    private ActivityService activityService;
    //查询显示列表的方法
    @RequestMapping("/workbench/activity/list")
    @ResponseBody
    public PageInfo<Activity> list(Integer page, Integer pageSize, Activity activity){
        PageInfo<Activity> pageInfo = activityService.list(page, pageSize, activity);
        return pageInfo;
    }
    //点击更新或者添加按钮
    @RequestMapping("/workbench/activity/addOrUpdateActivity")
    @ResponseBody
    public ResultVo addOrUpdateActivity(Activity activity, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            resultVo = activityService.addOrUpdateActivity(activity,user);
            resultVo.setOk(true);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }


    //=====批量删除功能===============
    @RequestMapping("/workbench/activity/deleteActivity")
    @ResponseBody
    public ResultVo deleteActivity(String ids){
        ResultVo resultVo = new ResultVo();
        try {
            resultVo = activityService.deleteActivity(ids);
            resultVo.setOk(true);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //查询市场活动
    @RequestMapping("/workbench/activity/queryActivity")
    @ResponseBody
    public Activity queryActivity(String id){
       Activity activity = activityService.queryActivity(id);
       return activity;
    }

    //市场活动详情页=======================================
    @RequestMapping("/workbench/activity/toDetail")
    @ResponseBody
    public Activity toDetail(String id){
        Activity activity = activityService.toDetail(id);
        return activity;
    }

    //市场活动备注的添加
    @RequestMapping("/workbench/activity/addRemark")
    @ResponseBody
    public ResultVo addRemark(ActivityRemark activityRemark,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
           activityRemark = activityService.addRemark(activityRemark,user);
            resultVo.setOk(true);
            resultVo.setT(activityRemark);
            resultVo.setMess("添加市场活动备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }
    //市场活动备注的删除
    @RequestMapping("/workbench/activity/deleteRemark")
    @ResponseBody
    public ResultVo deleteRemark(String id){
        ResultVo resultVo = new ResultVo();
        try {
            activityService.deleteRemark(id);
            resultVo.setOk(true);
            resultVo.setMess("删除市场活动备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //备注的编辑修改

    @RequestMapping("/workbench/activity/updateRemark")
    @ResponseBody
    public ResultVo updateRemark(ActivityRemark activityRemark,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
           activityService.updateRemark(activityRemark,user);
            resultVo.setOk(true);
            resultVo.setMess("修改市场活动备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }



        //    导出报表
        @RequestMapping("/workbench/activity/exportExcel")
        public void exportExcel(HttpServletResponse response) throws IOException {
            ExcelWriter writer = ExcelUtil.getWriter(true);
            writer = activityService.exportExcel(writer);

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
            response.setHeader("Content-Disposition","attachment;filename=activityExcel.xlsx");
            ServletOutputStream outputStream = response.getOutputStream();
            writer.flush(outputStream, true);
            writer.close();
            IoUtil.close(outputStream);

        }





}
