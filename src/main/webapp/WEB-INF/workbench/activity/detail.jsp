<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <link href="/crm/jquery/layer-3.5.1/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
	});
	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myEditModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <%--隐藏域 打开模态框时传递过来的参数--%>
                        <input type="hidden" id="remarkFormId" name="id">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-发传单 <small>2020-10-10 ~ 2020-10-20</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="owner"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="name"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="startDate"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="endDate"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="cost"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">&nbsp;&nbsp;</b>&nbsp;&nbsp;<small style="font-size: 10px; color: gray;" id="createTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy" >&nbsp;&nbsp;</b>&nbsp;&nbsp;<small style="font-size: 10px; color: gray;" id="editTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" onclick="addRemark()" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
<script>

	//=============抽取一个刷新备注列表的方法===========
	function refresh(activityRemark) {
		$('#remarkDiv').before("<div class=\"remarkDiv\" id="+activityRemark.id+"remarkDiv style=\"height: 60px;\">\n" +
				"\t\t\t\t<img title=\"zhangsan\" src='"+activityRemark.img+"' style=\"width: 30px; height:30px;\">\n" +
				"\t\t\t\t<div style=\"position: relative; top: -40px; left: 40px;\" >\n" +
				"\t\t\t\t\t<h5 id="+activityRemark.id+"h5>"+activityRemark.noteContent+"</h5>\n" +
				"\t\t\t\t\t<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>"+activityRemark.activityId+"</b> <small style=\"color: gray;\"> "+activityRemark.createTime+" 由"+activityRemark.createBy+"创建，由"+activityRemark.editBy+"于"+activityRemark.editTime+"修改</small>\n" +
				"\t\t\t\t\t<div style=\"position: relative; left: 550px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
				"\t\t\t\t\t\t<a class=\"myHref\" onclick=\"openActivityRemarkModal('"+activityRemark.id+"','"+activityRemark.noteContent+"')\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
				"\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;\n" +
				"\t\t\t\t\t\t<a class=\"myHref\" onclick=\"deleteActivityRemark('"+activityRemark.id+"')\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
				"\t\t\t\t\t</div>\n" +
				"\t\t\t\t</div>\n" +
				"\t\t\t</div>");

		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
	}
	<%--查询市场活动信息  显示到详情页--%>
	$.post("/crm/workbench/activity/toDetail",{
		'id':'${activityId}'
	},function(data){
		//根据查询到的数据  拼接页面
		//显示市场活动信息
		$('#time').text(data.startDate + "~" +data.endDate);
		$('#owner').text(data.owner);
		$('#name').text(data.name);
		$('#startDate').text(data.startDate);
		$('#endDate').text(data.endDate);
		$('#cost').text(data.cost);
		$('#createBy').text(data.createBy);
		$('#createTime').text(data.createTime);
		$('#editBy').text(data.editBy);
		$('#editTime').text(data.editTime);
		$('#editTime').text(data.editTime);
		$('#description').text(data.description);

		//拼返回的备注
		var activityRemarks = data.activityRemarks;
		for (var i = 0;i <activityRemarks.length;i++){
			var activityRemark = activityRemarks[i];
			refresh(activityRemark);
		}
	},'json');

//	市场活动备注的添加   点击文本框保存输入的信息=====================
    function addRemark() {
        $.post("/crm/workbench/activity/addRemark",{
            'activityId':'${activityId}',
            'noteContent':$("#remark").val()
        },function(data){
            var activityRemark = data.t;
            if (data.ok){
                layer.alert(data.mess, {icon: 6});
            //    清空文本框
                $("#remark").val("");
                refresh(activityRemark);
            }else {
                layer.alert(data.mess, {icon: 4});
            }
        },'json')
    }
    //============市场活动备注的删除=============
    //市场活动备注是动态生成的  前面我们说有两种方法
    //前面采用的是第一种方法  即在不是动态生成的父类元素上绑定一个on('事件'，'绑定元素'，'触发的函数')
    //这里我们试试在动态生成的元素中绑定函数
    function deleteActivityRemark(id) {
        //确定删除吗
        layer.msg('确定删除该条市场活动备注吗', {
            time: 0 //不自动关闭
            ,btn: ['确定', '取消']
            ,yes: function(index){
                layer.close(index);
                $.post("/crm/workbench/activity/deleteRemark",{
                    'id':id
                },function (data) {
                    if (data.ok){
                        layer.alert(data.mess, {icon: 6});
                        // refresh(activityRemark);  这里没有返回activityRemark对象
                        //所以无法刷新  只能从页面删除dom元素
                        $("#"+id+"remarkDiv").remove();
                    }else{
                        layer.alert(data.mess, {icon: 5});
                    }
                },'json');
            }
        });
    }

    //备注的修改==============
    function openActivityRemarkModal(id,noteContent) {
        //打开模态框   把id值设置到隐藏域中 后面修改保存时要用
        $("#editRemarkModal").modal('show');
        $("#remarkFormId").val(id);

        //把内容直接写进文本域中 这里可以少写一次查询
        $("#noteContent").val(noteContent);
    }

    //给修改备注的按钮添加绑定事件
    $("#updateRemarkBtn").click(function () {
        $.post("/crm/workbench/activity/updateRemark",{
            'id':$("#remarkFormId").val(),
            'noteContent':$("#noteContent").val()
        },function (data) {
          /*  alert(111);
            var activityRemark = data.t;*/
            if (data.ok){
                layer.alert(data.mess, {icon: 6});
                //关闭模态框  刷新页面
                $("#editRemarkModal").modal('hide');
                //把之前的节点删除了【这种方法不行】
                // $("#"+id+"remarkDiv").remove();
                // refresh(activityRemark);

                var h5 = $('#remarkFormId').val() + "h5";
                //直接把输入框的值给h5标签
                //用户输入的备注弹窗中的文本域内容
                var noteContent = $('#noteContent').val();
                $("#" + h5).text(noteContent);

            }
        },'json');
    });
    

    



</script>
</body>
</html>