package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;

public interface UserService {
    User login(User user);

    ResultVo verifyOldPwd(User user, String oldPwd);

    ResultVo updateMessage(User user);
}
