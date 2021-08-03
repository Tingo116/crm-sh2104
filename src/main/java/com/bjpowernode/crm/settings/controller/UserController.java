package com.bjpowernode.crm.settings.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.FileUploadUtil;
import com.bjpowernode.crm.base.util.MD5Util;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class UserController {
    //注入service层
    @Autowired
    private UserService userService;

    //发送登录请求
    @RequestMapping("/settings/user/login")
    @ResponseBody
    public ResultVo login(HttpServletRequest request, User user, HttpSession session){
        ResultVo resultVo = new ResultVo();
        //获取登录的ip
        try {
            String remoteAddr = request.getRemoteAddr();
            //放进user中  用于业务层的判断
            user.setAllowIps(remoteAddr);
            //业务层判断
            user = userService.login(user);
            resultVo.setOk(true);
            //将用户信息存放进session中   用于页面获取用户信息  比如用户名称显示等
            session.setAttribute("user",user);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //登录成功  跳转页面
    @RequestMapping("/settings/user/toIndex")
    public String toIndex(){
        return "workbench/index";
    }

    //退出登录功能的实现
    @RequestMapping("/settings/user/loginOut")
    public String loginOut(HttpSession session){
        //清除session中用户信息
        session.removeAttribute("user");
        //重定向到login.jsp
        return "redirect:/login.jsp";
    }
    //修改密码时   异步校验原始密码是否正确
    @RequestMapping("/settings/user/verifyOldPwd")
    @ResponseBody
    public ResultVo verifyOldPwd(String oldPwd, HttpSession session){
        ResultVo resultVo = new ResultVo();
        //获取登录的ip
        try {
            User user = (User) session.getAttribute("user");
            //业务层判断
            resultVo = userService.verifyOldPwd(user,oldPwd);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //上传用户头像  由于还要获取头像地址   这里要获取项目名称  用到的是request中的方法
    // 所以这里的session要换成request

    //参数与前台传参一致
 /*   public ResultVo fileUpload(MultipartFile file1, HttpSession session){
        ResultVo resultVo = FileUploadUtil.fileUpload(file1,session);
        return resultVo;
    }*/
    @RequestMapping("/settings/user/fileUpload")
    @ResponseBody
    public ResultVo fileUpload(MultipartFile file1, HttpServletRequest request){
        ResultVo resultVo = FileUploadUtil.fileUpload(file1,request);
        return resultVo;
    }

    //更新密码和头像
    //后台用的是一个用户对象接收的数据  还需要从session中获取用户的id
    @RequestMapping("/settings/user/updateMessage")
    @ResponseBody
    public ResultVo updateMessage(User user,HttpSession session ){
        ResultVo resultVo = new ResultVo();
        try {
            //从session中获取用户的主键  业务层要根据主键来更新
            User oldUser = (User) session.getAttribute("user");
            //将主键设置到传入的用户
            user.setId(oldUser.getId());
            //将前台传过来的密码进行加密 这一步应该放到业务层吗？？？
            user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
            resultVo = userService.updateMessage(user);
            resultVo.setOk(true);

        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }


}
