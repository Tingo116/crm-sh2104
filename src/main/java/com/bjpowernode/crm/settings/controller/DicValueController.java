package com.bjpowernode.crm.settings.controller;

import com.bjpowernode.crm.base.bean.DicValue;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class DicValueController {
    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/settings/dicValue/list")
    @ResponseBody
    public PageInfo list(Integer page, Integer pageSize){
        PageInfo<DicValue> pageInfo = dicValueService.list(page,pageSize);
        return pageInfo;
    }
    //字典值的添加
    @RequestMapping("/settings/dicValue/addValue")
    @ResponseBody
    public ResultVo addValue(DicValue dicValue) {
        ResultVo resultVo = new ResultVo();
        try {
            resultVo = dicValueService.addValue(dicValue);
            resultVo.setOk(true);

        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }
    //字典表值的删除
    @RequestMapping("/settings/dicValue/delete")
    @ResponseBody
    public ResultVo delete(String ids) {
        ResultVo resultVo = new ResultVo();
        try {
            dicValueService.delete(ids);
            resultVo.setOk(true);
            resultVo.setMess("删除字典表值成功");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;

    }

}
