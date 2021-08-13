package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.workbench.bean.BarVo;
import com.bjpowernode.crm.workbench.bean.PieVo;
import com.bjpowernode.crm.workbench.service.ChartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartController {
    @Autowired
    private ChartService chartService;


    //交易状态与数目的柱状图   这里需要返回两组数据
    //这里返回barvo对象   里面有两个集合
    @RequestMapping("/workbench/chart/tranBarChart")
    @ResponseBody
    public BarVo tranBarChart(){
       return chartService.tranBarChart();
    }

    //交易状态与数目的饼状图
    //需要名字和数值  所以可以返回list集合 里面封装的是pieVo对象
    @RequestMapping("/workbench/chart/tranPieChart")
    @ResponseBody
    public List<PieVo> tranPieChart(){
        return chartService.tranPieChart();
    }

    //交易市场活动与花费的柱状图   这里需要返回两组数据
    //这里返回barvo对象   里面有两个集合
    @RequestMapping("/workbench/chart/ActivityBarChart")
    @ResponseBody
    public BarVo ActivityBarChart(){
        return chartService.ActivityBarChart();
    }
    @RequestMapping("/workbench/chart/activityPieChart")
    @ResponseBody
    public List<PieVo> activityPieChart(){
        return chartService.activityPieChart();
    }


    @RequestMapping("/workbench/chart/clueBarChart")
    @ResponseBody
    public BarVo clueBarChart(){
        return chartService.clueBarChart();
    }
    @RequestMapping("/workbench/chart/cluePieChart")
    @ResponseBody
    public List<PieVo> cluePieChart(){
        return chartService.cluePieChart();
    }
}
