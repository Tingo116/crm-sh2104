package com.bjpowernode.crm.settings.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Table(name = "tbl_user")
//tkMapper默认会把实体类属性按下划线进行读取，
// 如果让实体类属性和数据库表字段一致  加@NameStyle这个注解
@NameStyle(Style.normal)
public class User {

    @Id
    private String id;
    private String loginAct;
    private String name;
    private String loginPwd;
    private String email;
    private String expireTime;
    private String lockState;
    private String deptno;
    private String allowIps;
    private String createTime;
    private String createBy;
    private String editTime;
    private String editBy;

    private String img;

}
