package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
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
    @Autowired
    private ActivityMapper activityMapper;


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

    //点进详情页
    @Override
    public Transaction toDetail(String id) {
        Transaction transaction = transactionMapper.selectByPrimaryKey(id);

        //设置用户
        User user = userMapper.selectByPrimaryKey(transaction.getOwner());
        transaction.setOwner(user.getName());
        // 设置联系人
        Contacts contacts = contactMapper.selectByPrimaryKey(transaction.getContactsId());
        transaction.setContactsId(contacts.getFullname());
        // 设置客户
        Customer customer = customerMapper.selectByPrimaryKey(transaction.getCustomerId());
        transaction.setCustomerId(customer.getName());
        //设置市场活动源
        Activity activity = activityMapper.selectByPrimaryKey(transaction.getActivityId());
        transaction.setActivityId(activity.getName());
        return transaction;
    }

    //查询交易信息  显示到详情页
    @Override
    public Transaction queryTransaction(String id) {
        Transaction transaction = transactionMapper.selectByPrimaryKey(id);
        //设置联系人名称
        Contacts contacts = contactMapper.selectByPrimaryKey(transaction.getContactsId());
        transaction.setContactName(contacts.getFullname());
        // 设置客户
        Customer customer = customerMapper.selectByPrimaryKey(transaction.getCustomerId());
        transaction.setCustomerId(customer.getName());
        //设置市场活动源
        Activity activity = activityMapper.selectByPrimaryKey(transaction.getActivityId());
        transaction.setActivityName(activity.getName());
        return transaction;
    }

    //更新交易信息
    @Override
    public void updateTran(Transaction transaction, User user) {
        transaction.setEditBy(user.getName());
        transaction.setEditTime(DateTimeUtil.getSysTime());
        //设置客户  客户是唯一的
        Example example = new Example(Customer.class);
        example.createCriteria().andEqualTo("name",transaction.getCustomerId());
        List<Customer> customers = customerMapper.selectByExample(example);
        if (customers.size() > 0){
            Customer customer = customers.get(0);
            transaction.setCustomerId(customer.getId());
        }else {
            //创建新的客户
            Customer customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(user.getId());
            customer.setName(transaction.getCustomerId());
            customer.setCreateBy(user.getName());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(transaction.getContactSummary());
            customer.setNextContactTime(transaction.getNextContactTime());
            customer.setDescription(transaction.getDescription());
            int i = customerMapper.insertSelective(customer);
            if (i == 0){
                throw new CrmException(CrmEnum.TRAN_UPDATE);
            }
        }

        //还有活动和联系人怎么存

        int i = transactionMapper.updateByPrimaryKeySelective(transaction);
        if (i == 0){
            throw new CrmException(CrmEnum.TRAN_UPDATE);
        }
    }

    //编辑页面中  点击搜素市场活动  包括模糊查询
    @Override
    public List<Activity> queryActivity(String name) {
        Example example = new Example(Activity.class);
        Example.Criteria criteria = example.createCriteria();
        if (StrUtil.isNotEmpty(name)){
            criteria.andLike("name","%"+name+"%");
        }
        List<Activity> activities = activityMapper.selectByExample(example);
        //设置所有者
        for (Activity activity : activities) {
            User user = userMapper.selectByPrimaryKey(activity.getOwner());
            activity.setOwner(user.getName());
        }
        return activities;
    }


    //查找联系人
    @Override
    public List<Contacts> queryContacts(String name) {
        Example example = new Example(Contacts.class);
        Example.Criteria criteria = example.createCriteria();
        //判断是否模糊查询
        if (StrUtil.isNotEmpty(name)){
            criteria.andLike("name","%"+name+"%");
        }
        List<Contacts> contacts = contactMapper.selectByExample(example);
        return contacts;
    }
}
