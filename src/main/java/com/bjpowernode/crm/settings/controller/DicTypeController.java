package com.bjpowernode.crm.settings.controller;

import com.bjpowernode.crm.base.bean.DicType;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class DicTypeController {
    @Autowired
    private DicTypeService dicTypeService;
    //显示所有字典数据类型
    @RequestMapping("/settings/dicType/list")
    @ResponseBody
    public PageInfo list(Integer page, Integer pageSize){
        PageInfo<DicType> pageInfo = dicTypeService.list(page,pageSize);
        return pageInfo;
    }

    @RequestMapping("/settings/dicType/delete")
    @ResponseBody
    public ResultVo delete(String ids) {
        ResultVo resultVo = new ResultVo();
        try {
            dicTypeService.delete(ids);
            resultVo.setOk(true);
            resultVo.setMess("删除字典表类型成功");
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //添加字典类型
    @RequestMapping("/settings/divType/add")
    @ResponseBody
    public ResultVo add(DicType dicType) {
        ResultVo resultVo = new ResultVo();
        try {
            resultVo =  dicTypeService.add(dicType);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }

    //修改字典表类型
    @RequestMapping("/settings/dicType/query")
    @ResponseBody
    public DicType query(String code){
        DicType dicType = dicTypeService.query(code);
        return dicType;
    }
    //保存修改过后的信息
    @RequestMapping("/settings/dicType/update")
    @ResponseBody
    public ResultVo update(DicType dicType) {
        ResultVo resultVo = new ResultVo();
        try {
            resultVo =  dicTypeService.update(dicType);
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        }
        return resultVo;
    }


}
