package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Clue;
import com.bjpowernode.crm.workbench.mapper.ClueMapper;
import com.bjpowernode.crm.workbench.mapper.ContactMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ContactMapper contactMapper;
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public PageInfo<Clue> list(Integer page, Integer pageSize, Clue clue) {
        //先做判断
        Example example = new Example(Clue.class);
        Example.Criteria criteria = example.createCriteria();
        //名字模糊查询
        String fullname = clue.getFullname();
        if (StrUtil.isNotEmpty(fullname)){
            criteria.andLike("fullname","%"+fullname+"%");
        }

        //判断所有者   名字的模糊查询
        String ownerName = clue.getOwner();
        if (StrUtil.isNotEmpty(ownerName)){
            //模糊查询
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name", "%" + ownerName + "%");
            List<User> users = userMapper.selectByExample(example1);
            ArrayList<String> list = new ArrayList<>();
            for (User user : users) {
                list.add(user.getId());
            }
            criteria.andIn("owner",list);
        }

        //判断线索状态
        String state = clue.getState();
        if (StrUtil.isNotEmpty(state)){
            criteria.andEqualTo("state",state);
        }
        String company = clue.getCompany();
        if (StrUtil.isNotEmpty(company)){
            criteria.andLike("company","%"+ company +"%");
        }
        String mphone = clue.getMphone();
        if (StrUtil.isNotEmpty(company)){
            criteria.andLike("mphone", "%"+mphone+"%");
        }

        String phone = clue.getPhone();
        if (StrUtil.isNotEmpty(company)){
            criteria.andLike("phone","%"+ phone +"%");
        }

        String source = clue.getSource();
        if (StrUtil.isNotEmpty(source)){
            criteria.andEqualTo("source",source );
        }

        //分页
        PageHelper.startPage(page,pageSize);
        List<Clue> clues = clueMapper.selectByExample(example);
        //设置返回所有者为中文名字
        for (Clue clue1 : clues) {
            User user = userMapper.selectByPrimaryKey(clue1.getOwner());
            clue1.setOwner(user.getName());
        }

        PageInfo<Clue> pageInfo = new PageInfo<>(clues);
        return pageInfo;
    }
}
