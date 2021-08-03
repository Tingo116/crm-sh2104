package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Table(name = "tbl_clue")
@NameStyle(Style.normal)
public class Clue {
    @Id
    private String id;
    private String fullname;//联系人全名
    private String appellation;//联系人称呼
    private String owner;//所有者
    private String company;//客户名称
    private String job;//联系人工作
    private String email;
    private String phone;//公司的座机
    private String website;
    private String mphone;//联系人电话
    private String state;//状态
    private String source;//来源
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String description;
    private String contactSummary;
    private String nextContactTime;
    private String address;//公司地址
}
