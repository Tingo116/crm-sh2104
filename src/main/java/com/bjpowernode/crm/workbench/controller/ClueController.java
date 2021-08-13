package com.bjpowernode.crm.workbench.controller;

import cn.hutool.core.io.IoUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Clue;
import com.bjpowernode.crm.workbench.bean.ClueRemark;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.service.ClueService;
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

@Controller
public class ClueController {
    @Autowired
    private ClueService clueService;

    //刷新列表的方法
    @RequestMapping("/workbench/clue/list")
    @ResponseBody
    public PageInfo<Clue> list(Clue clue, Integer page, Integer pageSize) {
        PageInfo<Clue> pageInfo = clueService.list(page, pageSize, clue);
        return pageInfo;
    }

    //显示详情页
    @RequestMapping("/workbench/clue/toDetail")
    @ResponseBody
    public Clue toDetail(String id) {
        Clue clue = clueService.toDetail(id);
        return clue;
    }

    //添加备注
    @RequestMapping("/workbench/clue/addClueRemark")
    @ResponseBody
    public ResultVo addClueRemark(ClueRemark clueRemark, HttpSession session) {
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            clueRemark = clueService.addClueRemark(clueRemark, user);
            resultVo.setOk(true);
            resultVo.setT(clueRemark);
            resultVo.setMess("添加线索备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }


    //删除备注

    @RequestMapping("/workbench/clue/deleteRemark")
    @ResponseBody
    public ResultVo deleteRemark(String id) {
        ResultVo resultVo = new ResultVo();
        try {
            clueService.deleteRemark(id);
            resultVo.setOk(true);
            resultVo.setMess("删除线索备注成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //显示详情页的市场活动
    @RequestMapping("/workbench/clue/queryActivity")
    @ResponseBody
    public List<Activity> queryActivity(String id) {
        List<Activity> activities = clueService.queryActivity(id);
        return activities;
    }

    //查询线索没绑定的市场活动  加入分页试试
    @RequestMapping("/workbench/clue/queryUnbindActivity")
    @ResponseBody
    public PageInfo<Activity> queryUnbindActivity(String id, String activityName, Integer page, Integer pageSize) {
        PageInfo<Activity> activities = clueService.queryUnbindActivity(id, activityName, page, pageSize);
        return activities;
    }

    //绑定市场活动
    @RequestMapping("/workbench/clue/bind")
    @ResponseBody
    public ResultVo bind(String id, String ids) {
        ResultVo resultVo = new ResultVo();
        try {
            clueService.bind(id, ids);
            resultVo.setOk(true);
            resultVo.setMess("绑定市场活动成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //解除绑定
    @RequestMapping("/workbench/clue/unbind")
    @ResponseBody
    public ResultVo unbind(String id, String aid) {
        ResultVo resultVo = new ResultVo();
        try {
            clueService.unbind(id, aid);
            resultVo.setOk(true);
            resultVo.setMess("解除市场活动绑定成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //点击转换   查询线索线索信息  查询联系人信息
    @RequestMapping("/workbench/clue/queryInfo")
    @ResponseBody
    public Clue queryInfo(String id) {
        Clue clue = clueService.queryInfo(id);
        return clue;
    }

    //点击查询按钮   查询绑定的市场活动
    @RequestMapping("/workbench/clue/queryBindActivities")
    @ResponseBody
    public List<Activity> queryBindActivities(String id, String activityName) {
        List<Activity> activities = clueService.queryBindActivities(id, activityName);
        return activities;
    }

    //线索的转换
    @RequestMapping("/workbench/clue/convert")
    @ResponseBody
    public ResultVo convert(String id, String isTransaction, Transaction transaction, HttpSession httpSession) {
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) httpSession.getAttribute("user");
            clueService.convert(id, isTransaction, transaction, user);
            resultVo.setOk(true);
            resultVo.setMess("线索转换成功！！！");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    @RequestMapping("/workbench/clue/saveClue")
    @ResponseBody
    public ResultVo saveClue(Clue clue, HttpSession session) {
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            clueService.saveClue(clue, user);
            resultVo.setOk(true);
            resultVo.setMess("添加线索成功");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //删除线索
    @RequestMapping("/workbench/clue/deleteClue")
    @ResponseBody
    public ResultVo deleteClue(String ids) {
        ResultVo resultVo = new ResultVo();
        try {
            clueService.deleteClue(ids);
            resultVo.setOk(true);
            resultVo.setMess("删除线索成功");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //；查询线索信息
    @RequestMapping("/workbench/clue/queryClueById")
    @ResponseBody
    public Clue queryClueById(String id) {
        Clue clue = clueService.queryClueById(id);
        return clue;
    }
    //保存修改的信息
    @RequestMapping("/workbench/clue/updateClue")
    @ResponseBody
    public ResultVo updateClue(Clue clue,HttpSession session) {
        ResultVo resultVo = new ResultVo();
        try {
            User user = (User) session.getAttribute("user");
            clueService.updateClue(clue,user);
            resultVo.setOk(true);
            resultVo.setMess("更新线索成功");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }


    //    导出报表
    @RequestMapping("/workbench/clue/exportExcel")
    public void exportExcel(HttpServletResponse response) throws IOException {
        ExcelWriter writer = ExcelUtil.getWriter(true);
        writer = clueService.exportExcel(writer);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setHeader("Content-Disposition","attachment;filename=clue.xlsx");
        ServletOutputStream outputStream = response.getOutputStream();
        writer.flush(outputStream, true);
        writer.close();
        IoUtil.close(outputStream);

    }


}
