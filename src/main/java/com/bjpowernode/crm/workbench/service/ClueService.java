package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.bean.Clue;
import com.github.pagehelper.PageInfo;

public interface ClueService {
    PageInfo<Clue> list(Integer page, Integer pageSize, Clue clue);

}
