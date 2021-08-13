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
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.ActivityRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
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
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public PageInfo<Activity> list(Integer page, Integer pageSize, Activity activity) {
        Example example = new Example(Activity.class);
        Example.Criteria criteria = example.createCriteria();

        //判断市场活动名称
      /*  String name = activity.getName();
        if (StrUtil.isNotEmpty(name)){
            criteria.andLike("name","%"+name+"%");
        }*/
        //判断市场活动名称
        String name = activity.getName();
        if (StrUtil.isNotEmpty(name)) {
            criteria.andLike("name", "%" + name + "%");
        }


        //判断各个输入框是否有数据   点击查询按钮
        //判断所有者  先根据名字模糊查询   获得所有的主键  遍历出ｉｄ
        String owner = activity.getOwner();
        if (StrUtil.isNotEmpty(owner)) {
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name", "%" + owner + "%");
            List<User> users = userMapper.selectByExample(example1);
            //创建一个集合   存放活动id
            ArrayList<String> ids = new ArrayList<>();
            for (User user : users) {
                String id = user.getId();
                ids.add(id);
            }
            //把条件拼进活动的查询
            criteria.andIn("owner", ids);
        }


        //判断开始日期
        String startDate = activity.getStartDate();
        if (StrUtil.isNotEmpty(startDate)) {
            criteria.andGreaterThanOrEqualTo("startDate", startDate);
        }
        //判断结束日期
        String endDate = activity.getEndDate();
        if (StrUtil.isNotEmpty(endDate)) {
            criteria.andLessThanOrEqualTo("endDate", endDate);
        }
        //设置分页
        PageHelper.startPage(page, pageSize);

        //根据拼接的条件查询市场活动
        List<Activity> activities = activityMapper.selectByExample(example);

        //这里还需要将查询到的所有者改成名字  总不能显示外键吧
        for (Activity activity1 : activities) {
            User user = userMapper.selectByPrimaryKey(activity1.getOwner());
            activity1.setOwner(user.getName());
        }

        // 查询出的数据设置到返回的数据中
        PageInfo<Activity> pageInfo = new PageInfo<>(activities);
        return pageInfo;
    }

    //添加或者保存市场活动
    @Override
    public ResultVo addOrUpdateActivity(Activity activity, User user) {
        ResultVo resultVo = new ResultVo();

        //根据是否有id 判断是添加还是修改

        if (StrUtil.isEmpty(activity.getId())) {
            //这是新增  需要设置id号
            activity.setId(UUIDUtil.getUUID());
            //设置创建者
            activity.setCreateBy(user.getName());
            //设置创建时间
            activity.setCreateTime(DateTimeUtil.getSysTime());
            int i = activityMapper.insertSelective(activity);
            if (i == 0) {
                throw new CrmException(CrmEnum.ACTIVITY_INSERT);
            }

            //添加成功的提示信息
            resultVo.setMess("添加市场活动成功！！！");
        } else {
            //这里是修改
            //设置修改时间
            activity.setEditBy(user.getName());
            //设置修改时间
            activity.setEditTime(DateTimeUtil.getSysTime());
            int i = activityMapper.updateByPrimaryKeySelective(activity);
            if (i == 0) {
                throw new CrmException(CrmEnum.ACTIVITY_UPDATE);
            }
            //添加成功信息
            resultVo.setMess("修改市场活动成功！！！");
        }

        return resultVo;
    }


    //市场活动的删除
    @Override
    public ResultVo deleteActivity(String ids) {
        ResultVo resultVo = new ResultVo();
        //用逗号切割字符串  得到数组
        String[] split = ids.split(",");
        //将数组转换成集合
        List<String> list = Arrays.asList(split);
        Example example = new Example(Activity.class);
        example.createCriteria().andIn("id", list);
        int i = activityMapper.deleteByExample(example);
        if (i == 0) {
            throw new CrmException(CrmEnum.ACTIVITY_DELETE);
        }
        //这里其实还要删除市场活动关联的备注的信息
        Example example1 = new Example(ActivityRemark.class);
        example1.createCriteria().andIn("activityId", list);
        int i1 = activityRemarkMapper.deleteByExample(example1);
        if (i1 == 0) {
            throw new CrmException(CrmEnum.ACTIVITY_REMARK_DELETE);
        }
        resultVo.setMess("删除市场活动成功！！");
        return resultVo;
    }

    //查询市场活动
    @Override
    public Activity queryActivity(String id) {
        Activity activity = activityMapper.selectByPrimaryKey(id);
        return activity;
    }

    //点进市场活动详情页  后面需要显示备注  这里要在实体类中加入一个list  存放备注信息
    @Override
    public Activity toDetail(String id) {
        //根据id查询市场活动
        Activity activity = activityMapper.selectByPrimaryKey(id);
        //所有者显示的是id  这里需要查询一下
        User user = userMapper.selectByPrimaryKey(activity.getOwner());
        activity.setOwner(user.getName());
        //下面是根据市场活动id 查市场活动备注信息。上面要注入市场活动备注表
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setActivityId(id);
        List<ActivityRemark> activityRemarks = activityRemarkMapper.select(activityRemark);
        //解决用户头像显示问题  根据owner id  查询用户头像
        for (ActivityRemark remark : activityRemarks) {
            User user1 = userMapper.selectByPrimaryKey(remark.getOwner());
            remark.setImg(user1.getImg());

            //设置市场活动名称
            remark.setActivityId(activity.getName());
        }
        activity.setActivityRemarks(activityRemarks);
        return activity;
    }

    //市场活动备注的添加
    @Override
    public ActivityRemark addRemark(ActivityRemark activityRemark, User user) {
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setImg(user.getImg());
        activityRemark.setCreateBy(user.getName());
        activityRemark.setOwner(user.getId());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        int i = activityRemarkMapper.insertSelective(activityRemark);
        if (i == 0) {
            throw new CrmException(CrmEnum.ACTIVITY_REMARK_INSERT);
        }

        Activity activity = activityMapper.selectByPrimaryKey(activityRemark.getActivityId());
        activityRemark.setActivityId(activity.getName());
        return activityRemark;
    }

    //市场活动备注的删除
    @Override
    public void deleteRemark(String id) {
        int i = activityRemarkMapper.deleteByPrimaryKey(id);
        if (i == 0) {
            throw new CrmException(CrmEnum.ACTIVITY_REMARK_DELETE);
        }
    }


    //活动备注的修改更新
    @Override
    public void updateRemark(ActivityRemark activityRemark, User user) {
        //设置编辑时间和修改者
        activityRemark.setEditBy(user.getName());
        activityRemark.setImg(user.getImg());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        int i = activityRemarkMapper.updateByPrimaryKeySelective(activityRemark);
        if (i == 0) {
            throw new CrmException(CrmEnum.ACTIVITY_REMARK_UPDATE);
        }

        //设置备注的活动名称
//        activityRemark.setActivityId(activityMapper.selectByPrimaryKey(activityRemark.getActivityId()).getName());

    }


    //导出数据表格
    @Override
    public ExcelWriter exportExcel(ExcelWriter writer) {
        //反射获取原类的属性数组
        Field[] declaredFields = Activity.class.getDeclaredFields();
        List<Activity> activities = activityMapper.selectAll();
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
        writer.addHeaderAlias("id", "id编号") ;
        writer.addHeaderAlias("owner", "所有者") ;
        writer.addHeaderAlias("name", "市场活动名称");
        writer.addHeaderAlias("startDate", "开始日期") ;
        writer.addHeaderAlias("endDate", "结束日期") ;
        writer.addHeaderAlias("cost", "预算") ;
        writer.addHeaderAlias("description", "描述") ;
        writer.addHeaderAlias("createTime", "创建日期") ;
        writer.addHeaderAlias("createBy", "创建者") ;
        writer.addHeaderAlias("editTime", "更新时间") ;
        writer.addHeaderAlias("editBy", "修改者") ;
        writer.addHeaderAlias("activityRemarks", "备注");

        //合并单元格
        writer.merge(declaredFields.length - 1, "市场活动统计数据");
        writer.write(activities, true);
        return writer;
    }
}

