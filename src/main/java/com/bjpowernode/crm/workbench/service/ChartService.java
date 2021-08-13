package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.bean.BarVo;
import com.bjpowernode.crm.workbench.bean.PieVo;

import java.util.List;

public interface ChartService {
    BarVo tranBarChart();

    List<PieVo> tranPieChart();

    BarVo ActivityBarChart();

    List<PieVo> activityPieChart();

    BarVo clueBarChart();

    List<PieVo> cluePieChart();
}
