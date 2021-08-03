package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.base.bean.BarVo;
import com.bjpowernode.crm.base.bean.PieVo;

import java.util.List;

public interface ChartsMapper {

    List<BarVo> barVoEcharts();

    List<PieVo> transactionPieEcharts();
}
