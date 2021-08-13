package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.base.bean.DicType;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.github.pagehelper.PageInfo;

public interface DicTypeService {
    PageInfo<DicType> list(Integer page, Integer pageSize);

    void delete(String ids);

    ResultVo add(DicType dicType);

    DicType query(String code);

    ResultVo update(DicType dicType);
}
