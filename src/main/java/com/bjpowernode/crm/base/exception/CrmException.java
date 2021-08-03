package com.bjpowernode.crm.base.exception;
//自定义异常  具体异常利用枚举
public class CrmException extends RuntimeException {
    //注入枚举类型
    private CrmEnum crmEnum;

    //调用父类方法


    public CrmException(CrmEnum crmEnum) {
        //调用枚举中获取信息的方法  覆盖获取的信息
        super(crmEnum.getMessage());
        this.crmEnum = crmEnum;
    }
}
