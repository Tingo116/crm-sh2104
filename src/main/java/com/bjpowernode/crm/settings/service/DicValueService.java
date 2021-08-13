package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.base.bean.DicValue;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.github.pagehelper.PageInfo;

public interface DicValueService {
    PageInfo<DicValue> list(Integer page, Integer pageSize);

    ResultVo addValue(DicValue dicValue);

    void delete(String ids);
}
