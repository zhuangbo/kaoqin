<%@ page contentType="text/html;charset=UTF-8" %>
<ul id="coolMenu">
<sec:ifLoggedIn>
    <li><g:link controller="timetable"><img src="${fam.icon(name: 'calendar')}" /> 课表</g:link>
        <ul>
		    <li><g:link controller="timetable" action="listMine"><img src="${fam.icon(name: 'vcard')}" /> 我的课表</g:link></li>
		    <li><g:link controller="timetable" action="listMyToday"><img src="${fam.icon(name: 'date')}" /> 今日课表</g:link></li>
		    <li><g:link controller="timetable" action="list"><img src="${fam.icon(name: 'calendar')}" /> 全部课表</g:link></li>
		    <li><g:link controller="timetable" action="create"><img src="${fam.icon(name: 'calendar_add')}" /> 新建课表</g:link></li>
        </ul>
    </li>
    <li><g:link controller="report"><img src="${fam.icon(name: 'application_edit')}" /> 考勤</g:link>
        <ul>
		    <li><g:link controller="report" action="listMine"><img src="${fam.icon(name: 'vcard')}" /> 我的考勤单</g:link></li>
		    <li><g:link controller="report" action="listToday"><img src="${fam.icon(name: 'date')}" /> 今日考勤单</g:link></li>
		    <li><g:link controller="report" action="listNotConfirmed"><img src="${fam.icon(name: 'application_delete')}" /> 待确认的</g:link></li>
		    <li><g:link controller="report" action="list"><img src="${fam.icon(name: 'application_cascade')}" /> 全部考勤单</g:link></li>
		    <li><g:link controller="report" action="create"><img src="${fam.icon(name: 'application_add')}" /> 新建考勤单</g:link></li>
        </ul>
    </li>
    <li><g:link controller="absenceRecord"><img src="${fam.icon(name: 'bell')}" /> 缺勤</g:link>
        <ul>
		    <li><g:link controller="absenceRecord" action="list"><img src="${fam.icon(name: 'group_delete')}" /> 所有缺勤</g:link></li>
		    <li><g:link controller="absenceRecord" action="listNotVerified"><img src="${fam.icon(name: 'exclamation')}" /> 未审核的</g:link></li>
		</ul>
    </li>
    <li><g:link controller="stat"><img src="${fam.icon(name: 'chart_bar')}" /> 统计</g:link>
        <ul>
			<li><g:link controller="stat" action="index"><img src="${fam.icon(name: 'chart_pie')}" /> 整体统计</g:link></li>
			<li><g:link controller="stat" action="classes"><img src="${fam.icon(name: 'door_open')}" /> 班级统计</g:link></li>
			<li><g:link controller="stat" action="students"><img src="${fam.icon(name: 'group')}" /> 学生统计</g:link></li>
			<li><g:link controller="stat" action="courses"><img src="${fam.icon(name: 'book')}" /> 课程统计</g:link></li>
			<sec:ifAllGranted roles="ROLE_LEADER">
			<li><g:link controller="stat" action="teachers"><img src="${fam.icon(name: 'user_suit')}" /> 教师考勤统计</g:link></li>
			<li><g:link controller="stat" action="counsellors"><img src="${fam.icon(name: 'accept')}" /> 审核情况统计</g:link></li>
			</sec:ifAllGranted>
		</ul>
    </li>
    <li>
    	<g:link controller="timetable"><img src="${fam.icon(name: 'cog')}" /> 管理</g:link>
        <ul>
		    <li><g:link controller="timetable"><img src="${fam.icon(name: 'calendar')}" /> 课表管理</g:link></li>
            <li><g:link controller="user"><img src="${fam.icon(name: 'user_suit')}" /> 用户管理</g:link></li>
            <li><g:link controller="role"><img src="${fam.icon(name: 'lock')}" /> 权限管理</g:link></li>
            <li><g:link controller="semester"><img src="${fam.icon(name: 'date')}" /> 学期管理</g:link></li>
            <li><g:link controller="classHour"><img src="${fam.icon(name: 'clock')}" /> 节次管理</g:link></li>
            <li><g:link controller="classGrade"><img src="${fam.icon(name: 'door_open')}" /> 班级管理</g:link></li>
            <li><g:link controller="student"><img src="${fam.icon(name: 'group')}" /> 学生管理</g:link></li>
        </ul>
    </li>
    <li><g:link controller="help"><img src="${fam.icon(name: 'help')}" /> 帮助</g:link></li>
</sec:ifLoggedIn>
</ul>
