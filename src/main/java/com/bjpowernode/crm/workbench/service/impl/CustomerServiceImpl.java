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
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.CustomerRemark;
import com.bjpowernode.crm.workbench.mapper.ContactMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerRemarkMapper;
import com.bjpowernode.crm.workbench.service.CustomerService;
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
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactMapper contactMapper;
    @Override
    public PageInfo<Customer> list(Integer page, Integer pageSize, Customer customer) {
        Example example = new Example(Customer.class);
        Example.Criteria criteria = example.createCriteria();
        //拼条件
        //公司名字模糊查询
        if (StrUtil.isNotEmpty(customer.getName())){
            criteria.andLike("name","%"+customer.getName()+"%");
        }

        //公司号码
        if (StrUtil.isNotEmpty(customer.getPhone())){
            criteria.andLike("phone", "%" + customer.getPhone() + "%");
        }
        //公司网站
        if (StrUtil.isNotEmpty(customer.getWebsite())){
            criteria.andLike("website", "%" + customer.getWebsite() + "%");
        }

        //模糊查询所有者
        String ownerName = customer.getOwner();
        if (StrUtil.isNotEmpty(ownerName)){
            //在所有者中模糊查询所有信息
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name", "%" + ownerName + "%");
            List<User> users = userMapper.selectByExample(example1);
            ArrayList<String> list = new ArrayList<>();
            //遍历获取用用户的id
            for (User user1 : users) {
                list.add(user1.getId());
            }
            //拼条件
            criteria.andIn("owner", list);
        }

        //分页  这个位置很重要  不要放在后面了  放后面还怎么分页？？
        PageHelper.startPage(page,pageSize);
        //查询条件
        List<Customer> customers = customerMapper.selectByExample(example);
        //返回页面时要注意  把名字主键改成名字
        for (Customer customer1 : customers) {
            String owner = customer1.getOwner();
            User user1 = userMapper.selectByPrimaryKey(owner);
            customer1.setOwner(user1.getName());
        }
        //把集合放到pageInfo
        PageInfo<Customer> pageInfo = new PageInfo<>(customers);
        return pageInfo;
    }

    //删除客户
    @Override
    public void delete(String ids) {
        String[] split = ids.split(",");
        List<String> list = Arrays.asList(split);
        Example example = new Example(Customer.class);
        example.createCriteria().andIn("id",list);
        int i = customerMapper.deleteByExample(example);
        if (i == 0){
            throw new CrmException(CrmEnum.CUSTOMER_DELETE);
        }

        //这里其实还要删除客户的备注
    }

    //保存或者更新用户信息
    @Override
    public ResultVo saveOrUpdate(Customer customer, User user) {
        ResultVo resultVo = new ResultVo();
        //根据是否有id 判断是更新还是删除
        if (StrUtil.isEmpty(customer.getId())){
            //为空 则表示这是新增客户  需要设置id
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(user.getName());
            customer.setOwner(user.getId());
            customer.setCreateTime(DateTimeUtil.getSysTime());

            //添加入库
            int i = customerMapper.insertSelective(customer);
            if (i== 0){
                throw new CrmException(CrmEnum.CUSTOMER_INSERT);
            }
            resultVo.setMess("添加客户成功！！");
        }else {
            //这是修改客户
            customer.setEditBy(user.getName());
            customer.setEditTime(DateTimeUtil.getSysTime());
            int i = customerMapper.updateByPrimaryKeySelective(customer);
            if (i == 0){
                throw new CrmException(CrmEnum.CUSTOMER_UPDATE);
            }
            resultVo.setMess("修改客户成功！！");

        }
        return resultVo;
    }

    //c查询客户信息
    @Override
    public Customer queryCustomer(String id) {
        Customer customer = customerMapper.selectByPrimaryKey(id);
        return customer;
    }

    //客户详情页操作
    @Override
    public Customer toDetail(String id) {
        //根据客户id  查询出所有信息
        Customer customer = customerMapper.selectByPrimaryKey(id);

        Contacts contacts = new Contacts();
        contacts.setCustomerId(id);
        List<Contacts> select = contactMapper.select(contacts);
        //设置所有者
        User user1 = userMapper.selectByPrimaryKey(customer.getOwner());
        customer.setOwner(user1.getName());

        //查询备注信息
        Example example = new Example(CustomerRemark.class);
        example.createCriteria().andEqualTo("customerId",id);
        List<CustomerRemark> customerRemarks = customerRemarkMapper.selectByExample(example);

        //解决备注头像问题  先查出创建者   根据创建者找所有者id   然后把 头像路径设置到客户中
        for (CustomerRemark customerRemark : customerRemarks) {
            String ownerName = customerRemark.getCreateBy();
            Example example1 = new Example(User.class);
            example1.createCriteria().andEqualTo("name",ownerName);
            List<User> users = userMapper.selectByExample(example1);
            for (User user : users) {
                customerRemark.setImg(user.getImg());
            }
            for (Contacts contacts1 : select) {
                customerRemark.setName(contacts1.getFullname()+contacts1.getAppellation());
            }
            customerRemark.setCustomerId(customer.getName());
            //设置联系人姓名和称呼   在备注表中要注入这两个新的字段
            //怎么查呢  联系人表中有客户id  也就是这里的id
        }
        customer.setCustomerRemarks(customerRemarks);

        return customer;
    }

    //备注的添加
    @Override
    public ResultVo addRemark(CustomerRemark customerRemark, User user) {

        ResultVo resultVo = new ResultVo();
        //添加主键
        customerRemark.setId(UUIDUtil.getUUID());
        //设置创建者 和创建时间
        customerRemark.setCreateBy(user.getName());
        customerRemark.setImg(user.getImg());
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());

        //联系人还没有设置   这个怎么设置啊？？？
        //获取客户id   找联系人
        String customerId = customerRemark.getCustomerId();
        Example example = new Example(Contacts.class);
        example.createCriteria().andEqualTo("customerId", customerId);
        List<Contacts> contacts = contactMapper.selectByExample(example);
        if(contacts.size() > 0) {
            Contacts contacts1 = contacts.get(0);
            customerRemark.setContactName(contacts1.getFullname());
            customerRemark.setContactAppellation(contacts1.getAppellation());
        }

        int i = customerRemarkMapper.insertSelective(customerRemark);
        if (i == 0){
            throw new CrmException(CrmEnum.CUSTOMER_REMARK_INSERT);
        }

        resultVo.setT(customerRemark);

        return resultVo;
    }

    //备注的删除
    @Override
    public void deleteCustomerRemark(String id) {
//        int i = customerRemarkMapper.deleteByPrimaryKey(id);
        int i = customerRemarkMapper.deleteByPrimaryKey(id);
        if (i == 0){
            throw new CrmException(CrmEnum.CUSTOMER_REMARK_DELETE);
        }
    }

    @Override
    public ExcelWriter exportExcel(ExcelWriter writer) {
        //反射获取原类的属性数组
        Field[] declaredFields = Customer.class.getDeclaredFields();
        List<Customer> customers = customerMapper.selectAll();
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
        writer.merge(declaredFields.length - 1, "客户统计数据");
        writer.write(customers, true);
        return writer;
    }
    }

