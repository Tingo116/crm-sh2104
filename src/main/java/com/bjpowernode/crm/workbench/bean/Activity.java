package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.util.List;

@Data
@Table(name = "tbl_activity")
@NameStyle(Style.normal)
public class Activity {

    @Id
    private String id;
    private String owner;//所有者 用户的外键
    private String name;//名称
    private String startDate;//开发时间
    private String endDate;//结束时间
    private String cost;
    private String description;//描述
    private String createTime;//创建时间
    private String createBy;//创建者
    private String editTime;
    private String editBy;

    //添加备注字段  并且是一个集合
    private List<ActivityRemark> activityRemarks;



}
