package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.bean.BarVo;
import com.bjpowernode.crm.workbench.bean.PieVo;
import com.bjpowernode.crm.workbench.mapper.ChartsMapper;
import com.bjpowernode.crm.workbench.service.ChartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ChartServiceImpl implements ChartService {
    @Autowired
    private ChartsMapper chartsMapper;

    //交易状态与数目的柱状图
    @Override
    public BarVo tranBarChart() {
        List<BarVo> barVos = chartsMapper.tranBarChart();
        //定义里两个集合  一个放每列的名字   一个放每组的数据
        return getBarVo(barVos);
    }


    @Override
    public List<PieVo> tranPieChart() {
        List<PieVo> pieVos = chartsMapper.tranPieChart();
        return pieVos;
    }

    //市场活动与花费的柱状图
    @Override
    public BarVo ActivityBarChart() {
       List<BarVo> barVos = chartsMapper.ActivityBarChart();
        //定义里两个集合  一个放每列的名字   一个放每组的数据
        return getBarVo(barVos);
    }

    @Override
    public List<PieVo> activityPieChart() {
        List<PieVo> pieVos = chartsMapper.activityPieChart();
        return pieVos;
    }

    @Override
    public BarVo clueBarChart() {
        List<BarVo> barVos =  chartsMapper.clueBarChart();
        return getBarVo(barVos);
    }

    public List<PieVo> cluePieChart() {
        List<PieVo> pieVos = chartsMapper.cluePieChart();
        return pieVos;
    }




    //封装一个返回柱状图的方法
    private BarVo getBarVo(List<BarVo> barVos) {
        ArrayList<String> titles = new ArrayList<>();
        ArrayList<Integer> accounts = new ArrayList<>();
        //遍历查询出来的数据  这里遍历出来的也是一个个barVo对象
        // 设置到barvo中返回
        for (BarVo barVo : barVos) {
            titles.add(barVo.getTitle());
            accounts.add(barVo.getNum());
        }
        BarVo barVo = new BarVo();
        barVo.setTitles(titles);
        barVo.setAccounts(accounts);
        return barVo;
    }
}
