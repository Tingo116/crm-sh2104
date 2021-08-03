package com.bjpowernode.crm.base.bean;

import lombok.Data;

import java.util.List;

//用于统一返回信息的类
//里面有一个状态  还携带信息   后面还可以返回集合 或者任意对象
@Data
public class ResultVo<T> {
    private boolean isOk;
    private String mess;

    //将这个类定义为泛型类   设置一个泛型
    private T t;

    //定义一个集合 返回所有的查询到的数据
    private List<T> list;

}
