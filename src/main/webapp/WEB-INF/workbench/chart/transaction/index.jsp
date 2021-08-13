<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>ECharts</title>
    <!-- 引入 echarts.js -->
    <script src="/crm/jquery/ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
</head>
<body>
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="bar" style="width: 800px;height:600px;"></div>
<div id="pie" style="width: 600px;height:400px;"></div>
<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myBar = echarts.init(document.getElementById('bar'));
    //发送请求 返回数据
    $.post("/crm/workbench/chart/tranBarChart",function (data) {
        // 指定图表的配置项和数据
        var option = {
            title: {
                //柱状图名称
                text: '交易统计柱状图'
            },
            tooltip: {},
            legend: {
                //副标题
                data:['交易状态与交易数目']
            },
            xAxis: {
                data: data.titles
            },
            yAxis: {},
            series: [{
                name: '交易',
                type: 'bar',
                data: data.accounts
            }]
        };
        // 使用刚指定的配置项和数据显示图表。
        myBar.setOption(option);
    },'json');


    //饼状图
    var myPie = echarts.init(document.getElementById('pie'));
    //发送请求 返回数据
    $.post("/crm/workbench/chart/tranPieChart",function (data) {
        // 指定图表的配置项和数据
        var option = {
            title: {
                text: '交易状态饼状图',
                subtext: '状态与数目',
                left: 'center'
            },
            tooltip: {
                trigger: 'item'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
            },
            series: [
                {
                    name: '访问来源',
                    type: 'pie',
                    radius: '60%',
                    data:data,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 20,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }
            ]
        };
        // 使用刚指定的配置项和数据显示图表。
        myPie.setOption(option);
    },'json');
</script>
</body>
</html>