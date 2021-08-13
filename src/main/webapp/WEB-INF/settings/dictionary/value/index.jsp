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

	<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/layer.js"></script>
	<script type="text/javascript"></script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='save.html'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html'"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" onclick="deleteValueByIds()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="father" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="valueBody">
			<%--	<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>m</td>
					<td>男</td>
					<td>1</td>
					<td>sex</td>
				</tr>--%>

			</tbody>
		</table>
	</div>
	<div id="valuesPage">
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
	refresh(1,3);
	//定义一个刷新页面的方法
	function refresh(page,pageSize){
		$.get("/crm/settings/dicValue/list",{
			'page':page,
			'pageSize':pageSize
		},function(data){
			//清空一下
			$('#valueBody').html("");
			var values = data.list;
			console.log(values);

			for (var i = 0;i<values.length;i++){
				var value = values[i];
				$('#valueBody').append("<tr class=\"active\">\n" +
						"\t\t\t\t\t<td><input id="+value.id+" type=\"checkbox\" class='son' /></td>\n" +
						"\t\t\t\t\t<td>"+value.num+"</td>\n" +
						"\t\t\t\t\t<td>"+value.typeCode+"</td>\n" +
						"\t\t\t\t\t<td>"+value.text+"</td>\n" +
						"\t\t\t\t\t<td>"+value.orderNo+"</td>\n" +
						"\t\t\t\t\t<td>"+value.value+"</td>\n" +
						"\t\t\t\t</tr>");
			}
			//利用分页插件查询第一页数据
			$("#valuesPage").bs_pagination({
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
	//字典表值的删除
	//============全选  反选========================
	$("#father").click(function () {
		//判断是否被选中
		$(".son").prop('checked',$(this).prop('checked'));
	});
	//	======反选的实现================
	//3个参数   1：事件名称 2：绑定的元素 3：触发的函数
	$("#valueBody").on('click','.son',function () {
		//先获取选中的元素个数
		var length = $('.son:checked').length;
		//再获取所有的子元素个数
		var length1 = $('.son').length;
		//判断是否相等  相等就选中
		if (length == length1){
			//反选
			$("#father").prop("checked",true);
		} else {
			$("#father").prop("checked",false);
		}
	});

	//====================================批量删除功能的实现===============================
	function deleteValueByIds() {
		//定义一个数组  接收选取的ids
		var ids = [];
		//获取选中数据的id号
		$('.son:checked').each(function () {
			// alert($(this).val())//弹一下   看是否获取到了id
			//将获取到的id存放到数组中
			//push方法
			ids.push($(this).val());
		});
		//这里还需要判断一下是否至少选中一条记录   否则还是会弹窗
		// alert(ids);
		layer.confirm('确认删除选中的字典表值吗？', {
			btn: ['确定', '取消'] //可以无限个按钮
		}, function(index, layero){
			//按钮【按钮一】的回调
			layer.close(index);
			//发送请求
			$.post("/crm/settings/dicValue/delete",{
				//这里存放获取到的ids  注意取法
				//join():默认会把数组中的内容默认以，号的形式拼接成字符串，也可以指定分割符
				'ids':ids.join()
			},function (data) {
				if(data.ok){
					layer.alert(data.mess,{icon:6});
					//添加成功，手动刷新页面
					refresh(1,3);
				}
			},'json');
		}, function(index){
		});
	}
</script>
	
</body>
</html>