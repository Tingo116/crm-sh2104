package com.bjpowernode.crm.workbench.service;

import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.ActivityRemark;
import com.github.pagehelper.PageInfo;

public interface ActivityService {
    PageInfo<Activity> list(Integer page, Integer pageSize, Activity activity);

    ResultVo addOrUpdateActivity(Activity activity, User user);

    ResultVo deleteActivity(String ids);

    Activity queryActivity(String id);

    Activity toDetail(String id);

    ActivityRemark addRemark(ActivityRemark activityRemark, User user);

    void deleteRemark(String id);

    void updateRemark(ActivityRemark activityRemark, User user);

    ExcelWriter exportExcel(ExcelWriter writer);
}
