package com.bjpowernode.crm.base.cache;

import com.bjpowernode.crm.base.bean.DicType;
import com.bjpowernode.crm.base.bean.DicValue;
import com.bjpowernode.crm.base.mapper.DicTypeMapper;
import com.bjpowernode.crm.base.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import tk.mybatis.mapper.entity.Example;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import java.util.*;

//经常用到的数据  存放到缓存区中 避免反复查询
@Component
public class CrmCache {
    //注入用户mapper   查询所有者  在服务器初始化是就加载到缓存区
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ServletContext servletContext;
    @Autowired
    private DicTypeMapper dicTypeMapper;
    @Autowired
    private DicValueMapper dicValueMapper;

    //定义一个方法  在服务器初始化是就加载进缓存区
    // 这里使用的是注解方式  需要导入依赖
    @PostConstruct
    public void init(){
        //1.缓冲所有者
        List<User> users = userMapper.selectAll();
        servletContext.setAttribute("users",users);
        //2.缓冲字典表

        //2.1先查询所有的字典值类型
        List<DicType> dicTypes = dicTypeMapper.selectAll();
        //存放code对应的value们  是一对多的关系
        HashMap<String, List<DicValue>> dics = new HashMap<>();

        //2.2  遍历所有的dicType
        for (DicType dicType : dicTypes) {

            //取出所有的key
            String code = dicType.getCode();

            //拼条件查询
            Example example = new Example(DicValue.class);

            //加一个排序的
            //升序  asc  降序  desc
            example.setOrderByClause("orderNo asc");
            example.createCriteria().andEqualTo("typeCode", code);

            List<DicValue> dicValues = dicValueMapper.selectByExample(example);
            //取出所有的value  这里一个code有多个value  上面定义一个hashmap<String,list>
            //定义好以后  把遍历的元素存进集合
            dics.put(code, dicValues);
        }
        //将其放入缓存区中
        servletContext.setAttribute("dics",dics);

        //3.缓冲状态与可能性
        // 注意  这里采用的是读取配置文件的方法
        //文件路径要注意 用.不能用/   不用写properties结尾
        ResourceBundle bundle = ResourceBundle.getBundle("mybatis.Stage2Possibility");
        Enumeration<String> keys = bundle.getKeys();
        TreeMap<String, String> stage2Possibility = new TreeMap<>();
        //遍历
        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = bundle.getString(key);
            stage2Possibility.put(key,value);
        }
        //放进缓存区
        servletContext.setAttribute("stage2Possibility",stage2Possibility);



    }
}
