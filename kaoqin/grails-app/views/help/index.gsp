<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="layout" content="main"/>
<title>帮助</title>
<style type="text/css">
.body h3, .body div, .body li { padding: 0.5em; }
.body li { padding-left: 1em; }

.mine {background-image: url('${fam.icon(name: 'vcard')}');}
.date {background-image: url('${fam.icon(name: 'date')}');}
.not-confirmed {background-image: url('${fam.icon(name: 'exclamation')}');}
.create {background-image: url(../images/skin/database_add.png);}
.list {background-image: url(../images/skin/database_table.png);}
.accept {background-image: url('${fam.icon(name: 'accept')}');}
.chart {background-image: url('${fam.icon(name: 'chart_bar')}');}
.user_suit { background-image: url('${fam.icon(name: 'user_suit')}'); }
.door_open { background-image: url('${fam.icon(name: 'door_open')}'); }
.group { background-image: url('${fam.icon(name: 'group')}'); }
</style>
<jq:resources/>
<jq:jquery>
$("#div1").hide();
$("#div2").hide();
$("#div3").hide();
<jq:toggle sourceId="help1" targetId="div1"/>
<jq:toggle sourceId="help2" targetId="div2"/>
<jq:toggle sourceId="help3" targetId="div3"/>
</jq:jquery>
</head>
<body>
	<div class="body" style="margin-left: 2em;">
		<h1>基本功能</h1>
		<table style="font-size: 1em;">
		<thead><tr><td>WHEN</td><td>WHO</td><td>DO WHAT</td><td>REMARKS</td></tr></thead>
		<tbody>
			<tr><td>学期开始前</td><td>管理员</td><td><span class="buttons"><g:link class="btn date" controller="semester">新建学期信息</g:link></span></td><td>* 定义学期开始和结束时间</td></tr>
			<tr><td>学期开始</td><td>教师</td><td><span class="buttons"><g:link class="btn date" controller="timetable">录入课程表</g:link></span></td><td>* 系统可自动确定上课时间</td></tr>
			<tr><td>上课前</td><td>系统自动</td><td><span class="buttons"><g:link class="btn create" controller="report" action="create">创建考勤单</g:link></span></td><td>* 如遇调课，可手动创建</td></tr>
			<tr><td>下课后</td><td>教师</td><td><span class="buttons"><g:link class="btn edit" controller="report" action="listMine">填写考勤单</g:link></span> 并 <span class="buttons"><g:link class="btn not-confirmed" controller="report" action="listMine">确认提交</g:link></span></td><td>* 如遇停课，可自行删除</td></tr>
			<tr><td>教师提交后</td><td>辅导员</td><td><span class="buttons"><g:link class="btn accept" controller="absenceRecord" action="index">审核缺勤记录</g:link></span></td><td>* 辅导员审核请假情况</td></tr>
			<tr><td>辅导员审核后</td><td>有关领导</td><td><span class="buttons"><g:link class="btn list" controller="absenceRecord" action="index">查看缺勤情况</g:link></span> <span class="buttons"><g:link class="btn chart" controller="stat">查看数据统计</g:link></span></td><td>* 查看教师考勤、学生缺勤、辅导员审核情况</td></tr>
		</tbody>
		</table>
		<hr/>
		<h1 id="help1">教师考勤 &gt;&gt;&gt;</h1>
		<div id="div1">
		<ul>
			<li>1. <b>维护课程表</b>。学期初录入<span class="buttons"><g:link class="btn date" controller="timetable">课程表</g:link></span>，系统自动根据上课时间建立<span class="buttons"><g:link class="btn not-confirmed" controller="report" action="listNotConfirmed">空白考勤单</g:link></span>，必要时可以修改、甚至删除课程表。</li>
			<li>2. <b>填写考勤单</b>。下课后，教师<span class="buttons"><g:link class="btn edit" controller="report" action="listMine">填写考勤单</g:link></span>，记录考勤情况。</li>
			<li>3. <b>确认考勤单</b>。考勤单填写后，可以临时保存，以备修改。修改无误后，须确认提交考勤结果，完成考勤。确认后不能再修改考勤结果。</li>
			<li>4. <b>调停课考勤</b>。若遇调课，系统不能自动创建考勤单，教师可<span class="buttons"><g:link class="btn create" controller="report" action="create">手动创建考勤单</g:link></span>。若遇停课，可删除自动生成的空白考勤单。</li>
		</ul>
		</div>
		<h1 id="help2">辅导员审核 &gt;&gt;&gt;</h1>
		<div id="div2"><ul>
			<li>1. <b>审核考勤记录</b>。教师提交考勤结果，系统自动创建缺勤记录，须经<span class="buttons"><g:link class="btn accept" controller="absenceRecord">辅导员审核确认</g:link></span>，对考勤结果有误的，进行审核修改。</li>
		</ul></div>
		<h1 id="help3">系统维护 &gt;&gt;&gt;</h1>
		<div id="div3"><ul>
			<li>1. <b>用户管理</b>。为新教师<span class="buttons"><g:link class="btn user_suit" controller="user" action="create">创建用户</g:link></span>，还可以为用户分配权限。不再使用的用户，可以停用。</li>
			<li>2. <b>权限管理</b>。查看系统权限。</li>
			<li>3. <b>班级管理</b>。维护<span class="buttons"><g:link class="btn door_open" controller="classGrade">班级信息</g:link></span>。新入学学生建立班级。建立班级后，可以导入学生。学生毕业后，可以注销该班级的学生。</li>
			<li>4. <b>学生管理</b>。个别学生退学或调整班级时，维护<span class="buttons"><g:link class="btn group" controller="student">学生信息</g:link></span>。</li>
			<li>5. <b>节次时间管理</b>。作息时间修改时，维护<span class="buttons"><g:link class="btn date" controller="classHour">上课时间</g:link></span>。</li>
			<li>6. <b>学期管理</b>。学期初，维护<span class="buttons"><g:link class="btn date" controller="semester">学期信息</g:link></span>。</li>
		</ul></div>
	</div>
</body>
</html>