package com.bjpowernode.crm.base.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Data
@Table(name = "tbl_dic_value")
@NameStyle(Style.normal)
public class DicValue {
    @Id
    private String id;
    private String value;
    private String text;
    private String orderNo;
    private String typeCode;
    @Transient
    private Integer num;
}
