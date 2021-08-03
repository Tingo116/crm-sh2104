package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Data
@Table(name = "tbl_customer_remark")
@NameStyle(Style.normal)
public class CustomerRemark {
    @Id
    private String id;
    private String noteContent;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String editFlag;
    private String customerId;
    @Transient
    private String img;

    //显示联系人 和名称
    @Transient
    private String contactName;
    @Transient
    private String contactAppellation;

    @Transient
    private String name;
}
