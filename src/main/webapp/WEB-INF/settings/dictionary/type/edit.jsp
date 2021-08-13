<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="/crm/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/layer.js"></script>
	<script type="text/javascript"></script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" onclick="updateType($('#editType'))" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" id="editType">
		<%--设置一个隐藏域--%>
		<input type="hidden" id="codeId" name="code">
					
		<div class="form-group">
			<label for="code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text"name="typeCode" class="form-control" id="code" style="width: 200%;" placeholder="编码作为主键，不能是中文" >
			</div>
		</div>
		
		<div class="form-group">
			<label for="name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" name="name" class="form-control" id="name" style="width: 200%;" >
			</div>
		</div>
		
		<div class="form-group">
			<label for="describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea name="description" class="form-control" rows="3" id="describe" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
<script>
	//根据typeCode查询详情页的信息
	queryTypeByCode();
	function queryTypeByCode() {
		$.post("/crm/settings/dicType/query",{
			'code':'${code}'
		},function (data) {
			//动态写入
			$("#code").val(data.code);
			$("#name").val(data.name);
			$("#describe").val(data.description)

		//	code值设置进隐藏域
			$("#codeId").val(data.code);
		},'json');
	}

	//点击更新按钮  保存修改的值
	function updateType(form) {
		var form = form.serialize();
		$.post("/crm/settings/dicType/update",form,function (data) {
			if (data.ok){
				layer.alert(data.mess,{icon:6});
				//返回到类型列表页面
				window.location.href="index";
			}else {
				layer.alert(data.mess,{icon:5});
			}
		},'json')
	}
</script>
</body>
</html>