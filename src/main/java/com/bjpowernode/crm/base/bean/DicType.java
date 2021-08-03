package com.bjpowernode.crm.base.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.util.List;

@Data
@Table(name = "tbl_dic_type")
@NameStyle(Style.normal)
public class DicType {

    @Id
    private String code;
    private String name;
    private String description;

    //加入value
    private List<DicValue> dicValues;
    //添加序号  由于页面显示序号
    @Transient
    private Integer num;

}
