package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.base.bean.DicValue;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.mapper.DicValueMapper;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.Arrays;
import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;
    @Override
    public PageInfo<DicValue> list(Integer page, Integer pageSize) {
        // 查询所有字典值
        List<DicValue> dicValues = dicValueMapper.selectAll();

        //遍历设置序号
        Integer no = 1;
        for (DicValue dicValue : dicValues) {
           dicValue.setNum(no);
           no ++;
        }
        PageHelper.startPage(page, pageSize);
        PageInfo<DicValue> pageInfo = new PageInfo<>(dicValues);
        return pageInfo;
    }


    //添加字典值
    @Override
    public ResultVo addValue(DicValue dicValue) {
        ResultVo resultVo = new ResultVo();
        dicValue.setId(UUIDUtil.getUUID());
        int i = dicValueMapper.insertSelective(dicValue);
        if (i == 0){
            throw new CrmException(CrmEnum.DICVALUE_INSERT);
        }
        resultVo.setOk(true);
        resultVo.setMess("添加字典表值成功");
        return resultVo;
    }

    @Override
    public void delete(String ids) {
        //根据，号切割获取到的id字符串
        String[] split = ids.split(",");

        //将数组转换成集合  用asList()方法
        List<String> splitIds = Arrays.asList(split);

        //准备拼接id  注意andIn()方法的使用
        Example example = new Example(DicValue.class);
        //注意前面的 property  应该跟表中的字段对应
        example.createCriteria().andIn("id",splitIds);

        //调含拼接条件的参数删除方法
        int result = dicValueMapper.deleteByExample(example);
        if (result == 0){
            throw new CrmException(CrmEnum.DICVALUE_DELETE);
        }
    }


}
