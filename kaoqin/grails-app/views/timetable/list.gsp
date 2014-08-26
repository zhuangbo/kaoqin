
<%@page import="kaoqin.ClassHour"%>
<%@page import="kaoqin.Semester"%>
<%@ page import="kaoqin.Timetable" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'timetable.label', default: 'Timetable')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
<style type="text/css">
.mine {background-image: url('${fam.icon(name: 'vcard')}');}
.today {background-image: url('${fam.icon(name: 'date')}');}
.closed {background-image: url('${fam.icon(name: 'calendar')}');}
</style>
	</head>
	<body>
		<a href="#list-timetable" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="btn mine ${actionName=='listMine'?'btnsel':''}" action="listMine">我的</g:link></li>
				<li><g:link class="btn today ${actionName=='listMyToday'?'btnsel':''}" action="listMyToday">今天</g:link></li>
				<li><g:link class="btn closed ${actionName=='listMyClosed'?'btnsel':''}" action="listMyClosed">过去</g:link></li>
				<li><g:link class="list ${actionName=='list'?'btnsel':''}" action="list">全部</g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-timetable" class="content scaffold-list" role="main">
			<g:if test="${actionName=='list'}">
			<div style="float: right; display: inline;">
				<g:form action="list" method="get">
				<g:set var="userid"><mysec:userid/></g:set>
				<g:select id="teacher" name="teacher" noSelection="${['0':'-教师-']}" from="${kaoqin.User.list()}" optionKey="id" value="${teacher ?: 0}"/>
				<g:select id="semester" name="semester" noSelection="${['0':'-学期-']}" from="${kaoqin.Semester.list()}" optionKey="id" value="${semester ?: 0}"/>
				<g:checkBox name="closed" value="${closed}"/><label for="closed">结束的</label>
				<span class="buttons"><g:submitButton name="筛选"/></span>
				</g:form>
			</div>
			</g:if>
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="course" title="${message(code: 'timetable.course.label', default: 'Course')}" />
					
						<g:sortableColumn property="timetable" title="${message(code: 'timetable.timetable.label', default: 'Timetable')}" />
					
						<g:sortableColumn property="classroom" title="${message(code: 'timetable.classroom.label', default: 'Classroom')}" />
					
						<g:sortableColumn property="classes" title="${message(code: 'timetable.classes.label', default: 'Classes')}" />
					
						<th><g:message code="timetable.teacher.label" default="Teacher" /></th>
					
						<th><g:message code="timetable.semester.label" default="Semester" /></th>
						
					</tr>
				</thead>
				<tbody>
				<g:each in="${timetableInstanceList}" status="i" var="timetableInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${timetableInstance.id}">${fieldValue(bean: timetableInstance, field: "course")}</g:link></td>
					
						<td>${fieldValue(bean: timetableInstance, field: "timetable")}</td>
					
						<td>${fieldValue(bean: timetableInstance, field: "classroom")}</td>
					
						<td>${fieldValue(bean: timetableInstance, field: "classes")}</td>
					
						<td>${fieldValue(bean: timetableInstance, field: "teacher")}</td>
					
						<td>${fieldValue(bean: timetableInstance, field: "semester")}</td>

					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${timetableInstanceTotal}" max="20"/>
			</div>
		</div>
	</body>
</html>
