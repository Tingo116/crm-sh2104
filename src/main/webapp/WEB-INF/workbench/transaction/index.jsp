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
						<input type="hidden" id="tranId">
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
				  <button type="button" class="btn btn-primary" onclick="window.location.href='/crm/toView/workbench/transaction/save';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" onclick="openUpdateModal()" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" onclick="deleteTransaction()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
					<button type="button" onclick="exportExcel()" class="btn btn-success"><span class="glyphicon glyphicon-download-alt"></span> 导出报表</button>
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
			'contactsId' : $('#contactsId').val()
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


	//全选
	$('#father').click(function () {
		$('.son').prop('checked',$(this).prop("checked"));
	});
	//反选功能的实现
	//思路是先获取页面总元素个数 和选中的子元素个数  判断长度是否相等
	$('#transactionBody').on('click','.son',function () {
		var totalLength = $('.son').length;
		var checkedLength = $('.son:checked').length;
		if (totalLength == checkedLength){
			//选中父类元素
			$('#father').prop('checked',true)
		} else {
			$('#father').prop('checked',false)
		}
	});

	//删除功能的实现
	function deleteTransaction() {
		//定义一个数组   存放获取的数据
		var ids = [];
		//遍历数组  将选中的id放入数组中
		$('.son:checked').each(function () {
			ids.push($(this).val());
		});

		layer.confirm('确认删除该条交易记录吗？', {
			btn: ['确定', '取消'] //可以无限个按钮
		}, function(index, layero){
			//按钮【按钮一】的回调
			layer.close(index);
			// alert(ids);
			//发送  利用join()方法进行，号拼接
			$.post("/crm/workbench/transaction/deleteTransaction",{
				'ids':ids.join()
			},function(data){
				if (data.ok){
					layer.alert(data.messa, {icon: 6});
					//手动刷新页面
					refresh(1,5);
				} else {
					layer.alert(data.mess, {icon: 5});
				}
			},'json');
		}, function(index){
		});
	}

	//================添加和修改交易信息===================
	//这里稍微有点不一样这是页面的跳转到编辑页面  这里要做的事情  是判断是否只是选中一个
	//剩下的修改的任务  回编辑页面去修改   这里还要考虑传一个id号过去  怎么传    需要设置一个隐藏域
	function openUpdateModal() {
		//判断是否只选中了一条数据
		var checkedLength = $('.son:checked').length;
		if (checkedLength == 0){
			layer.alert("先选中要修改的记录!", {icon: 5});
		} else if (checkedLength > 1){
			layer.alert("一次只能修改一条记录!", {icon: 5});
		} else {
	/*		//发送请求  根据id  查询交易信息  //不用  直接携带参数
			$.post("/crm/workbench/transaction/queryTransaction",{
				'id':$(".son:checked").val()
			},function (data) {
			},'json');*/
			window.location.href= "/crm/toView/workbench/transaction/edit?id="+$(".son:checked").val();
		}

	}

	//导出报表
	function exportExcel() {
		location.href = "/crm/workbench/transaction/exportExcel";

	}


	//表单提交验证

</script>
</body>
</html>