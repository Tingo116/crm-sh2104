package com.bjpowernode.crm.test;

import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import org.junit.Test;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.UUID;

public class CrmTest {

    //tkMapper的添加操作
    @Test
    public void test01(){
        BeanFactory beanFactory = new ClassPathXmlApplicationContext("classpath:spring/applicationContext.xml");
        UserMapper userMapper = (UserMapper) beanFactory.getBean("userMapper");
        User user = new User();

        //只插入非空字段
        //userMapper.insertSelective();
    }

    //测试UUID
    @Test
    public void test02(){
        String uuid = UUID.randomUUID().toString().replace("-","");
        System.out.println(uuid);
    }
}
