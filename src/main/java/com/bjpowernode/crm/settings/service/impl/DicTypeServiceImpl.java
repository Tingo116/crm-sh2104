package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.base.bean.DicType;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.mapper.DicTypeMapper;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.Arrays;
import java.util.List;

@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    private DicTypeMapper dicTypeMapper;
    @Override
    public PageInfo<DicType> list(Integer page, Integer pageSize) {
        //查询出所有的数据类型
        List<DicType> dicTypes = dicTypeMapper.selectAll();
        //给一个序号
        //遍历集合
        Integer no = 1;
        for (DicType dicType : dicTypes) {
            dicType.setNum(no);
            no++;
        }
        //分页
        PageHelper.startPage(page, pageSize);
        //把查询到的值放进去
        PageInfo<DicType> dicTypePageInfo = new PageInfo<>(dicTypes);

        return dicTypePageInfo;
    }

    @Override
    public void delete(String ids) {
        //根据，号切割获取到的id字符串
        String[] split = ids.split(",");

        //将数组转换成集合  用asList()方法
        List<String> splitIds = Arrays.asList(split);

        //准备拼接id  注意andIn()方法的使用
        Example example = new Example(DicType.class);
        //注意前面的 property  应该跟表中的字段对应
        example.createCriteria().andIn("id",splitIds);

        //调含拼接条件的参数删除方法
        int result = dicTypeMapper.deleteByExample(example);
        if (result == 0){
            throw new CrmException(CrmEnum.DICTYPE_DELETE);
        }
    }

    //添加字典表类型
    @Override
    public ResultVo add(DicType dicType) {
        ResultVo resultVo = new ResultVo();
        int i = dicTypeMapper.insertSelective(dicType);
        if (i == 0){
            throw new CrmException(CrmEnum.DICTYPE_INSERT);
        }
        resultVo.setOk(true);
        resultVo.setMess("添加字典表类型成功");
        return resultVo;
    }

    //修改字典数据类型  第一步查询出所有的值  并且把值设置到编辑页面
    @Override
    public DicType query(String code) {
        DicType dicType = new DicType();
        dicType.setCode(code);
        DicType type = dicTypeMapper.selectByPrimaryKey(dicType);
        return type;
    }

    @Override
    public ResultVo update(DicType dicType) {
        ResultVo resultVo = new ResultVo();

        int i = dicTypeMapper.updateByPrimaryKeySelective(dicType);
        if (i == 0){
            throw new CrmException(CrmEnum.DICTYPE_UPDATE);
        }
        resultVo.setOk(true);
        resultVo.setMess("修改字典表类型成功");
        return resultVo;
    }
}
