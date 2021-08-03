package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.mapper.ContactMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.mapper.TransactionMapper;
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.List;

@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactMapper contactMapper;
    @Override
    public PageInfo<Transaction> list(Integer page, Integer pageSize, Transaction transaction){
        Example example = new Example(Transaction.class);
        Example.Criteria criteria = example.createCriteria();
        //判断前面的条件是否为空
        //判断所有者
        String ownerName = transaction.getOwner();
        if (StrUtil.isNotEmpty(ownerName)){
            //模糊查询
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name", "%" + ownerName + "%");
            List<User> users = userMapper.selectByExample(example1);
            ArrayList<String> list = new ArrayList<>();
            for (User user : users) {
                list.add(user.getId());
            }
            criteria.andIn("owner", list);
        }
        // 名称
        String name = transaction.getName();
        if (StrUtil.isNotEmpty(name)){
            criteria.andLike("name", "%" + name + "%");
        }
        // 客户名称
        String customerName = transaction.getCustomerId();
        if (StrUtil.isNotEmpty(customerName)){
            Example example1 = new Example(Customer.class);
            example1.createCriteria().andLike("name", "%" + customerName + "%");
            List<Customer> customers = customerMapper.selectByExample(example1);
            ArrayList<String> list = new ArrayList<>();
            for (Customer customer : customers) {
                list.add(customer.getId());
            }
            criteria.andIn("customerId", list);
        }
        // 联系人名称
        String contactName = transaction.getContactsId();
        if (StrUtil.isNotEmpty(contactName)){
            Example example1 = new Example(Contacts.class);
            example1.createCriteria().andLike("fullname", "%" + contactName + "%");
            List<Contacts> contacts = contactMapper.selectByExample(example1);
            ArrayList<String> list = new ArrayList<>();
            for (Contacts contact : contacts) {
                list.add(contact.getId());
            }
            criteria.andIn("contactsId", list);
        }


        // 阶段
        String stage = transaction.getStage();
        if (StrUtil.isNotEmpty(stage)){
            criteria.andEqualTo("stage",stage);
        }
        // 类型
        String type = transaction.getType();
        if (StrUtil.isNotEmpty(type)){
            criteria.andEqualTo("type",type);
        }
        // 来源
        String source = transaction.getSource();
        if (StrUtil.isNotEmpty(source)){
            criteria.andEqualTo("source",source);
        }

        //分页
        PageHelper.startPage(page, pageSize);
        List<Transaction> transactions = transactionMapper.selectByExample(example);

        //设置返回的所有者 和客户 联系人
        for (Transaction transaction1 : transactions) {
            User user = userMapper.selectByPrimaryKey(transaction1.getOwner());
            transaction1.setOwner(user.getName());
            Customer customer = customerMapper.selectByPrimaryKey(transaction1.getCustomerId());
            transaction1.setCustomerId(customer.getName());
            Contacts contacts = contactMapper.selectByPrimaryKey(transaction1.getContactsId());
            transaction1.setContactsId(contacts.getFullname());
        }

        PageInfo<Transaction> pageInfo = new PageInfo<>(transactions);


        return pageInfo;
    }
}
