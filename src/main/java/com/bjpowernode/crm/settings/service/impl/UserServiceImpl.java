package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.MD5Util;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User login(User user) {
        String ip = user.getAllowIps();
        //将获取到的用户密码进行加密后
        String md5 = MD5Util.getMD5(user.getLoginPwd());
        user.setLoginPwd(md5);
        //先判断用户名和密码是否正确   再判断ip  是否被锁定等
        //这里是怎么判断用户名与密码是否正确   不是直接比较
        //而是通过拼接条件   查询用户    如果有这个用户  则说明正确
        //拼接条件
        Example example = new Example(User.class);
        example.createCriteria().andEqualTo("loginPwd",user.getLoginPwd())
                .andEqualTo("loginAct",user.getLoginAct());
        List<User> users = userMapper.selectByExample(example);

        //判断查询出来的user的个数
        if (users.size() == 0){
            //抛异常
            throw new CrmException(CrmEnum.LOGIN_ACCOUNT);
        }else {
            //到这里说明已经查出了用户  而且只有一个用户  那么取出用户  将原来的用户覆盖
           user = users.get(0);
            //还要判断是否时间是否过期 是否是被允许的登录的ip   是否被锁定等
            //1.判断账号是否过期  分别获取当前时间  和  允许登录的时间
            String nowTime = DateTimeUtil.getSysTime();
            String loginTime = user.getExpireTime();
            if (nowTime.compareTo(loginTime) > 0){
                throw new CrmException(CrmEnum.LOGIN_EXPIRE);
            }

            //判断是否被锁定
            if ("0".equals(user.getLockState())){
                throw new CrmException(CrmEnum.LOGIN_EXPIRE);
            }

            //判断是否是允许登录的IP  如果查询出来的ip  不包括用户的ip  不允许登录
            if (!user.getAllowIps().contains(ip)){
                throw new CrmException(CrmEnum.LOGIN_ALLOW_IP);
            }
        }
        return user;
    }

    //异步校验原始密码是否正确
    @Override
    public ResultVo verifyOldPwd(User user, String oldPwd) {
        ResultVo resultVo = new ResultVo();
        oldPwd = MD5Util.getMD5(oldPwd);
        if (!user.getLoginPwd().equals(oldPwd)){
            throw new CrmException(CrmEnum.LOGIN_VERIFY_PWD);
        }
        resultVo.setOk(true);
        return resultVo;
    }

    //更新用户头像和密码
    @Override
    public ResultVo updateMessage(User user) {
        ResultVo resultVo = new ResultVo();
        int i = userMapper.updateByPrimaryKeySelective(user);
        if (i == 0){
            throw new CrmException(CrmEnum.UPDATE_PWD);
        }
        resultVo.setT(true);
        resultVo.setMess("更新密码和头像成功");
        return resultVo;
    }
}
