package com.bjpowernode.crm.base.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.Enumeration;

//用于统一视图的跳转
@Controller
public class ViewController {
    //这里可以进行多个视图的跳转
//    @PathVariable(value = "firstView",required = false)   这里的参数名称参数要与前面的传过来的参数一样
    //String  后面的参数名称可以不同
    //但是  前面的注解必须相同
    @RequestMapping(value = {"/toView/{firstView}/{secondView}", "/toView/{firstView}/{secondView}/{thirdView}",
            "/toView/{firstView}/{secondView}/{thirdView}/{fourthView}"})
    public String toView(@PathVariable(value = "firstView",required = false) String firstView,
                         @PathVariable(value = "secondView",required = false)String secondView,
                         @PathVariable(value = "thirdView",required = false)String thirdView,
                         @PathVariable(value = "fourthView",required = false)String fourthView,
                         HttpServletRequest request){

        //将前台传过来的参数  进行遍历  并存放进request域中  所以上面的参数  还需要request域
        Enumeration parameterNames = request.getParameterNames();
        //枚举类型  可以遍历出来
        while (parameterNames.hasMoreElements()){
            String name = (String) parameterNames.nextElement();
            //根据名字获取键值
            String value = request.getParameter(name);
            //放进域中
            request.setAttribute(name,value);
        }


        //最少是二级路径   所有从三级路径开始往下判断
        if (thirdView == null){
            return firstView + File.separator + secondView;
        }
        //四级目录为空  只需要返回 三级路径
        if (fourthView == null){
            return firstView + File.separator + secondView + File.separator + thirdView;
        }
        //走到这里   有四级目录   返回四级目录
        return firstView + File.separator + secondView + File.separator + thirdView + File.separator + fourthView;
    }

}
