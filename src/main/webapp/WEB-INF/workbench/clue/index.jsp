<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="/crm/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<%--弹窗--%>
<link href="/crm/jquery/layer-3.5.1/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>

<%--分页插件--%>
<link href="/crm/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="/crm/jquery/bs_pagination/en.js" charset="UTF-8"></script>

<script type="text/javascript"></script>
</head>

<body>
<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="clueActivityForm" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="owner" id="create-clueOwner">
                                <option></option>
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" name="company" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="appellation" id="create-call">
                                <option></option>
                                <c:forEach items="${dics['appellation']}" var="dicValue">
                                    <option value="${dicValue.value}">${ dicValue.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" name="fullname" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text"  name="job" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" name="email"  class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" name="phone" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" name="website" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" name="mphone" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="state" id="create-status">
                                <option></option>
                                <c:forEach items="${dics['clueState']}" var="dicValue" >
                                    <option value="${dicValue.value}">${dicValue.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="source" id="create-source">
                                <option></option>
                                <c:forEach items="${dics['source']}" var="dicValue">
                                    <option value="${dicValue.value}">${dicValue.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" name="description" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" name="contactSummary"  rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control"  name="nextContactTime"  id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control"  name="address" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="reset()">关闭</button>
                <button type="button" class="btn btn-primary" onclick="saveClue()" data-dismiss="modal">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
<div class="modal-dialog" role="document" style="width: 90%;">
<div class="modal-content">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
            <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title">修改线索</h4>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" role="form" id="updateForm">
                <%--隐藏域  存放线索的id--%>
            <input type="hidden" id="clueId" name="id">
            <div class="form-group">
                <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                <div class="col-sm-10" style="width: 300px;">
                    <select class="form-control" name="owner" id="edit-clueOwner">
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}">${user.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" name="company" id="edit-company" >
                </div>
            </div>

            <div class="form-group">
                <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                <div class="col-sm-10" style="width: 300px;">
                    <select class="form-control" name="appellation" id="edit-call">
                      <option></option>
                        <c:forEach items="${dics['appellation']}" var="dicValue">
                            <option value="${dicValue.value}">${dicValue.text}</option>
                        </c:forEach>
                    </select>
                </div>
                <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" name="fullname" id="edit-surname" >
                </div>
            </div>

            <div class="form-group">
                <label for="edit-job" class="col-sm-2 control-label">职位</label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" id="edit-job" name="job">
                </div>
                <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" id="edit-email" name="email">
                </div>
            </div>

            <div class="form-group">
                <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" id="edit-phone" name="phone">
                </div>
                <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" name="website" id="edit-website" >
                </div>
            </div>

            <div class="form-group">
                <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                <div class="col-sm-10" style="width: 300px;">
                    <input type="text" class="form-control" id="edit-mphone" name="mphone">
                </div>
                <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                <div class="col-sm-10" style="width: 300px;">
                    <select class="form-control" name="state" id="edit-state">
                        <option></option>
                        <c:forEach items="${dics['clueState']}" var="dicValue">
                            <option value="${dicValue.value}">${dicValue.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                <div class="col-sm-10" style="width: 300px;">
                    <select class="form-control" name="source" id="edit-source">
                        <option></option>
                        <c:forEach items="${dics['source']}" var="dicValue">
                            <option value="${dicValue.value}">${dicValue.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="edit-description" class="col-sm-2 control-label">描述</label>
                <div class="col-sm-10" style="width: 81%;">
                    <textarea class="form-control" name="description" rows="3" id="edit-description"></textarea>
                </div>
            </div>

            <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

            <div style="position: relative;top: 15px;">
                <div class="form-group">
                    <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                    <div class="col-sm-10" style="width: 81%;">
                        <textarea class="form-control" name="contactSummary" rows="3" id="edit-contactSummary"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                    <div class="col-sm-10" style="width: 300px;">
                        <input type="text" name="nextContactTime" class="form-control" id="edit-nextContactTime" >
                    </div>
                </div>
            </div>

            <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

            <div style="position: relative;top: 20px;">
                <div class="form-group">
                    <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                    <div class="col-sm-10" style="width: 81%;">
                        <textarea class="form-control" name="address" rows="1" id="edit-address"></textarea>
                    </div>
                </div>
            </div>
        </form>

    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" onclick="updateClue()" class="btn btn-primary" data-dismiss="modal">更新</button>
    </div>
</div>
</div>
</div>




<div>
<div style="position: relative; left: 10px; top: -10px;">
<div class="page-header">
    <h3>线索列表</h3>
</div>
</div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

<div class="btn-toolbar" role="toolbar" style="height: 80px;">
    <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">名称</div>
          <input class="form-control" id="fullname"  type="text">
        </div>
      </div>

      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">公司</div>
          <input class="form-control" id="company" type="text">
        </div>
      </div>

      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">公司座机</div>
          <input class="form-control" id="phone" type="text">
        </div>
      </div>

      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">线索来源</div>
          <select class="form-control" id="source">
              <option></option>
             <c:forEach items="${dics['source']}" var="dicValue">
                 <option value="${dicValue.value}">${dicValue.text}</option>
             </c:forEach>
          </select>
        </div>
      </div>

      <br>

      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">所有者</div>
          <input class="form-control" id="owner" type="text">
        </div>
      </div>



      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">手机</div>
          <input class="form-control" id="mphone" type="text">
        </div>
      </div>

      <div class="form-group">
        <div class="input-group">
          <div class="input-group-addon">线索状态</div>
            <select class="form-control" id="state">
                <option></option>
                <c:forEach items="${dics['clueState']}" var="dicValue">
                    <option value="${dicValue.value}">${dicValue.text}</option>
                </c:forEach>
            </select>
        </div>
      </div>

      <button type="button" onclick="queryClue()" class="btn btn-default">查询</button>

    </form>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
    <div class="btn-group" style="position: relative; top: 18%;">
      <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
      <button type="button" onclick="openModal()" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
      <button type="button" onclick="deleteClue()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
        <button type="button" onclick="exportExcel()" class="btn btn-success"><span class="glyphicon glyphicon-download-alt"></span> 导出报表</button>
    </div>


</div>
<div style="position: relative;top: 20px;">
    <table class="table table-hover">
        <thead>
            <tr style="color: #B3B3B3;">
                <td><input type="checkbox" id="father"/></td>
                <td>名称</td>
                <td>公司</td>
                <td>公司座机</td>
                <td>手机</td>
                <td>线索来源</td>
                <td>所有者</td>
                <td>线索状态</td>
            </tr>
        </thead>
        <tbody id="clueBody">
        <%--	<tr>
                <td><input type="checkbox" /></td>
                <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
                <td>动力节点</td>
                <td>010-84846003</td>
                <td>12345678901</td>
                <td>广告</td>
                <td>zhangsan</td>
                <td>已联系</td>
            </tr>--%>
        </tbody>
    </table>
</div>

       <div id="cluePage">

   </div>

</div>
</div>

<script>
<%--刷新页面的方法--%>
function refresh(page,pageSize) {
    $.get("/crm/workbench/clue/list",{
        'page':page,
        'pageSize':pageSize,
        'fullname':$("#fullname").val(),
        'company':$("#company").val(),
        'phone':$("#phone").val(),
        'source':$("#source").val(),
        'owner':$("#owner").val(),
        'mphone':$("#mphone").val(),
        'state':$("#state").val()
    },function(data){
        var clues = data.list;
        $("#clueBody").html("");
        for (var i =0;i <clues.length;i++){
            var clue = clues[i];
            //    拼接页面
            $("#clueBody").append("<tr>\n" +
                "\t\t\t\t\t\t\t<td><input type=\"checkbox\" value="+clue.id+" class='son'/></td>\n" +
                "\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/clue/detail?id="+clue.id+"';\">"+clue.fullname+"</a></td>\n" +
                "\t\t\t\t\t\t\t<td>"+clue.company+"</td>\n" +
                "\t\t\t\t\t\t\t<td>"+clue.phone+"</td>\n" +
                "\t\t\t\t\t\t\t<td>"+clue.mphone+"</td>\n" +
                "\t\t\t\t\t\t\t<td>"+clue.source+"</td>\n" +
                "\t\t\t\t\t\t\t<td>"+clue.owner+"</td>\n" +
                "\t\t\t\t\t\t\t<td>"+clue.state+"</td>\n" +
                "\t\t\t\t\t\t</tr>");

            //拼分页
            $("#cluePage").bs_pagination({
                currentPage: data.pageNum, // 页码
                rowsPerPage: data.pageSize, // 每页显示的记录条数
                maxRowsPerPage: 10, // 每页最多显示的记录条数
                totalPages: data.pages, // 总页数
                totalRows: data.total, // 总记录条数
                visiblePageLinks: 5, // 显示几个卡片
                showGoToPage: true,
                showRowsPerPage: true,
                showRowsInfo: true,
                showRowsDefaultInfo: true,
                //回调函数，用户每次点击分页插件进行翻页的时候就会触发该函数
                onChangePage : function(event, obj){
                    //刷新页面，obj.currentPage:当前点击的页码
                    //pageList(obj.currentPage,obj.rowsPerPage);
                    refresh(obj.currentPage,obj.rowsPerPage);
                    //把全选按钮取消掉
                    $("#father").prop("checked",false);
                }
            });
            }
    },'json')
}

refresh(1, 5);
//条件查询
    function queryClue() {
        refresh(1,5);
    }

    //线索的添加
//点击保存按钮，创建线索
function saveClue() {
    $.post("/crm/workbench/clue/saveClue",
        $('#clueActivityForm').serialize(),
        function (data) {
            if (data.ok){
                layer.alert(data.mess, {icon: 6});
                //添加成功，刷新页面
                refresh(1,5);
                //怎么清空一下输入框
                // reset();
                $("#clueActivityForm")[0].reset();

            }else {
                layer.alert(data.mess, {icon: 5});
            }
        },'json');
}

/*
function reset() {
    $("#createClueModal input").val("")
    $("#createClueModal textarea").val("")
    $("#createClueModal select").prop("selectedIndex",0)
}
*/

//===============================
//全选和反选
$("#father").click(function () {
    $(".son").prop("checked",$("#father").prop("checked"));
});
//反选   先判断总元素个数
$("#clueBody").on('click','.son',function () {
    //先获取总元素个数
    var totalLength = $(".son").length;
    //选中的元素的个数
    var checkedLength = $(".son:checked").length;

    //判断个数是否相等
    if (totalLength == checkedLength){
        //反选中父类元素
        $("#father").prop("checked",true)
    }else {
        //不选中
        $("#father").prop("checked",false)
    }
})
//线索的删除

function deleteClue() {
    var length = $(".son:checked").length;

    if (length>0){


    //给出一个数组 存放获取的线索id
    var ids = [];
    $('.son:checked').each(function () {
        ids.push($(this).val());
    });
    layer.confirm('确认删除线索吗？', {
        btn: ['确定', '取消'] //可以无限个按钮
    }, function(index, layero){
        //按钮【按钮一】的回调
        layer.close(index);

        //发送请求
        $.post("/crm/workbench/clue/deleteClue",{
            'ids':ids.join()
        },function (data) {
            if(data.ok){
                layer.alert(data.mess,{icon:6});
                //添加成功，手动刷新页面
                refresh(1,5);
            }else {
                layer.alert(data.mess,{icon:5});
            }
        },'json');

    }, function(index){
    });
    }
}

//线索的修改
//点击修改   弹出模态框  把id放到隐藏域中
    function openModal() {
    var length  = $(".son:checked").length;
    if (length == 0){
        layer.alert("请先选中要修改的记录",{icon:4});
    } else if(length > 1){
        layer.alert("一次只能修改一条记录",{icon:4});
    }else {
        //打开模态框   根据id查询信息   反写数据
        $("#editClueModal").modal('show');
        $.post("/crm/workbench/clue/queryClueById",{
            'id':$(".son:checked").val()
        },function (data) {
            //拼接数据
            $("#edit-clueOwner").val(data.owner);
            $("#edit-company").val(data.company);
            $("#edit-surname").val(data.fullname);
            $("#edit-call").val(data.appellation);
            $("#edit-job").val(data.job);
            $("#edit-email").val(data.email);
            $("#edit-phone").val(data.phone);
            $("#edit-website").val(data.website);
            $("#edit-mphone").val(data.mphone);
            $("#edit-state").val(data.state);
            $("#edit-source").val(data.source);
            $("#edit-description").val(data.description);
            $("#edit-contactSummary").val(data.contactSummary);
            $("#edit-nextContactTime").val(data.nextContactTime);
            $("#edit-address").val(data.address);
            //把id存放到隐藏域中
            $("#clueId").val(data.id);
        },'json')
    }
    }

    //点击更新按钮  更新线索信息
    function updateClue() {
    var form = $("#updateForm").serialize();
        $.post("/crm/workbench/clue/updateClue", form,function (data) {
            if(data.ok){
                layer.alert(data.mess,{icon:6});
                //添加成功，手动刷新页面
                refresh(1,5);
            }else {
                layer.alert(data.mess,{icon:5});
            }
        },'json')
    }
//导出报表
function exportExcel() {
    location.href = "/crm/workbench/clue/exportExcel";

}



</script>
</div>
</body>
</html>