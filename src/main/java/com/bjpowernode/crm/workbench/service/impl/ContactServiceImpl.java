package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ContactService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.poi.ss.usermodel.Font;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class ContactServiceImpl implements ContactService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ContactMapper contactMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactActivityMapper contactActivityMapper;
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public PageInfo<Contacts> list(Integer page, Integer pageSize, Contacts contacts) {
        Example example = new Example(Contacts.class);
        Example.Criteria criteria = example.createCriteria();

        //判断查询条件是否为空
        String ownerName = contacts.getOwner();
        if (StrUtil.isNotEmpty(ownerName)){
            //给user拼条件
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name", "%" + ownerName + "%");
            List<User> users = userMapper.selectByExample(example1);
            ArrayList<String> list = new ArrayList<>();
            for (User user : users) {
                list.add(user.getId());
            }
            criteria.andIn("owner", list);
        }
        //联系人姓名
        String fullname = contacts.getFullname();
        if (StrUtil.isNotEmpty(fullname)){
            criteria.andLike("fullname", "%"+fullname+"%");
        }
        //判断客户名称   这里传过来的还是文字 后台存的是主键
        String customerName = contacts.getCustomerId();
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

        //判断来源
        String source = contacts.getSource();
        if (StrUtil.isNotEmpty(source)){
            criteria.andEqualTo("source",source);
        }
        //判断生日
        String birth = contacts.getBirth();
        if (StrUtil.isNotEmpty(birth)){
            criteria.andEqualTo("birth",birth);
        }

        //分页
        PageHelper.startPage(page,pageSize);
        //查询信息
        List<Contacts> contacts1 = contactMapper.selectByExample(example);
        //处理所有者  和客户名
        for (Contacts contacts2 : contacts1) {
            //处理所有者名字
            User user = userMapper.selectByPrimaryKey(contacts2.getOwner());
            contacts2.setOwner(user.getName());

            //处理客户名称
            Customer customer = customerMapper.selectByPrimaryKey(contacts2.getCustomerId());
            contacts2.setCustomerId(customer.getName());
        }

        //把值设置进分页页面中
        PageInfo<Contacts> pageInfo = new PageInfo<>(contacts1);

        return pageInfo;
    }

    //自动补全功能  没有该客户时  创建该客户
    @Override
    public List<String> queryCustomerNames(String customerName, User user) {
        //支持模糊查询
        Example example = new Example(Customer.class);
        Example.Criteria criteria = example.createCriteria();
        List<Customer> customers = new ArrayList<>();
        if (StrUtil.isNotEmpty(customerName)){
            criteria.andLike("name","%"+customerName+"%");
             customers = customerMapper.selectByExample(example);

        }else {
            customers = customerMapper.selectAll();
        }
        //返回名字
        ArrayList<String> names = new ArrayList<>();

        for (Customer customer : customers) {
            names.add(customer.getName());
        }
        return names;

    }

    @Override
    public ResultVo saveOrUpdateContact(Contacts contacts, User user) {
        ResultVo resultVo = new ResultVo();

        //这里客户需要查询  因为客户是公司   不能重名   这一步两个都得做
        Customer customer = new Customer();
        customer.setName(contacts.getCustomerId());
        //查询
        List<Customer> select = customerMapper.select(customer);
        //如果没有这个人  则新建联系人
        if (select.size() == 0){
            //这里说明没有该客户   需要创建新的客户
            customer.setName(contacts.getCustomerId());
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(user.getId());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(user.getName());
            //设置进客户表中
            int i = customerMapper.insertSelective(customer);
            if (i == 0){
                throw new CrmException(CrmEnum.CUSTOMER_INSERT);
            }
            contacts.setCustomerId(customer.getId());
        }else {
            Customer customer1 = select.get(0);
            contacts.setCustomerId(customer1.getId());
        }

        //根据是否有联系人id   判断是添加 还是修改
        if (StrUtil.isEmpty(contacts.getId())){
           //为空说明要添加主键
           contacts.setId(UUIDUtil.getUUID());
           contacts.setOwner(user.getId());
           contacts.setCreateBy(user.getName());
           contacts.setCreateTime(DateTimeUtil.getSysTime());
            //添加联系人
            int i = contactMapper.insertSelective(contacts);
            if (i == 0){
                throw new CrmException(CrmEnum.CONTACT_INSERT);
            }
            resultVo.setMess("添加联系人成功！！");
        }else {
            //这里说明是修改
            contacts.setEditBy(user.getName());
            contacts.setEditTime(DateTimeUtil.getSysTime());
            int i = contactMapper.updateByPrimaryKeySelective(contacts);
            if (i == 0){
                throw new CrmException(CrmEnum.CONTACT_UPDATE);
            }
            resultVo.setMess("更新联系人信息成功！！");
        }
        return resultVo;
    }

    //根据id查询联系人信息
    @Override
    public Contacts queryContact(String id) {
        Contacts contacts = contactMapper.selectByPrimaryKey(id);
        //设置客户显示
        Customer customer = customerMapper.selectByPrimaryKey(contacts.getCustomerId());
        contacts.setCustomerId(customer.getName());
        return contacts;
    }

    //删除联系人信息
    @Override
    public void deleteContacts(String ids) {
        String[] split = ids.split(",");
        List<String> list = Arrays.asList(split);

        Example example = new Example(Contacts.class);
        example.createCriteria().andIn("id", list);
        int i = contactMapper.deleteByExample(example);
        if (i == 0){
            throw new CrmException(CrmEnum.CONTACT_DELETE);
        }
    }

    //点进详情页
    @Override
    public Contacts toDetail(String id) {
        Contacts contacts = contactMapper.selectByPrimaryKey(id);
        //查询备注字段
        ContactsRemark contactsRemark = new ContactsRemark();
        contactsRemark.setContactsId(id);
        List<ContactsRemark> remarks = contactsRemarkMapper.select(contactsRemark);
        //根据创建者查找id  设置备注头像
        for (ContactsRemark remark : remarks) {
            String createBy = remark.getCreateBy();
            Example example = new Example(User.class);
            example.createCriteria().andEqualTo("name", createBy);
            List<User> users = userMapper.selectByExample(example);
            User user = users.get(0);
            remark.setImg(user.getImg());
        }
        contacts.setContactsRemarks(remarks);
        return contacts;
    }

    //联系人备注的添加
    @Override
    public ContactsRemark addRemark(ContactsRemark contactsRemark, User user) {
        contactsRemark.setId(UUIDUtil.getUUID());
        contactsRemark.setCreateBy(user.getName());
        contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
        contactsRemark.setImg(user.getImg());
        int insert = contactsRemarkMapper.insert(contactsRemark);
        if (insert == 0){
            throw new CrmException(CrmEnum.CUSTOMER_REMARK_INSERT);
        }
        //

        return contactsRemark;
    }

    //备注的删除
    @Override
    public void deleteRemark(String id) {
        //id 是备注的id
        int i = contactsRemarkMapper.deleteByPrimaryKey(id);
        if (i == 0){
            throw new CrmException(CrmEnum.CONTACT_REMARK_DELETE);
        }

    }

    @Override
    public ExcelWriter exportExcel(ExcelWriter writer) {
        //反射获取原类的属性数组
        Field[] declaredFields = Contacts.class.getDeclaredFields();
        List<Contacts> contacts = contactMapper.selectAll();
        // 定义单元格背景色
      /*  StyleSet style = writer.getStyleSet();
        // 第二个参数表示是否也设置头部单元格背景
        style.setBackgroundColor(IndexedColors.RED, false);*/

        //设置内容字体
        Font font = writer.createFont();
        font.setBold(true);
        font.setColor(Font.COLOR_NORMAL);
        font.setItalic(true);
        //第二个参数表示是否忽略头部样式
        writer.getStyleSet().setFont(font, true);

        //设置表格头部
        //自定义标题别名

        //合并单元格
        writer.merge(declaredFields.length - 1, "联系人统计数据");
        writer.write(contacts, true);
        return writer;
    }
    }

