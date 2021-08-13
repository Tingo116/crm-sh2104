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
<script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--自动补全功能--%>
<script type="text/javascript" src="/crm/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>


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

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="addForm">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="create-contactsOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="source" id="create-clueSource">
								  <option></option>
									<c:forEach items="${dics['source']}" var="divValue">
										<option value="${divValue.value}">${divValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="fullname" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="appellation" id="create-call">
								  <option></option>
									<c:forEach items="${dics['appellation']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="job" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="mphone" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="email" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="birth" class="form-control" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="customerId"  class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" name="description" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" name="contactSummary" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" name="nextContactTime" class="form-control" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" name="address" rows="1" id="edit-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="saveOrUpdateContact($('#addForm'))" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="updateForm">
						<%--放一个隐藏域 存放获取的联系人id--%>
						<input type="hidden" name="id" id="id">
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="edit-contactsOwner">
								  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="source" id="edit-clueSource1">
								  <option></option>
									<c:forEach items="${dics['source']}" var="divValue">
										<option value="${divValue.value}">${divValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" name="fullname">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="appellation" id="edit-call">
								  <option></option>
									<c:forEach items="${dics['appellation']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" name="job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" name="mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" name="email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="birth" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="customerId" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" name="description" id="edit-describe">
								</textarea>
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
									<input type="text" class="form-control" name="nextContactTime" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" name="address" rows="1" id="edit-address2">
										</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" onclick="saveOrUpdateContact($('#updateForm'))" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="owner" name="owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" id="fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" id="customerId" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="source">
						  <option></option>
						  <c:forEach items="${dics['source']}" var="dicValue">
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control" name="birth" id="birth" type="text">
				    </div>
				  </div>
				  
				  <button type="button" onclick="refresh(1,5)" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createContactsModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" onclick="openUpdateModal()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" onclick="deleteContacts()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
					<button type="button" onclick="exportExcel()" class="btn btn-success"><span class="glyphicon glyphicon-download-alt"></span> 导出报表</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="father" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>--%>
                   
					</tbody>
				</table>
			</div>
			
			<div id="contactPage">
			
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

	//写一个刷新页面的方法
	function refresh(page,pageSize) {
		$.get("/crm/workbench/contacts/list", {
					'page': page,
					'pageSize': pageSize,
					'fullname': $('#fullname').val(),
					'customerId': $('#customerId').val(),
					'owner': $('#owner').val(),
					'source': $('#source').val(),
					'birth': $('#birth').val(),
				}, function (data) {
			$("#contactBody").html("");
			var contacts = data.list;
			for (var i =0;i<contacts.length;i++) {
				//清空一下表单

				var contact = contacts[i];
				//拼页面
				$("#contactBody").append("<tr>\n" +
						"\t\t\t\t\t\t\t<td><input type=\"checkbox\" value="+contact.id+" class='son' /></td>\n" +
						"\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/contacts/detail?id="+contact.id+"';\">"+contact.fullname+"</a></td>\n" +
						"\t\t\t\t\t\t\t<td>"+contact.customerId+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+contact.owner+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+contact.source+"</td>\n" +
						"\t\t\t\t\t\t\t<td>"+contact.birth+"</td>\n" +
						"\t\t\t\t\t\t</tr>");
				//动态拼成分页
				//利用分页插件查询第一页数据
				$("#contactPage").bs_pagination({
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
		}, 'json');
	}

//全选跟反选
//	全选功能的实现
	$("#father").click(function () {
		$(".son").prop("checked",$("#father").prop("checked"));
	});
	//反选
	$("#contactBody").on('click','.son',function () {
		var checkedLength = $(".son:checked").length;
		var length = $(".son").length;
		if (checkedLength == length){
			$("#father").prop("checked",true);
		} else {
			$("#father").prop("checked",false);
		}
	});


	//联系人的创建  模态框里面有一个支持联系人查询的
	// 当没有客户时   创建客户（这个放在提交表单的时候更好一点吧？？？先放这里试试）
	//自动补全
	$("#create-customerName").typeahead({
		source: function (customerName, process) {
			$.post(
					"/crm/workbench/contact/queryCustomerNames",
					{ "customerName" : customerName },
					function (data) {
						//返回List<String>
						process(data);
					},
					"json");
		},
		//输入内容后延迟多长时间弹出提示内容 单位:毫秒
		delay: 500
	});

	//自动补全
	$("#edit-customerName").typeahead({
		source: function (customerName, process) {
			$.post(
					"/crm/workbench/contact/queryCustomerNames",
					{ "customerName" : customerName },
					function (data) {
						//返回List<String>
						process(data);
					},
					"json");
		},
		//输入内容后延迟多长时间弹出提示内容 单位:毫秒
		delay: 500
	});

	//点击添加或者更新按钮时  保存信息
	function saveOrUpdateContact(form) {
		var form = form.serialize();
		//验证是否为空
		$.get("/crm/workbench/contact/saveOrUpdateContact",form,function(data){
			if (data.ok){
				layer.alert(data.mess, {icon: 6});
				//刷新页面
				refresh(1,5);
			}else {
				layer.alert(data.mess, {icon: 5});
			}
		},'json')

	}


	//联系人的修改
	//打开模态框
	function openUpdateModal() {
		//判断长度
		var length = $(".son:checked").length;
		if (length == 0){
			layer.alert("请先选中要修改的记录", {icon: 4});
		} else if (length > 1){
			layer.alert("一次只能修改一条记录", {icon: 4});
		}else {
			$("#editContactsModal").modal('show');
			var id = $('.son:checked')[0].value;

			//发送请求  查参数
			$.get("/crm/workbench/contact/queryContact",{
				'id':id
			},function(data){
				//拼页面
				var contact = data;
				//动态写入模态框
				$("#edit-contactsOwner").val(contact.owner);
				$("#edit-clueSource1").val(contact.source);
				$("#edit-surname").val(contact.fullname);
				$("#edit-call").val(contact.appellation);
				$("#edit-job").val(contact.job);
				$("#edit-mphone").val(contact.mphone);
				$("#edit-email").val(contact.email);
				$("#edit-birth").val(contact.birth);
				$("#edit-customerName").val(contact.customerId);
				$("#edit-describe").val(contact.description);
				$("#create-contactSummary").val(contact.contactSummary);
				$("#create-nextContactTime").val(contact.nextContactTime);
				$("#edit-address2").val(contact.address);

				//把联系人id放进隐藏域  后面修改时要用到  根据主键修改信息
				$("#id").val(contact.id);

			},'json')
		}
	}

	//删除联系人
	function deleteContacts() {
		var length = $('.son:checked').length;
		var ids = [];
		$(".son:checked").each(function () {
			ids.push($(this).val());
		});
		if (length > 0){

			//确定删除吗
			layer.msg('确定删除吗', {
				time: 0 //不自动关闭
				,btn: ['确定', '取消']
				,yes: function(index){
					layer.close(index);

					$.post("/crm/workbench/contact/deleteContacts",{
						'ids':ids.join()
					},function(data){
						if(data.ok){
							layer.alert(data.mess, {icon: 6});
							//删除成功，手动刷新页面
							refresh(1,5);
						}else {
							layer.alert(data.mess, {icon: 5});
						}
					},'json');
				}
			});
		}
	}


	//导出报表
	function exportExcel() {
		location.href = "/crm/workbench/contacts/exportExcel";

	}


</script>
</body>
</html>