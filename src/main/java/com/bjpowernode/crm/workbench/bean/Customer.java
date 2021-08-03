package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.io.Serializable;
import java.util.List;

@Data
@Table(name = "tbl_customer")
@NameStyle(Style.normal)
public class Customer implements Serializable {
    @Id
    private String id;
    private String owner;
    private String name;
    private String website;
    private String phone;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String contactSummary;
    private String nextContactTime;
    private String description;
    private String address;

    @Transient
    private String contactsRemark;

    //查询备注  添加字段
    private List<CustomerRemark> customerRemarks;

}
