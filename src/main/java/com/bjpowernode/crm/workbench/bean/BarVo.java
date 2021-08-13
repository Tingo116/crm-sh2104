package com.bjpowernode.crm.workbench.bean;

import lombok.Data;

import java.util.List;

//柱状图数据
@Data
public class BarVo {
    private List<String> titles;//柱状图的下面的名称的集合
    private List<Integer>  accounts; //柱状图显示的数据的集合


    private String title;
    private Integer num;


}
