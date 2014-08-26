
<%@ page import="kaoqin.Report" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'report.label', default: 'Report')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
<style type="text/css">
.mine {background-image: url('${fam.icon(name: 'vcard')}');}
.today {background-image: url('${fam.icon(name: 'date')}');}
.not-confirmed {background-image: url('${fam.icon(name: 'exclamation')}');}
</style>
	</head>
	<body>
		<a href="#list-report" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="btn mine ${actionName=='listMine'?'btnsel':''}" action="listMine">我的</g:link></li>
				<li><g:link class="btn today ${actionName=='listToday'?'btnsel':''}" action="listToday">今天</g:link></li>
				<li><g:link class="btn not-confirmed ${actionName=='listNotConfirmed'?'btnsel':''}" action="listNotConfirmed">待确认</g:link></li>
				<li><g:link class="list ${actionName=='list'?'btnsel':''}" action="list">全部</g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-report" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table style="font-size: 0.8em">
				<thead>
					<tr>
						<g:sortableColumn property="course" title="课程名称" />
						<g:sortableColumn property="teacher" title="教师" />
						<g:sortableColumn property="classes" title="班级" />
						<g:sortableColumn property="timetable" title="上课周次" />
						<g:sortableColumn property="date" title="上课时间" />
						<g:sortableColumn property="content" title="考勤情况" />
						<g:sortableColumn property="confirmed" title="教师确认" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${reportInstanceList}" status="i" var="reportInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'} ${reportInstance?.confirmed ? '' : 'red'}">
					
						<td><g:link action="show" id="${reportInstance.id}">${fieldValue(bean: reportInstance, field: "course")}</g:link></td>
						<td>${fieldValue(bean: reportInstance, field: "teacher")}</td>
						<td>${fieldValue(bean: reportInstance, field: "classes")}</td>
						<td>${reportInstance?.timetable?.timetable}</td>
						<td><g:formatDate date="${reportInstance.date}" format="yyyy-MM-dd"/></td>
						<g:set var="today" value="${new Date()-1 < reportInstance.date}"></g:set>
						<g:set var="todayConfirmed" value="${new Date()-1 < reportInstance.dateConfirmed}"></g:set>
						<g:if test="${reportInstance?.confirmed}">
						<td>${fieldValue(bean: reportInstance, field: "content")}${! reportInstance?.content ? '全勤' : '' }<g:if test="${today}"><img src='${fam.icon(name: 'new')}'/></g:if></td>
						<td><img src='${fam.icon(name: 'accept')}'/>已确认<g:if test="${todayConfirmed}"><img src='${fam.icon(name: 'new')}'/></g:if></td>
						</g:if>
						<g:else>
						<td>${fieldValue(bean: reportInstance, field: "content")}${! reportInstance?.content ? '全勤' : '' }（待确认）<g:if test="${today}"><img src='${fam.icon(name: 'new')}'/></g:if></td>
						<td nowrap="nowrap"><span class="buttons"><g:link class="btn edit" action="show" id="${reportInstance.id}">确认</g:link></span></td>
						</g:else>
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${reportInstanceTotal}" max="20"/>
			</div>
		</div>
	</body>
</html>
