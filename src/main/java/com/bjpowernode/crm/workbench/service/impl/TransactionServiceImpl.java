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
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.poi.ss.usermodel.Font;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;


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

        //显示备注
        TransactionRemark transactionRemark = new TransactionRemark();
        transactionRemark.setTranId(id);
        List<TransactionRemark> transactionRemarks = transactionRemarkMapper.select(transactionRemark);
        //处理备注人头像问题
        for (TransactionRemark remark : transactionRemarks) {
            String createBy = remark.getCreateBy();
            Example example = new Example(User.class);
            example.createCriteria().andEqualTo("name", createBy);
            List<User> users = userMapper.selectByExample(example);
            User user1 = users.get(0);
            remark.setImg(user1.getImg());

            //设置交易名称
            Transaction transaction1 = transactionMapper.selectByPrimaryKey(remark.getTranId());
            remark.setTranId(transaction1.getName());
        }
        transaction.setTransactionRemarks(transactionRemarks);

        //显示交易历史
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setTranId(id);
        List<TransactionHistory> transactionHistories = transactionHistoryMapper.select(transactionHistory);

        transaction.setTransactionHistories(transactionHistories);

        return transaction;
    }

    //查询交易信息  显示到详情页
    @Override
    public Transaction queryTransaction(String id) {
        Transaction transaction = transactionMapper.selectByPrimaryKey(id);
        //设置联系人名称
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

    //更新交易信息
    @Override
    public void updateTran(Transaction transaction, User user) {
        transaction.setEditBy(user.getName());
        transaction.setEditTime(DateTimeUtil.getSysTime());

        Activity activity = new Activity();
        activity.setName(transaction.getActivityId());
        Activity activity1 = activityMapper.selectOne(activity);
        transaction.setActivityId(activity1.getId());

        Contacts contacts = new Contacts();
        contacts.setFullname(transaction.getContactsId());
        Contacts contacts1 = contactMapper.selectOne(contacts);
        transaction.setContactsId(contacts1.getId());
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

    //添加交易
    @Override
    public void addTran(Transaction transaction, User user) {
        transaction.setId(UUIDUtil.getUUID());
        transaction.setCreateBy(user.getName());
        transaction.setCreateTime(DateTimeUtil.getSysTime());
        //设置客户id
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
                throw new CrmException(CrmEnum.TRAN_INSERT);
            }
        }


        int i = transactionMapper.insertSelective(transaction);
        if (i == 0){
            throw new CrmException(CrmEnum.TRAN_INSERT);
        }


    }


    //导出统计数据
    @Override
    public ExcelWriter exportExcel(ExcelWriter writer) {
        //反射获取原类的属性数组
        Field[] declaredFields = Transaction.class.getDeclaredFields();
        List<Transaction> transactions = transactionMapper.selectAll();
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
        writer.merge(declaredFields.length - 1, "交易统计数据");
        writer.write(transactions, true);
        return writer;

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

    //交易备注的添加

    @Override
    public TransactionRemark addRemark(TransactionRemark transactionRemark, User user) {
        transactionRemark.setId(UUIDUtil.getUUID());
        transactionRemark.setCreateBy(user.getName());
        transactionRemark.setCreateTime(DateTimeUtil.getSysTime());
        int i = transactionRemarkMapper.insertSelective(transactionRemark);
        if (i == 0){
            throw new CrmException(CrmEnum.TRAN_REMARK_INSERT);
        }
        //设置交易名称
        Transaction transaction = transactionMapper.selectByPrimaryKey(transactionRemark.getTranId());
        transactionRemark.setTranId(transaction.getName());
        //设置头像
        transactionRemark.setImg(user.getImg());
        return transactionRemark;
    }

    //显示修改交易阶段信息
    @Override
    public ResultVo stageList(String id, Integer position, User user, Map<String, String> stage2Possibility) {
        ResultVo resultVo = new ResultVo();
        //查询出当前交易的所处阶段 和  可能性
        Transaction transaction = transactionMapper.selectByPrimaryKey(id);
        String currentStage = transaction.getStage();
        String currentPossibility = transaction.getPossibility();
        //要将map集合转换成list集合
        List<Map.Entry<String, String>> stages = new ArrayList(stage2Possibility.entrySet());


        //新建一个集合   存放阶段信息
        ArrayList<Stage> stageList = new ArrayList<>();
        int index = 0;
        int pointer = 0;

        //==========先处理index======================
        //最重要的是怎么判断这两个参数？？？  没有修改时 是查出来的 也分为两个阶段？？
        //修改的时候  是前台传过来的position  那么这个就是锚点 index
        //这里根据前台是否传过来position  确定是否进行了修改
        if (position != null){
            //说明进行了修改  这里最好的解决方法是更新数据库的数据   再查一遍
            index = position;
            //根据索引获取交易状态和可能性  更新数据库中
            Map.Entry<String, String> entry = stages.get(index);
            transaction.setStage(entry.getKey());
            transaction.setPossibility(entry.getValue());
            //设置当前线索状态
            currentStage=entry.getKey();
            currentPossibility=entry.getValue();
            //更新交易表
            int i = transactionMapper.updateByPrimaryKeySelective(transaction);
            if (i == 0){
                throw new CrmException(CrmEnum.TRAN_STAGELIST);
            }

            //同时更新交易表
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtil.getUUID());
            transactionHistory.setStage(transaction.getStage());
            transactionHistory.setPossibility(transaction.getPossibility());
            transactionHistory.setMoney(transaction.getMoney());
            transactionHistory.setCreateTime(DateTimeUtil.getSysTime());
            transactionHistory.setCreateBy(user.getName());
            transactionHistory.setTranId(id);
            transactionHistory.setExpectedDate(transaction.getExpectedDate());
            int i1 = transactionHistoryMapper.insertSelective(transactionHistory);
            if (i1 == 0){
                throw new CrmException(CrmEnum.TRAN_STAGELIST);
            }

            //将交易历史设置到返回的t对象中   前台同步修改要用
            resultVo.setT(transactionHistory);
        }else {
            //如果没有修改   则要遍历一下  根据当前可能性确定锚点位置
            for (int i = 0; i <stages.size() ; i++) {
                Map.Entry<String, String> entry = stages.get(i);
                String possibility = entry.getValue();
                if (currentPossibility.equals(possibility)){
                    index = i;
                    break;
                }
            }
        }

        //==================这里是判断pointer位置的==============
        //遍历一下
        for (int i = 0; i <stages.size() ; i++) {
            Map.Entry<String, String> entry = stages.get(i);
            String possibility = entry.getValue();
            if ("0".equals(possibility)){
                pointer = i;
                break;
            }

        }

        //大体分成两大部分
        // 一个是可能性为0 那么前面的都是黑圈  剩下的任务就是确定哪个是红叉哪个是黑叉
        //另一部分是交易进行中的   锚点index前绿圈 锚点绿色定位  锚点后到交易失败前是黑圈
        if ("0".equals(currentPossibility)){
            //后面两个判断哪个红叉 哪个黑叉
            for (int i = 0; i <stages.size() ; i++) {
                Stage stage = new Stage();
                Map.Entry<String, String> entry = stages.get(i);
                String content = entry.getKey();
                String possibility = entry.getValue();
                if ("0".equals(possibility)){
                    //进一步判断是红叉还是黑叉  根据交易阶段
                    if (currentStage.equals(content)){
//                        可能性相同时比较  比较交易阶段
                        stage.setType("红叉");
                    }else {
                        stage.setType("黑叉");
                    }
                }else {
                    //这里说明前面的都是黑圈
                    stage.setType("黑圈");
                }
                //出循环都要设置提示阶段的信息
                stage.setContent(content);
                stage.setPossibility(possibility);
                //设置position
                stage.setPosition(i+"");
                //并且要加入到集合中
                stageList.add(stage);
            }
        }else {
            //这里说明还是在交易进行中
            for (int i = 0; i <stages.size() ; i++) {
                Stage stage = new Stage();
                Map.Entry<String, String> entry = stages.get(i);
                String content = entry.getKey();
                String possibility = entry.getValue();
                //根据index  和 pointer  来确定
                if (i < index){
                    //在锚点前面都是绿圈
                    stage.setType("绿圈");
                }else if (i == index){
                    //这是锚点绿勾
                    stage.setType("绿勾");
                }else if (i >index && i < pointer){
                    //锚点和pointer之间是黑圈
                    stage.setType("黑圈");
                }else {
                    //最后两个是黑叉
                    stage.setType("黑叉");
                }
                //出循环都要设置提示阶段的信息
                stage.setContent(content);
                stage.setPossibility(possibility);
                //设置position
                stage.setPosition(i+"");
                //并且要加入到集合中
                stageList.add(stage);
            }
        }

        resultVo.setOk(true);
        resultVo.setMess("修改交易成功");
        resultVo.setList(stageList);

        return resultVo;
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
