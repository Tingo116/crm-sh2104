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
<%--弹窗--%>
<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/layer.js"></script>
<script type="text/javascript">
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="addActivity">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="create-marketActivityOwner">
									<option value="">请选择</option>
									<%--从缓存区中获取--%>
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								 <%-- <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" name="name" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="startDate" class="form-control" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="endDate" class="form-control" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" name="cost" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" name="description" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="addOrUpdateActivity($('#addActivity'))">保存</button>
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
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="updateActivityForm">
					<%--放一个隐藏域   这里保存市场活动的时候要根据主键来保存--%>
						<input type="hidden" id="activityId" name="id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="edit-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" name="name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" name="startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" name="endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" name="cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe" name="description">
								</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" onclick="addOrUpdateActivity($('#updateActivityForm'))" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" name="name" id="name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" name="owner" id="owner" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" name="startDate" type="text" id="startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" name="endDate" type="text" id="endTime">
				    </div>
				  </div>
				  
				  <button type="button" onclick="queryActivity()" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" onclick="openUpdateModal()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" onclick="deleteActivity()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="father" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>--%>

					</tbody>
				</table>
			</div>
			
			<div id="activityPage">
		</div>
		</div>
	</div>
<script>
	<%--解决分页乱码问题--%>
	var rsc_bs_pag = {
		go_to_page_title: 'Go to page',
		rows_per_page_title: 'Rows per page',
		current_page_label: 'Page',
		current_page_abbr_label: 'p.',
		total_pages_label: 'of',
		total_pages_abbr_label: '/',
		total_rows_label: 'of',
		rows_info_records: 'records',
		go_top_text: '首页',
		go_prev_text: '上一页',
		go_next_text: '下一页',
		go_last_text: '末页'
	};
	refresh(1,5);
	<%--定义一个刷新页面的方法   包括分页  模糊查询--%>
	function refresh(page,pageSize) {
		$.get("/crm/workbench/activity/list",{
			'page':page,
			'pageSize':pageSize,
			'name':$('#name').val(),
			'owner':$('#owner').val(),
			'startDate':$('#startTime').val(),
			'endDate':$('#endTime').val()
		},function(data){
			var activities = data.list;
			$("#activityBody").html("");
		//	动态生成市场活动
			for (var i = 0;i <activities.length;i ++ ){
				var activity = activities[i];
				$("#activityBody").append("<tr class=\"active\">\n" +
						"\t\t\t\t\t\t\t<td><input type=\"checkbox\" value="+activity.id+" class='son' /></td>\n" +
						"\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/activity/detail?activityId="+activity.id+"';\">"+activity.name+"</a></td>\n" +
						"                            <td>"+activity.owner+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+activity.startDate+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+activity.endDate+"</td>\n" +
						"\t\t\t\t\t\t</tr>");

				//动态拼成分页
				//利用分页插件查询第一页数据
				$("#activityPage").bs_pagination({
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
		},'json');
	}

	//	=====================市场活动  条件查询的实现================================
	function queryActivity() {
		refresh(1,3);
	}

//	========================市场活动的创建===================================
	//模态框里面有一个所有者下拉框 放到缓存中去 直接获取
	//点击按钮  添加市场活动
	function addOrUpdateActivity(form) {
		var form = form.serialize();
		$.post("/crm/workbench/activity/addOrUpdateActivity",form,function (data) {
			if (data.ok){
				layer.alert(data.mess, {icon: 6});
				refresh(1,5);
				// 重置表单
				$("#saveActivityForm")[0].reset();
			}else {
				layer.alert(data.mess, {icon: 5});
			}
		},'json');
	}
	//========================市场活动的修改==================
	//1.先要判断只能选择一条记录 才弹出模态框  并且要根据id查询出选中的市场活动的信息
	function openUpdateModal() {
		var length = $(".son:checked").length;
		if (length == 0){
			layer.alert("请先选中要修改的市场活动", {icon: 4});
		} else if (length > 1){
			layer.alert("一次只能修改一条市场活动信息", {icon: 2});
		} else {
			//发送请求 要传参活动id 查询信息
			// alert($(".son:checked")[0].value);
			$("#editActivityModal").modal('show');
			$.post("/crm/workbench/activity/queryActivity",{
				'id':$(".son:checked")[0].value
			},function(data){
				$("#edit-marketActivityOwner").val(data.owner);
				$("#edit-marketActivityName").val(data.name);
				$("#edit-startTime").val(data.startDate);
				$("#edit-endTime").val(data.endDate);
				$("#edit-cost").val(data.cost);
				$("#edit-describe").val(data.description);

				//把id存放到隐藏域中 保存市场活动的时候需要用id
				$("#activityId").val(data.id)

			},'json');
		}
	}

//	===================全选和反选====================
//	全选
	$("#father").click(function () {
		$('.son').prop('checked',$("#father").prop('checked'));
	});

	//反选功能的实现  动态生成的son元素  绑定事件实现有两种方式
	//1.委托给父类元素（这个也不能是动态生成）用on事件
	//2.动态生成时  绑定事件  在checked属性里面   添加点击事件  在调已经存在的函数
	//这种是可以的
	$("#activityBody").on('click','.son',function () {
		//定义选中的长度   和总长度
		var checkedLength = $(".son:checked").length;
		var totalLength = $(".son").length;
		//判断是否相等
		if (checkedLength == totalLength){
			$("#father").prop("checked",true);
		} else {
			$("#father").prop("checked",false);
		}
	});
	//=====================市场活动的批量删除==========================
	function deleteActivity() {
		//判断是否至少选中一条
		var checkedLength = $(".son:checked").length;
		//定义一个数组  存放选中的id
		var ids = [];

		// 遍历选中的元素的id  这里是js对象   取值要用value
		//如果要转换成jquery对象 前面要加$
		// alert($(".son:checked")[0].value);
		//多个要遍历
		$(".son:checked").each(function () {
			//push  是放进数组  但是从前端传到后台的数据  不能是数组
			//因此下面的数据要使用join()方法传参
			ids.push($(".son:checked")[0].value);
		});
		// alert(ids);
		if (checkedLength > 0){
			//给出提示 弹出再次确认按钮
			//信息框-例2

			layer.msg('你确定删除这'+$(".son:checked").length+"条记录吗？", {
				time: 0 //不自动关闭
				,btn: ['确定', '取消']
				,yes: function(index){
				/*	layer.close(index);
					layer.msg('雅蠛蝶 O.o', {
						icon: 6
						,btn: ['嗷','嗷','嗷']
					});*/

					//发送请求
					$.post("/crm/workbench/activity/deleteActivity",{
						'ids':ids.join()
					},function(data){
						if (data.ok){
							layer.alert(data.mess, {icon: 6});
							refresh(1,5);
							//如果是全选删除的话  这个会一直勾中  将其选中特性设为false
							$("#father").prop("checked",false);
						}else{
							layer.alert(data.mess, {icon: 5});
						}
					},'json');
				}
			});
		}else {
			layer.alert("先选中再来吧", {icon: 4});
		}

	}


</script>
</body>
</html>