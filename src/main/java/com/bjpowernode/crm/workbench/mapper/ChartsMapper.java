package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.bean.BarVo;
import com.bjpowernode.crm.workbench.bean.PieVo;

import java.util.List;

public interface ChartsMapper {

    List<BarVo> tranBarChart();

    List<PieVo> tranPieChart();

    List<BarVo> ActivityBarChart();

    List<PieVo> activityPieChart();

    List<BarVo> clueBarChart();

    List<PieVo> cluePieChart();
}
