<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="/crm/jquery/layer-3.5.1/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>
	<script type="text/javascript" src="/crm/jquery/ajaxfileupload.js"></script>
<script type="text/javascript">

	//页面加载完毕
	$(function(){
		//导航中所有文本颜色为黑色
		$(".liClass > a").css("color" , "black");
		
		//默认选中导航菜单中的第一个菜单项
		$(".liClass:first").addClass("active");
		
		//第一个菜单项的文字变成白色
		$(".liClass:first > a").css("color" , "white");
		
		//给所有的菜单项注册鼠标单击事件
		$(".liClass").click(function(){
			//移除所有菜单项的激活状态
			$(".liClass").removeClass("active");
			//导航中所有文本颜色为黑色
			$(".liClass > a").css("color" , "black");
			//当前项目被选中
			$(this).addClass("active");
			//当前项目颜色变成白色
			$(this).children("a").css("color","white");
		});

		//进入主页面时显示图片的  写一个统一跳转视图的方法
		//workareaFrame:iframe  分区后的名字   可以跳转到指定页面

		window.open("/crm/toView/workbench/main/index","workareaFrame");
		
	});

</script>

	<style>
		.item label{
			display: inline-block;
			width: 100px;
			height: 30px;
			text-align: center;
			color: #fff;
			line-height: 30px;
			background-color: skyblue;
			border-radius: 5px;
			cursor: pointer;
			margin-left: 15px;
		}
		.item input{
			display: none;
		}
	</style>

</head>
<body>
	
	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>${user.name}</b><br><br>
						登录帐号：<b>${user.loginAct}</b><br><br>
						组织机构：<b>1005，市场部，二级部门</b><br><br>
						邮箱：<b>${user.email}</b><br><br>
						失效时间：<b>${user.expireTime}</b><br><br>
						允许访问IP：<b>${user.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="updateMessage">
						<%--放一个隐藏域  存放头像地址--%>
						<input type="hidden" id="img">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
						<div class="form-group">
							<label for="file1" class="col-sm-2 control-label">上传图片</label>
							<div class="item">
								<label for="file1">上传图片</label>
								<input name="file1" type="file" id="file1">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary"  onclick="updateMessage()">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='/crm/settings/user/loginOut';">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;动力节点</span></div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<%--<span class="glyphicon glyphicon-user"></span>${user.name}<span class="caret"></span>--%>
						<%--显示更新后的头像 判断头像地址是否为空 注意控制器也要改变--%>
							<img id="photo" style="display:none;border-radius: 100%;width: 30px;height: 30px" />
						<c:choose>
							<c:when test="${not empty user.img}">
							<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
								<img src="${user.img}" style="border-radius: 100%;width: 28px;height: 29px">&nbsp;${user.name}<span class="caret"></span>
							</c:when>
							<c:otherwise>
								<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
								<span id="span" class="glyphicon glyphicon-user"></span>${user.name}<span class="caret"></span>
							</c:otherwise>
						</c:choose>
					</a>
					<ul class="dropdown-menu">
						<li><a href="/crm/settings/index.html"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 中间 -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
	
		<!-- 导航 -->
		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		
			<ul id="no1" class="nav nav-pills nav-stacked">
				<li class="liClass"><a href="main/index.html" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-tag"></span> 动态</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-time"></span> 审批</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户公海</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/activity/index" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 市场活动</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/clue/index" target="workareaFrame"><span class="glyphicon glyphicon-search"></span> 线索（潜在客户）</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/customer/index" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/contacts/index" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 联系人</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/transaction/index" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 交易（商机）</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/visit/index" target="workareaFrame"><span class="glyphicon glyphicon-phone-alt"></span> 售后回访</a></li>
				<li class="liClass">
					<a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span> 统计图表</a>
					<ul id="no2" class="nav nav-pills nav-stacked collapse">
						<li class="liClass"><a href="chart/activity/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 市场活动统计图表</a></li>
						<li class="liClass"><a href="chart/clue/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 线索统计图表</a></li>
						<li class="liClass"><a href="chart/customerAndContacts/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 客户和联系人统计图表</a></li>
						<li class="liClass"><a href="chart/transaction/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 交易统计图表</a></li>
					</ul>
				</li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-file"></span> 报表</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-shopping-cart"></span> 销售订单</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-send"></span> 发货单</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 跟进</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-leaf"></span> 产品</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 报价</a></li>
			</ul>
			
			<!-- 分割线 -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>
		
		<!-- 工作区 -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
		
	</div>
	
	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>
	
	<!-- 底部 -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
<script>
	<%--当输入框失去焦点的时候  异步校验原始密码是否正确--%>
	$("#oldPwd").blur(function () {
		//失去焦点  判断原始密码是否正确
		$.post("/crm/settings/user/verifyOldPwd",{
			'oldPwd':$("#oldPwd").val()
		},function (data) {
			if (!data.ok) {
				layer.alert(data.mess, {icon: 5});
				//原始密码框重新获得焦点
				return;
			}
		},'json');
	});
	//当新密码输入框  失去焦点时  验证是否为空
	$("#newPwd").blur(function () {
		var newPwd = $("#newPwd").val();
		if (newPwd == null || newPwd == ""){
			layer.alert("新密码不能为空，请重新输入",{icon:2});
		}
	});



//	异步上传头像  绑定change事件
	//异步上传文件

	//异步上传文件
	$('#file1').change(function () {
		$.ajaxFileUpload({
					url: '/crm/settings/user/fileUpload', //用于文件上传的服务器端请求地址
					fileElementId: 'file1', //文件上传域的ID
					dataType: 'json', //返回值类型 一般设置为json
					success : function (data,status) {
						if(data.ok){
							//上传成功
							layer.alert(data.mess, {icon: 6});
							//attr:自定义属性 prop:固有属性
								$('#photo').prop('src',data.t);
								$('#photo').css('display',"inline");
								$('#span').css('display',"none");
							//把头像隐藏域设置成图片路径
							$('#img').val(data.t);
						}else{
							//上传失败
							layer.alert(data.mess, {icon: 5});
						}
					},
				}
		)
		return false;
	});

//	点击修改密码资料模态框中的确定 修改密码和头像  传递的参数有  新密码  和 头像的地址
	//因为要传头像的地址   整一个隐藏域  放头像地址
	function updateMessage() {
		//校验密码不能为空
		var newPwd = $("#newPwd").val();
		var confirmPwd = $("#confirmPwd").val();
	    if (newPwd != confirmPwd){
			layer.alert("两次密码输入不一致，请重新输入",{icon:2});
			return false;
		}else {
			$.ajax({
				url : '/crm/settings/user/updateMessage',
				data :{
					'loginPwd':$("#newPwd").val(),
					'img':$("#img").val()
				},
				dataType : 'json',
				success : function(data){
					if (data.ok){
						layer.alert(data.mess, {icon: 6});
						$("#editPwdModal").modal('hide');
					}
				}
			});
		}



	}



</script>
	
</body>
</html>