package com.bjpowernode.crm.base.interceptor;

import com.bjpowernode.crm.settings.bean.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        //登录请求也要放行
        String url = request.getRequestURI();

        if(url.contains("login")){
            return true;
        }

        User user = (User) request.getSession().getAttribute("user");
        if(user == null){
            //重定向到登录页面
            response.sendRedirect("/crm/login.jsp");
            return false;
        }

        return true;
    }
}
