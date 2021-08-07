package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Clue;
import com.bjpowernode.crm.workbench.bean.ClueRemark;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface ClueService {
    PageInfo<Clue> list(Integer page, Integer pageSize, Clue clue);

    Clue toDetail(String id);

    ClueRemark addClueRemark(ClueRemark clueRemark, User user);

    void deleteRemark(String id);

    List<Activity> queryActivity(String id);

    PageInfo<Activity> queryUnbindActivity(String id, String activityName, Integer page, Integer pageSize);

    void bind(String id, String ids);

    void unbind(String id, String aid);

    Clue queryInfo(String id);

    List<Activity> queryBindActivities(String id, String activityName);

    void convert(String id, String isTransaction, Transaction transaction, User user);

    void saveClue(Clue clue, User user);

    void deleteClue(String ids);

    Clue queryClueById(String id);

    void updateClue(Clue clue, User user);
}
