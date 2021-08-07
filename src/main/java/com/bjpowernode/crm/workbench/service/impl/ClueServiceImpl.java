package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.Arrays;
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
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private ClueActivityMapper  clueActivityMapper;
    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Autowired
    private ContactActivityMapper contactActivityMapper;

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

    @Override
    public Clue toDetail(String id) {
        Clue clue = clueMapper.selectByPrimaryKey(id);

        //设置所有者
        User user = userMapper.selectByPrimaryKey(clue.getOwner());
        clue.setOwner(user.getName());

        //查备注
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setClueId(id);
        List<ClueRemark> remarks = clueRemarkMapper.select(clueRemark);
        for (ClueRemark remark : remarks) {
            //显示头像  根据创建者
            String createBy = remark.getCreateBy();
            Example example = new Example(User.class);
            example.createCriteria().andEqualTo("name",createBy);
            List<User> users = userMapper.selectByExample(example);
            User user1 = users.get(0);
            remark.setImg(user.getImg());

            //设置线索名称
            remark.setClueId(clue.getFullname());
        }
        clue.setClueRemarks(remarks);
        return clue;
    }
    //备注的添加
    @Override
    public ClueRemark addClueRemark(ClueRemark clueRemark, User user) {
        //设置id
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setCreateBy(user.getName());
        clueRemark.setImg(user.getImg());
        int i = clueRemarkMapper.insertSelective(clueRemark);
        if (i == 0){
            throw new CrmException(CrmEnum.CLUE_REMARK_INSERT);
        }

        //设置线索名称
        Clue clue = clueMapper.selectByPrimaryKey(clueRemark.getClueId());
        clueRemark.setClueId(clue.getFullname());
        return clueRemark;
    }

    //备注的删除
    @Override
    public void deleteRemark(String id) {
        int i = clueRemarkMapper.deleteByPrimaryKey(id);
        if (i == 0){
            throw new CrmException(CrmEnum.CLUE_REMARK_DELETE);
        }
    }

    //显示详情页中关联的市场活动
    @Override
    public List<Activity> queryActivity(String id) {
        //这里的id  是线索的id  涉及到中间表  还有活动表
        Clue clue = clueMapper.selectByPrimaryKey(id);

        //根据中间表查询线索和市场活动
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        Example example = new Example(Activity.class);

        //遍历查询线索活动  获取市场活动id
        ArrayList<String> ids = new ArrayList<>();
        for (ClueActivity activity : clueActivities) {
            ids.add(activity.getActivityId());
        }

        //根据id  查询市场活动
        example.createCriteria().andIn("id", ids);

        List<Activity> activities = activityMapper.selectByExample(example);

        //遍历市场活动  设置返回的所有名称
        for (Activity activity : activities) {
            User user = userMapper.selectByPrimaryKey(activity.getOwner());
            activity.setOwner(user.getName());
        }


        return activities;
    }

    //查询没有绑定的市场活动
    @Override
    public PageInfo<Activity> queryUnbindActivity(String id, String activityName, Integer page, Integer pageSize) {
        //根据线索id查询出
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        Example example = new Example(Activity.class);
        Example.Criteria criteria = example.createCriteria();

        if (clueActivities.size() > 0){
            ArrayList<String> ids = new ArrayList<>();
            for (ClueActivity clueActivity1 : clueActivities) {
                ids.add(clueActivity1.getActivityId());
            }
            //获取绑定的市场活动id
            //得到没有绑定的市场活动
            criteria.andNotIn("id",ids);
        }


        //根据输入的内容  模糊查询
        if (StrUtil.isNotEmpty(activityName)){
            criteria.andLike("name", "%" + activityName + "%");
        }

        //再查询之前分页
        PageHelper.startPage(page, pageSize);
        //查询
        List<Activity> activities = activityMapper.selectByExample(example);
        //遍历查询市场活动
        for (Activity activity : activities) {
            User user = userMapper.selectByPrimaryKey(activity.getOwner());
            activity.setOwner(user.getName());
        }

        PageInfo<Activity> pageInfo = new PageInfo<>(activities);


        return pageInfo;
    }

    //绑定市场活动
    @Override
    public void bind(String id, String ids) {
        //id  是线索id  ids是选中的活动id
        String[] activityIds = ids.split(",");
        for (String activityId : activityIds) {
            ClueActivity clueActivity = new ClueActivity();
            clueActivity.setId(UUIDUtil.getUUID());
            clueActivity.setClueId(id);
            clueActivity.setActivityId(activityId);
            //加入数据库
            int insert = clueActivityMapper.insert(clueActivity);
            if (insert == 0){
                throw new CrmException(CrmEnum.CLUE_BIND);
            }
        }
    }

    //解除市场活动绑定
    @Override
    public void unbind(String id, String aid) {
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        clueActivity.setActivityId(aid);
        int delete = clueActivityMapper.delete(clueActivity);
        if (delete == 0){
            throw new CrmException(CrmEnum.CLUE_UNBIND);
        }
    }

    //根据id  查询线索信息
    @Override
    public Clue queryInfo(String id) {
        Clue clue = clueMapper.selectByPrimaryKey(id);
        return clue;
    }

    @Override
    public List<Activity> queryBindActivities(String id,String activityName) {
        //这里要通过中间表进行查询  传入的是市场活动的id  设置到中间表中
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        //查询出所有的活动id  要定义一个集合 用于存放查询出来的id
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        List<String> ids = new ArrayList<>();
        //遍历查询出的市场活动相关  获取活动id
        for (ClueActivity clueActivity1 : clueActivities) {
            ids.add(clueActivity1.getActivityId());
        }

        //这里还涉及到一个模糊查询 要拼条件查询市场活动
        Example example = new Example(Activity.class);
        Example.Criteria criteria = example.createCriteria();
        //判断输入框是否为空 模糊查询
        if (StrUtil.isNotEmpty(activityName)){
            criteria.andLike("name","%"+activityName+"%");
        }
        //无论查询不查询  都要查id
        criteria.andIn("id",ids);

        List<Activity> activities = activityMapper.selectByExample(example);
        return activities;
    }

    //线索的转换
    @Override
    public void convert(String id, String isTransaction, Transaction transaction, User user) {
        /**
         * 4.1、根据线索的主键查询线索的信息(线索包含自身的信息，包含客户的信息，包含联系人信息)
         * 		4.2、先将线索中的客户信息取出来保存在客户表中，当该客户不存在的时候，新建客户(按公司名称精准查询)
         * 		4.3、将线索中联系人信息取出来保存在联系人表中
         * 		4.4、线索中的备注信息取出来保存在客户备注和联系人备注中
         * 		4.5、将"线索和市场活动的关系"转换到"联系人和市场活动的关系中"
         * 		4.6、如果转换过程中发生了交易，创建一条新的交易，交易信息不全，后面可以通过修改交易来完善交易信息
         * 		4.7、创建该条交易对应的交易历史以及备注
         * 		4.8、删除线索的备注信息
         * 		4.9、删除线索和市场活动的关联关系(tbl_clue_activity_relation)
         * 		4.10、删除线索
         */
        Clue clue = clueMapper.selectByPrimaryKey(id);
        int count = 0;
         //4.2、先将线索中的客户信息取出来保存在客户表中，当该客户不存在的时候，新建客户(按公司名称精准查询)
        Customer customer = new Customer();
        customer.setOwner(clue.getOwner());
        customer.setName(clue.getFullname());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getName());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customer.setId(UUIDUtil.getUUID());
        //判断是否有这个客户   没有则创建新客户
        List<Customer> select = customerMapper.select(customer);
        if (select.size() < 0){
            //创建新客户
            count = customerMapper.insertSelective(customer);
            if (count == 0){
                throw new CrmException(CrmEnum.CLUE_CONVERT);
            }
        }


        //3、将线索中联系人信息取出来保存在联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setAppellation(clue.getAppellation());
        //有些信息没有，可以通过联系人模块进行修改
        contacts.setCreateBy(user.getName());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setEmail(clue.getEmail());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        count = contactMapper.insertSelective(contacts);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }

        //4、线索中的备注信息取出来保存在客户备注和联系人备注中
        //先把线索中的备注信息放入到客户备注中
        ContactsRemark contactsRemark = new ContactsRemark();
        contactsRemark.setId(UUIDUtil.getUUID());
        contactsRemark.setContactsId(contacts.getId());
        contactsRemark.setCreateBy(user.getName());
        contactsRemark.setCreateTime(DateTimeUtil.getSysTime());

        count = contactsRemarkMapper.insert(contactsRemark);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }


        //再把客户备注信息放入到客户备注中
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setId(UUIDUtil.getUUID());
        customerRemark.setCreateBy(user.getName());
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());
        customerRemark.setCustomerId(customer.getId());
        count = customerRemarkMapper.insertSelective(customerRemark);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }

        //5、将"线索和市场活动的关系"转换到"联系人和市场活动的关系中"
        //根据线索id查询中间表中关联的市场活动
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        for (ClueActivity clueActivity1 : clueActivities) {
            //把联系人和市场活动外键插入到中间表中
            ContactActivity contactActivity = new ContactActivity();
            contactActivity.setId(UUIDUtil.getUUID());
            contactActivity.setActivityId(clueActivity1.getActivityId());
            contactActivity.setContactsId(contacts.getId());
            count = contactActivityMapper.insertSelective(contactActivity);
            if (count == 0) {
                throw new CrmException(CrmEnum.CLUE_CONVERT);
            }
        }

        //6、如果转换过程中发生了交易，创建一条新的交易，交易信息不全，后面可以通过修改交易来完善交易信息
        //如果转换页面的"为客户创建交易"复选框勾中的话，说明创建交易了
        if (isTransaction.equals("1")) {
            //发生交易，创建交易信息
            transaction.setId(UUIDUtil.getUUID());
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getName());
            transaction.setCreateTime(DateTimeUtil.getSysTime());
            transaction.setCustomerId(customer.getId());
            transaction.setOwner(clue.getOwner());
            transaction.setSource(clue.getSource());

            count = transactionMapper.insertSelective(transaction);
            if (count == 0) {
                throw new CrmException(CrmEnum.CLUE_CONVERT);
            }


            //7、创建交易备注和交易历史
            //交易备注
            TransactionRemark transactionRemark = new TransactionRemark();
            transactionRemark.setId(UUIDUtil.getUUID());
            transactionRemark.setCreateBy(user.getName());
            transactionRemark.setCreateTime(DateTimeUtil.getSysTime());
            transactionRemark.setTranId(transaction.getId());
            count = transactionRemarkMapper.insert(transactionRemark);
            if (count == 0) {
                throw new CrmException(CrmEnum.CLUE_CONVERT);
            }

            //交易历史
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtil.getUUID());
            transactionHistory.setCreateBy(user.getName());
            transactionHistory.setCreateTime(DateTimeUtil.getSysTime());
            transactionHistory.setExpectedDate(transaction.getExpectedDate());
            transactionHistory.setMoney(transaction.getMoney());
            transactionHistory.setStage(transaction.getStage());
            transactionHistory.setTranId(transaction.getId());
            count = transactionHistoryMapper.insert(transactionHistory);
            if (count == 0) {
                throw new CrmException(CrmEnum.CLUE_CONVERT);
            }
        }

        //8、删除线索的备注信息
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setClueId(id);
        count = clueRemarkMapper.delete(clueRemark);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }

        //9、删除线索和市场活动的关联关系
        ClueActivity clueActivity2 = new ClueActivity();
        clueActivity2.setClueId(id);
        count = clueActivityMapper.delete(clueActivity2);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }
        //10、删除线索
        count = clueMapper.deleteByPrimaryKey(id);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }


    }

//    线索的添加
    @Override
    public void saveClue(Clue clue, User user) {
        //设置值
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        int i = clueMapper.insertSelective(clue);
        if (i == 0){
            throw new CrmException(CrmEnum.CLUE_INSERT);
        }
    }

    //线索的删除
    @Override
    public void deleteClue(String ids) {
        String[] split = ids.split(",");
        List<String> list = Arrays.asList(split);
        Example example = new Example(Clue.class);
        example.createCriteria().andIn("id",list);
        int i = clueMapper.deleteByExample(example);
        if (i == 0){
            throw new CrmException(CrmEnum.CLUE_DELETE);
        }

    }

    //线索的修改  先根据id 查询线索信息
    @Override
    public Clue queryClueById(String id) {
        Clue clue = clueMapper.selectByPrimaryKey(id);
        return clue;
    }

    //更新线索
    @Override
    public void updateClue(Clue clue, User user) {
        clue.setEditBy(user.getName());
        clue.setEditTime(DateTimeUtil.getSysTime());
        int i = clueMapper.updateByPrimaryKeySelective(clue);
        if (i == 0){
            throw new CrmException(CrmEnum.CLUE_UPDATE);
        }

    }
}
