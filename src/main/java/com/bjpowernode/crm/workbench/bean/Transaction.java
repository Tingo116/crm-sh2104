package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.util.List;


@Data
@Table(name = "tbl_tran")
@NameStyle(Style.normal)
public class Transaction {

    @Id
    private String id;
    private String owner;
    private String money;
    private String name;
    private String expectedDate;
    private String customerId;
    private String stage;
    private String possibility;
    private String type;
    private String source;
    private String activityId;
    private String contactsId;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String description;
    private String contactSummary;
    private String nextContactTime;

    @Transient
    private String activityName;

    @Transient
    private String contactName;

    @Transient
    private List<TransactionRemark> transactionRemarks;
    @Transient
    private List<TransactionHistory> transactionHistories;

}
