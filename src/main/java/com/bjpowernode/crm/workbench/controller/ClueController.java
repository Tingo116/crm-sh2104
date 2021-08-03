package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Clue;
import com.bjpowernode.crm.workbench.mapper.ClueMapper;
import com.bjpowernode.crm.workbench.mapper.ContactMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ClueController {
    @Autowired
    private ClueService clueService;
    //刷新列表的方法
    @RequestMapping("/workbench/clue/list")
    @ResponseBody
    public PageInfo<Clue> list(Clue clue,Integer page,Integer pageSize){
        PageInfo<Clue> pageInfo = clueService.list(page, pageSize, clue);
        return pageInfo;
    }




}
