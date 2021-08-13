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
	<script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>
<script type="text/javascript">

	$(function(){
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
	});
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="saveForm" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="create-customerOwner">
								  <option value="">请选择</option>
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="name" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" name="website" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="phone" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" name="description" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" name="contactSummary" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" name="nextContactTime" class="form-control" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" name="address" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="saveOrUpdateCustomer($('#saveForm'))" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="updateForm">
						<%--隐藏域  放客户id  查询和保存时都需要--%>
						<input type="hidden" id="customerId" name="id">
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner" name="owner">
								  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" name="name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" name="website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" name="phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" name="description" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" name="contactSummary" id="create-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" name="nextContactTime" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" name="address" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" onclick="saveOrUpdateCustomer($('#updateForm'))" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form"  style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="owner" type="text">
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
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="website" type="text">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" onclick="queryCustomer()">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" onclick="openModal()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" onclick="deleteCustomer()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
					<button type="button" onclick="exportExcel()" class="btn btn-success"><span class="glyphicon glyphicon-download-alt"></span> 导出报表</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="father" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="customerPage">

				</div>
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
//	定义一个刷新页面的方法   包括分页 复杂条件查询
	refresh(1,5);
	function refresh(page,pageSize) {
		$.post("/crm/workbench/customer/list",{
			'page':page,
			'pageSize':pageSize,
			'name':$("#name").val(),
			'owner':$("#owner").val(),
			'website':$("#website").val(),
			'phone':$("#phone").val()
		},function (data) {
			//先清空一下再拼
			$("#customerBody").html("");
			var customers = data.list;
			for (var i = 0;i <customers.length;i++){
				var customer = customers[i];
			//	拼页面
				$("#customerBody").append("<tr>\n" +
						"\t\t\t\t\t\t\t<td><input type=\"checkbox\" value="+customer.id+" class='son' /></td>\n" +
						"\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/customer/detail?customerId="+customer.id+"';\">"+customer.name+"</a></td>\n" +
						"\t\t\t\t\t\t\t<td>"+customer.owner+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+customer.phone+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+customer.website+"</td>\n" +
						"\t\t\t\t\t\t</tr>");

			//拼分页的
			$("#customerPage").bs_pagination({
				currentPage: data.pageNum, // 页码
				rowsPerPage: data.pageSize, // 每页显示的记录条数
				maxRowsPerPage: 10, // 每页最多显示的记录条数
				totalPages: data.pages, // 总页数
				totalRows: data.total, // 总记录条数
				visiblePageLinks: 3, // 显示几个卡片
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

	//点击查询按钮   查询所有信息
	function queryCustomer() {
		refresh(1, 5);
	}
	//全选功能的实现
	$("#father").click(function () {
		$(".son").prop("checked",$(this).prop("checked"));
	});
	//反选功能的实现  在父类元素上绑定
	$("#customerBody").on("click",'.son',function () {
		var checkedLength = $(".son:checked").length;
		var length = $(".son").length;
		if (checkedLength == length){
			$("#father").prop("checked",true);
		}else {
			$("#father").prop("checked",false);
		}
	});
	
	//删除功能的实现  要获取勾中的用户的id   所以把这个值设置到拼接页面check的value值中
	function deleteCustomer() {
	//	判断至少要选中一条记录
/*		var ids = [];
			// alert($(".son:checked").val()) 只能获取一个值
			//$(".son:checked")  这个是一个数组
			//$(".son:checked")[0]  这是一个计算对象  取值要用value 来取
		$(".son:checked").each(function () {
			/!*var id = $(".son:checked")[0].value;
            ids.push(id);*!/
			ids.push($(".son:checked")[0].value);
		});*/
		//定义一个数组用于接收选中的id
		var ids = [];
		//获取选中的id
		$(".son:checked").each(function () {
			// ids.push($(".son:checked")[0].value);  这种不行  获取的全是相同的值
			//push存入
			ids.push($(this).val());
		});
			// alert(ids);
		//判断选中的长度
		var length = $(".son:checked").length;
		if (length >0){
			//删除确认框
			layer.msg('确定删除该条市场活动备注吗', {
				time: 0 //不自动关闭
				,btn: ['确定', '取消']
				,yes: function(index){
					layer.close(index);

					//发送删除的请求
					$.post("/crm/workbench/customer/delete",{
						'ids':ids.join()
					},function (data) {
						if (data.ok){
							layer.alert(data.mess, {icon: 6});
							//刷新页面
							refresh(1,5);
						}
					},'json');
				}
			});
		}else {
			// 请先选中
			layer.alert("请先选中要删除的客户信息", {icon: 4});
		}
	}

	//新增客户
	function saveOrUpdateCustomer(form) {
		var form = form.serialize();
		$.get("/crm/workbench/customer/saveOrUpdate",form,function(data){
			if (data.ok){
				layer.alert(data.mess, {icon: 6});
				refresh(1,5);
				//重置添加表单
				$("#saveForm")[0].reset();
			} else {
				layer.alert(data.mess, {icon: 5});
			}
		},'json')
	}

	//点击修改  打开修改的模态框  同时要把该活动的id传递过去  放在隐藏域中
	//查出数据  放进详情页中
	function openModal() {
		//判断是否是只选中一个框
		var length = $('.son:checked').length;
		if (length == 0){
			layer.alert("请先选择要修改的记录！", {icon: 4});
		} else if(length > 1){
			layer.alert("一次只能修改一条记录！", {icon: 4});
		}else {
			$("#editCustomerModal").modal('show');
			//根据id查询出客户信息   并将其回写进模态框
			$.get("/crm/workbench/customer/queryCustomer",{
				'id':$(".son:checked")[0].value
			},function(data){
				$("#edit-customerOwner").val(data.owner);
				$("#edit-customerName").val(data.name);
				$("#edit-website").val(data.website);
				$("#edit-phone").val(data.phone);
				$("#edit-describe").val(data.description);
				$("#create-contactSummary1").val(data.contactSummary);
				$("#create-nextContactTime2").val(data.nextContactTime);
				$("#create-address").val(data.address);

				//把id设置到隐藏域中
				$("#customerId").val(data.id);
			},'json')
		}
	}

	//导出报表
	function exportExcel() {
		location.href = "/crm/workbench/customer/exportExcel";

	}



</script>
</body>
</html>