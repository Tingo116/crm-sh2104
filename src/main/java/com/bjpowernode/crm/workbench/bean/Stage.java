package com.bjpowernode.crm.workbench.bean;

import lombok.Data;

@Data
public class Stage {
//    这是交易阶段 用来显示交易进度条的  根据

    private String type;//交易图标类型 绿圈、黑圈
    private String content;//交易图标上的文本内容
    private String possibility;//交易可能性
    //为点击交易进度条修改交易进行阶段服务  获取阶段
    private String position;
}
