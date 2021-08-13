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
	<%--分页插件--%>
	<link href="/crm/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="/crm/jquery/bs_pagination/en.js" charset="UTF-8"></script>

</head>
<body>


<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找市场活动</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<%--<form class="form-inline" role="form">--%>
					<div class="form-group has-feedback">
						<input type="text" id="activityName" class="form-control" style="width: 300px;"
							   placeholder="请输入市场活动名称，支持模糊查询">
						<span class="glyphicon glyphicon-search form-control-feedback"></span>
					</div>
					<%--</form>--%>
				</div>
				<table id="activityTable4" class="table table-hover"
					   style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
					</tr>
					</thead>
					<tbody id="aBody">
					</tbody>
				</table>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" onclick="confirmActivity()" class="btn btn-primary" data-dismiss="modal">确定
					</button>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找联系人</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">

					<div class="form-group has-feedback">
						<input type="text" id="contactName" class="form-control" style="width: 300px;"
							   placeholder="请输入联系人名称，支持模糊查询">
						<span class="glyphicon glyphicon-search form-control-feedback"></span>
					</div>

				</div>
				<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>邮箱</td>
						<td>手机</td>
					</tr>
					</thead>
					<tbody id="contactBody">
					<%-- <tr>
                         <td><input type="radio" name="activity"/></td>
                         <td>李四</td>
                         <td>lisi@bjpowernode.com</td>
                         <td>12345678901</td>
                     </tr>--%>
					</tbody>
				</table>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" onclick="confirmContact()" class="btn btn-primary" data-dismiss="modal">确定
					</button>
				</div>
			</div>
		</div>
	</div>
</div>

	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" onclick="addTran()" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
<form class="form-horizontal" onsubmit="return isPay()" id="saveForm" role="form" style="position: relative; top: -30px;">
	<%--隐藏域--%>
	<input type="hidden" id="tranId" name="id">
	<div class="form-group">
		<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" name="owner" id="edit-transactionOwner">
				<c:forEach items="${users}" var="user">
					<option value="${user.id}">${user.name}</option>
				</c:forEach>
			</select>
		</div>
		<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="edit-amountOfMoney" name="money">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-transactionName" class="col-sm-2 control-label">名称<span
				style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="edit-transactionName" name="name">
		</div>
		<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
				style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" name="expectedDate" id="edit-expectedClosingDate">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span
				style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" name="customerId" id="edit-accountName"
				   placeholder="支持自动补全，输入客户不存在则新建">
		</div>
		<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span
				style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" name="stage" id="edit-transactionStage">
				<option></option>
				<c:forEach items="${dics['stage']}" var="dicValue">
					<option value="${dicValue.value}">${dicValue.text}</option>
				</c:forEach>
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" name="type" id="edit-transactionType">
				<option></option>
				<c:forEach items="${dics['transactionType']}" var="dicValue">
					<option value="${dicValue.value}">${dicValue.text}</option>
				</c:forEach>

			</select>
		</div>
		<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" class="form-control" id="edit-possibility" name="possibility">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" name="source" id="edit-clueSource">
				<option></option>
				<c:forEach items="${dics['source']}" var="dicValue">
					<option value="${dicValue.value}">${dicValue.text}</option>
				</c:forEach>
			</select>
		</div>
		<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
																						 data-toggle="modal"
																						 data-target="#findMarketActivity"><span
				class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<%--隐藏域放id--%>
			<input type="hidden" id="aid" name="activityId">
			<input type="text" class="form-control" id="edit-activitySrc">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
																						  data-toggle="modal"
																						  data-target="#findContacts"><span
				class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<%--隐藏域--%>
			<input type="hidden" id="cid" name="contactsId">
			<input type="text" class="form-control" id="edit-contactsName">
		</div>
	</div>

	<div class="form-group">
		<label for="create-describe" class="col-sm-2 control-label">描述</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" rows="3" name="description" id="create-describe"></textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea class="form-control" name="contactSummary" rows="3" id="create-contactSummary"></textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" name="nextContactTime" class="form-control" id="create-nextContactTime">
		</div>
	</div>

	</form>
<script>
	//按下回车键，查询满足条件的市场活动
	$('#activityName').keypress(function (event) {
		if (event.keyCode == 13) {
			$.get("/crm/workbench/transaction/queryActivities", {
				"name": $("#activityName").val()
			}, function (data) {
				//List<Activity>
				//清空内容
				$('#aBody').html("");
				var content = "";
				for (var i = 0; i < data.length; i++) {
					var activity = data[i];
					content += "<tr>\n" +
							"\t\t\t\t\t\t\t\t<td><input class='son' type=\"radio\" value=" + activity.id + " /></td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + activity.name + "</td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + activity.startDate + "</td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + activity.endDate + "</td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + activity.owner + "</td>\n" +
							"\t\t\t\t\t\t\t</tr>";
				}
				$('#aBody').html(content);
			}, 'json');
		}
	});

	//添加两个按钮
	//点击确定按钮  将值设置到页面中
	function confirmActivity() {
		//获取选中的市场活动的名字
		var name = $(".son:checked").parent().next().text();
		// alert(name);
		// 将这个值设置到活动源中
		$("#edit-activitySrc").val(name);
		var id = $(".son:checked").val();
		//把id设置到隐藏域中
		$("#aid").val(id);
	}

	//按下回车键，查询满足条件的市场活动
	$('#contactName').keypress(function (event) {
		if (event.keyCode == 13) {
			$.get("/crm/workbench/transaction/queryContacts", {
				"name": $("#contactName").val()
			}, function (data) {
				//List<contact>
				//清空内容
				$('#contactBody').html("");
				var content = "";
				for (var i = 0; i < data.length; i++) {
					var contact = data[i];
					content += "<tr>\n" +
							"\t\t\t\t\t\t\t\t<td><input class='son1' type=\"radio\" value=" + contact.id + " /></td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + contact.fullname + "</td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + contact.email + "</td>\n" +
							"\t\t\t\t\t\t\t\t<td>" + contact.mphone + "</td>\n" +
							"\t\t\t\t\t\t\t</tr>";
				}
				$('#contactBody').html(content);
			}, 'json');
		}
	});

	//添加两个按钮
	//点击确定按钮  将值设置到更新页面中
	function confirmContact() {
		//获取选中的市场活动的名字
		var name = $(".son1:checked").parent().next().text();
		// alert(name);
		// 将这个值设置到活动源中
		$("#edit-contactsName").val(name);
		var id = $(".son1:checked").val();
		//把id设置到隐藏域中
		$("#cid").val(id);
	}

	//填写交易状态的时候   同步修改下面的可能性
	$("#edit-transactionStage").change(function () {
		//查询可能性
		$.post("/crm/workbench/transaction/bindPossibility",{
			'stage':$(this).val()
		},function (data) {
			//返回可能性  直接返回String
			// 绑定到可能性的输入框
			$("#edit-possibility").val(data);
		},'json');
	});

	// 点击创建按钮  保存交易信息
	function addTran() {
		var form = $("#saveForm").serialize();
		$.post("/crm/workbench/transaction/addTran",form,function (data) {
			if (data.ok) {
				//更新成功  返回index页面
				window.location.href = '/crm/toView/workbench/transaction/index'
			}
		},'json');
	}

	// 简单的表单提交验证
	function isPay() {
		var cid = $("#cid").val();
		var aid = $("#aid").val();
		var  cName = $("#edit-accountName").val();
		if (cid == null || aid == null || cName == null){
			return false;
		} else {
			return true;
		}


	}

</script>
</body>
</html>