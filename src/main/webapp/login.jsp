<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="/crm/jquery/layer-3.5.1/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>
</head>
<body id="body">
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg"></span>
						
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
<script>
	<%--登录--%>
	<%--按下回车键发送登录请求--%>
	<%--1.给body绑定键盘事件--%>

	//按下回车键触发 keypress = keydown + keyup
	$('#body').keypress(function (event) {
		if(event.keyCode == 13){
			$.post("/crm/settings/user/login",{
				'loginAct' : $('#loginAct').val(),
				'loginPwd' : $('#loginPwd').val()
			},function(data){
				//data=resultVo
				if(!data.ok){
					layer.alert(data.mess, {icon: 5});
				}else {
					//密码正确  跳转到主页面  发送异步请求
					window.location.href="/crm/settings/user/toIndex";
				}
			},'json')
		}
	});

//	给登陆按钮添加点击事件
	$("#loginBtn").click(function () {
		$.post("/crm/settings/user/login",{
			'loginAct':$("#loginAct").val(),
			'loginPwd':$("#loginPwd").val()
		},function (data) {
			//密码或用户名不正确
			if (!data.ok){
				layer.alert(data.mess,{icon:2})
			}else {
				//密码正确  跳转到主页面  发送异步请求
				window.location.href="/crm/settings/user/toIndex";
			}
		},'json');
	});





</script>
</body>
</html>