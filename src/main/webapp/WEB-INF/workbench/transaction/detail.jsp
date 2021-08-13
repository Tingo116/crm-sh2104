<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link href="/crm/jquery/layer-3.5.1/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/layer-3.5.1/layer/layer.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });
	});
	
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="tranInfo"><small id="tranMoney"></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;" id="stageDiv">
<%--		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-----------
		<span class="closingDate">2010-10-10</span>--%>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="owner"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="money"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="name"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="expectedDate"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="customerId"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="type"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="source"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityName"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="contactsId"></b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">&nbsp;&nbsp;</b><small id="createTime" style="font-size: 10px; color: gray;"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">

				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="contactSummary">
					&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime">&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
	<%--	<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" onclick="saveRemark()" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="historyBody">
					<%--	<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
<script>
	<%--跳转到详情页--%>
	$.post("/crm/workbench/transaction/toDetail",{
		'id':'${id}'
	},function (data) {
		//返回 的是交易对象  里面包含自己的信息   还有两个list
		// 一个交易历史   一个备注
		//拼接显示的大标题
		$("#tranInfo").text(data.customerId+"-"+data.name);
		$("#tranMoney").text(data.money);
		//拼接交易详细信息
		$("#head_name").text(data.name);
		$("#headMoney").text(data.money);
		$("#owner").text(data.owner);
		$("#money").text(data.money);
		$("#name").text(data.name);
		$("#expectedDate").text(data.expectedDate);
		$("#customerId").text(data.customerId);
		$("#stage").text(data.stage);
		$("#possibility").text(data.possibility);
		$("#type").text(data.type);
		$("#source").text(data.source);
		$("#activityName").text(data.activityId);
		$("#contactsId").text(data.contactsId);
		$("#createBy").text(data.createBy);
		$("#createTime").text(data.createTime);
		$("#editBy").text(data.editBy);
		$("#editTime").text(data.editTime);
		$("#description").text(data.description);
		$("#contactSummary").text(data.contactSummary);
		$("#nextContactTime").text(data.nextContactTime);

		//拼接交易备注
		var transactionRemarks = data.transactionRemarks;
		for (var i = 0;i < transactionRemarks.length;i++){
			var transactionRemark = transactionRemarks[i];
			addRemark(transactionRemark);
		}

		//拼接交易历史
		$("#historyBody").html("");
        var transactionHistories = data.transactionHistories;
		for (var i = 0;i<transactionHistories.length;i++){
		    var transactionHistory = transactionHistories[i];
            addHistories(transactionHistory);
        }
		//刷新交易阶段
		refreshStage();

	},'json');

	//交易备注的拼接方法
	function addRemark(transactionRemark) {
		$("#remarkDiv").before("<div class=\"remarkDiv\" style=\"height: 60px;\">\n" +
				"\t\t\t<img title=\"zhangsan\" src='"+transactionRemark.img+"' style=\"width: 30px; height:30px;\">\n" +
				"\t\t\t<div style=\"position: relative; top: -40px; left: 40px;\" >\n" +
				"\t\t\t\t<h5>"+transactionRemark.noteContent+"</h5>\n" +
				"\t\t\t\t<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>"+transactionRemark.tranId+"</b> <small style=\"color: gray;\">"+transactionRemark.createTime+"由"+transactionRemark.createBy+"</small>\n" +
				"\t\t\t\t<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
				"\t\t\t\t\t<a class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
				"\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;\n" +
				"\t\t\t\t\t<a class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
				"\t\t\t\t</div>\n" +
				"\t\t\t</div>\n" +
				"\t\t</div>");

		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});

		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});

		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});

		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
	}
	//拼接交易历史记录
    function addHistories(transactionHistory) {
        $("#historyBody").append("<tr>\n" +
            "\t\t\t\t\t\t\t<td>"+transactionHistory.stage+"</td>\n" +
            "\t\t\t\t\t\t\t<td>"+transactionHistory.money+"</td>\n" +
            "\t\t\t\t\t\t\t<td>"+transactionHistory.possibility+"</td>\n" +
            "\t\t\t\t\t\t\t<td>"+transactionHistory.expectedDate+"</td>\n" +
            "\t\t\t\t\t\t\t<td>"+transactionHistory.createTime+"</td>\n" +
            "\t\t\t\t\t\t\t<td>"+transactionHistory.createBy+"</td>\n" +
            "\t\t\t\t\t\t</tr>");
    }

    //抽取出一个刷新交易状态进度的方法
    function refreshStage(position) {
        $.post("/crm/workbench/transaction/stageList",{
        	'id':'${id}',
			'position':position
		},function (data) {
			//清空一下不然会在后面一直拼
			$("#stageDiv").html("");
			//拼阶段图标的头
			$("#stageDiv").append("阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
        //	data  是resultVo  里面有一个查询出来的 t  表示单个交易阶段
		//	还有显示所有交易阶段的集合
			if (data.t != null){
				//这里说明是进行了修改  该详情页的阶段和可能性
				var history = data.t;
				$("#stage").text(history.stage);
				$("#possibility").text(history.possibility);

				//同时还要添加下面的交易历史记录
				addHistories(history);

			} 
			
			var stages = data.list;
			for (var i = 0;i <stages.length;i ++){
				var stage = stages[i];
				//判断应该显示什么样的图标
				//注意这里要自定义一个属性position  用于显示图标的位置
				if(stage.type == "绿圈"){
					$('#stageDiv').append("<span position="+stage.position +" class=\"glyphicon glyphicon-ok-circle mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content=\""+stage.content+":"+stage.possibility+" \" style=\"color: #90F790;\"></span>");
				}else if(stage.type == "绿勾"){
					$('#stageDiv').append("<span position="+stage.position +" class=\"glyphicon glyphicon-map-marker mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content=\""+stage.content+":"+stage.possibility+"\" style=\"color: #90F790;\"></span>");
				}else if(stage.type == "黑圈"){
					$('#stageDiv').append("<span position="+stage.position +" class=\"glyphicon glyphicon-record mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content=\""+stage.content+":"+stage.possibility+"\"></span>");
				}else if(stage.type == "红叉"){
					$('#stageDiv').append("<span position="+stage.position +" class=\"glyphicon glyphicon-remove mystage\" style='color:red' data-toggle=\"popover\" data-placement=\"bottom\" data-content=\""+stage.content+":"+stage.possibility+"\"></span>");
				}else if(stage.type == "黑叉"){
					$('#stageDiv').append("<span position="+stage.position +" class=\"glyphicon glyphicon-remove mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content=\""+stage.content+":"+stage.possibility+"\"></span>");
				}
				$('#stageDiv').append("-----------");
			}
			$('#stageDiv').append(new Date().toLocaleDateString());
			//鼠标放在阶段  提示信息的功能需要重新弄一下
			$(".mystage").popover({
				trigger:'manual',
				placement : 'bottom',
				html: 'true',
				animation: false
			}).on("mouseenter", function () {
				var _this = this;
				$(this).popover("show");
				$(this).siblings(".popover").on("mouseleave", function () {
					$(_this).popover('hide');
				});
			}).on("mouseleave", function () {
				var _this = this;
				setTimeout(function () {
					if (!$(".popover:hover").length) {
						$(_this).popover("hide")
					}
				}, 100);
			});
        },'json');
    }
    //点击进度条进行修改  用on事件
	$("#stageDiv").on('click','span',function () {
		var position = $(this).attr("position");
		refreshStage(position);
	});

	//显示交易备注信息的添加
	function saveRemark(){
		$.post("/crm/workbench/transaction/saveRemark",{
			'noteContent':$("#remark").val(),
			'tranId':'${id}'
		},function (data) {
			var transactionRemark = data.t;
			if (data.ok){
				layer.alert(data.mess, {icon: 6});
				//    清空文本框
				$("#remark").val("");
				addRemark(transactionRemark);
			}else {
				layer.alert(data.mess, {icon: 4});
			}
		},'json');

	}





</script>
	
</body>
</html>
