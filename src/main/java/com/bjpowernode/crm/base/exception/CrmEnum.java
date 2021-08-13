package com.bjpowernode.crm.base.exception;

import lombok.Data;

//枚举类  自定义类型
//便于统一管理

public enum CrmEnum{
    /**
     * 001:用户模块
     * 001-001
     * 001-002
     * 002:市场活动模块
     * 003:客户模块
     * 004：线索模块
     * 005:交易模块
     * 006:联系人模块
     * 007:字典表模块
     */
    LOGIN_ACCOUNT("001-001","用户名或密码错误"),
    LOGIN_EXPIRE("001-002","账号失效了"),
    LOGIN_LOCKED("001-003","账号被锁定，请联系管理员"),
    LOGIN_ALLOW_IP("001-004","不允许登录的IP"),
    LOGIN_VERIFY_PWD("001-005","原始密码输入不正确"),
    UPDATE_PWD("001-006","修改密码失败"),
    UPLOAD_SUFFIX("001-006","只能上传jpg,png,webp,bmp,gif,jpeg类型文件"),
    UPLOAD_MAX_SIZE("001-007","上传文件大小必须<=2M"),
    ACTIVITY_INSERT("002-001","添加市场活动失败"),
    ACTIVITY_UPDATE("002-002","修改市场活动失败"),
    ACTIVITY_DELETE("002-003","删除市场活动失败"),
    ACTIVITY_REMARK_INSERT("002-004","添加市场活动备注失败！"),
    ACTIVITY_REMARK_UPDATE("002-005","修改市场活动备注失败！"),
    ACTIVITY_REMARK_DELETE("002-006","删除市场活动备注失败！"),
    CUSTOMER_INSERT("003-001","添加客户失败"),
    CUSTOMER_UPDATE("003-002","修改客户失败"),
    CUSTOMER_DELETE("003-003","删除客户失败"),
    CUSTOMER_REMARK_INSERT("003-004","添加客户备注失败！"),
    CUSTOMER_REMARK_UPDATE("003-005","修改客户备注失败！"),
    CUSTOMER_REMARK_DELETE("003-006","删除客户备注失败！"),
    CLUE_INSERT("004-001","添加线索失败"),
    CLUE_UPDATE("004-002","修改线索失败"),
    CLUE_DELETE("004-003","删除线索失败"),
    CLUE_CONVERT("004-004","线索转换失败"),
    CLUE_BIND("004-008","绑定市场活动失败"),
    CLUE_UNBIND("004-009","解除绑定失败"),
    CLUE_REMARK_INSERT("004-005","添加线索备注失败"),
    CLUE_REMARK_UPDATE("004-006","修改线索备注失败"),
    CLUE_REMARK_DELETE("004-007","删除线索备注失败"),
    TRAN_STAGELIST("005-001","修改交易进度失败"),
    TRAN_UPDATE("005-002","更新交易失败"),
    TRAN_DELETE("005-003","删除交易失败"),
    TRAN_INSERT("005-004","添加交易失败"),
    TRAN_REMARK_UPDATE("005-005","更新交易备注失败"),
    TRAN_REMARK_DELETE("005-006","删除交易备注失败"),
    TRAN_REMARK_INSERT("005-007","添加交易备注失败"),
    CONTACT_INSERT("006-001","添加联系人失败"),
    CONTACT_UPDATE("006-002","修改联系人失败"),
    CONTACT_DELETE("006-003","删除联系人失败"),
    CONTACT_REMARK_INSERT("006-004","添加联系人备注失败！"),
    CONTACT_REMARK_UPDATE("006-005","修改联系人备注失败！"),
    CONTACT_REMARK_DELETE("006-006","删除联系人备注失败！"),
    DICVALUE_INSERT("007-001","添加字典表值失败"),
    DICVALUE_UPDATE("007-002","修改字典表值失败"),
    DICVALUE_DELETE("007-003","删除字典表值失败"),
    DICTYPE_INSERT("008-001","添加字典类型失败"),
    DICTYPE_UPDATE("008-002","修改字典类型失败"),
    DICTYPE_DELETE("008-003","删除字典类型失败"),
    ;

    private String typeCode;//错误代码
    private String message;//错误信息

//    lombal  这里不能用   手动给出有参构造和setter  和  getter 方法
    //为什么要用枚举的get方法  因为  后面抛异常的时候需要获取异常信息
    CrmEnum(String typeCode, String message) {
        this.typeCode = typeCode;
        this.message = message;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
