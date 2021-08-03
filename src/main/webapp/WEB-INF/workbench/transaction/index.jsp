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

<link href="/crm/jquery/layer-3.5.1/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>

<link href="/crm/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="/crm/jquery/bs_pagination/en.js" charset="UTF-8"></script>

<script type="text/javascript">

</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
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
							<input class="form-control" id="owner" type="text">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">名称</div>
							<input class="form-control" id="name" type="text">
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
							<div class="input-group-addon">阶段</div>
							<select class="form-control" id="stage">
								<option></option>
								<c:forEach items="${dics['stage']}" var="dicValue">
									<option value="${dicValue.value}">${dicValue.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">类型</div>
							<select class="form-control" id="type">
								<option ></option>
								<c:forEach items="${dics['transactionType']}" var="dicValue">
									<option value="${dicValue.value}">${dicValue.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

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
							<div class="input-group-addon">联系人名称</div>
							<input class="form-control" id="contactsId" type="text">
						</div>
					</div>

					<button type="button" onclick="queryTransaction()" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='save.html';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="father"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
                      <%--  <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div id="transactionPage">



			</div>
			
		</div>
		
	</div>
<script>
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

	//刷新页面的方法
	function refresh(page,pageSize){
		//js函数参数实际上是封装到arguments参数数组中
		/*for(var i = 0; i < arguments.length;i++){
			alert(arguments[i]);
		}*/
		$.get("/crm/workbench/transaction/list",{
			'page':page,
			'pageSize':pageSize,
			'name' : $('#name').val(),
			'customerId' : $('#customerId').val(),
			'stage' : $('#stage').val(),
			'type' : $('#type').val(),
			'owner' : $('#owner').val(),
			'source' : $('#source').val(),
			'customerId' : $('#customerId').val()
		},function(data) {
			$('#transactionBody').html("");
			var transactions = data.list;
			for (var i = 0; i < transactions.length; i++) {
				var transaction = transactions[i];
				$('#transactionBody').append("<tr class=\"active\">\n" +
						"\t\t\t\t\t\t\t<td><input value="+transaction.id+" class='son' type=\"checkbox\" /></td>\n" +
						"\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/transaction/detail?id="+transaction.id+"'\">" + transaction.name + "</a></td>\n" +
						"                            <td>" + transaction.customerId + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + transaction.stage + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + transaction.type + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + transaction.owner + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + transaction.source + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + transaction.customerId + "</td>\n" +
						"\t\t\t\t\t\t</tr>");
			}

			//利用分页插件查询第一页数据
			$("#transactionPage").bs_pagination({
				currentPage: data.pageNum, // 页码
				rowsPerPage: data.pageSize, // 每页显示的记录条数
				maxRowsPerPage: 30, // 每页最多显示的记录条数
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
				}
			});
		},'json');
	}

	//点击查询按钮
	function queryTransaction() {
		refresh(1,5);
	}
</script>
</body>
</html>