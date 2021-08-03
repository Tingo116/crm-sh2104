package com.bjpowernode.crm.base.util;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

//上传文件工具类
public class FileUploadUtil {

    //这里要用到request中的一个方法 因此要用request来接参数  还要把图片地址设置到resultVo中
    public static ResultVo fileUpload(MultipartFile file1, HttpServletRequest request){
        ResultVo resultVo = new ResultVo();
        try {
            String realPath = request.getSession().getServletContext().getRealPath("/upload");
//        File类只是查找文件，操作文件必须使用io流
            //文件：操作系统只有文件这一个概念
            File file = new File(realPath);
            //如果文件不存在  创建多级目录
            if (!file.exists()){
                file.mkdirs();
            }
            //为 不同客户端指定不同的文件名   防止重名
            String filename = file1.getOriginalFilename();
            //前面加上时间戳
            filename = System.currentTimeMillis()+filename;

            //检验文件大小和格式  是否符合要求
            verifyMaxPhone(file1);
            verifySuffix(filename);
            //上传文件
            file1.transferTo(new File(realPath+File.separator+filename));
            resultVo.setOk(true);
            resultVo.setMess("头像上传成功");


            //============将图片地址设置到返回对象中
            String contextPath = request.getContextPath();
            //看看这是啥
            System.out.println("contextPath = " + contextPath);
            //凭接能访问的地址
            String src = contextPath + File.separator + "upload" + File.separator + filename;
            System.out.println("src = " + src);
            //放进返回的视图中
            resultVo.setT(src);
            //==================================================
        } catch (CrmException e) {
            resultVo.setMess(e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return  resultVo;
    }

    //检验文件后缀名
    private static void verifySuffix(String filename) {
        //截取文件名后缀名
        String substring = filename.substring(filename.lastIndexOf(".") + 1);
        //判断是否有这些文件名
        String suffixs = "jpg,png,webp,bmp,gif,jpeg";
        if (!suffixs.contains(substring)){
            throw new CrmException(CrmEnum.UPLOAD_SUFFIX);
        }
    }

    //检验文件大小
    private static void verifyMaxPhone(MultipartFile file1) {
        long size = file1.getSize();
        long max = 2*1024*1024;
        if (size > max){
            throw new CrmException(CrmEnum.UPLOAD_MAX_SIZE);
        }
    }


}