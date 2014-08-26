
<%@ page import="kaoqin.ClassHour" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'classHour.label', default: 'ClassHour')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-classHour" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-classHour" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="number" title="${message(code: 'classHour.number.label', default: 'Number')}" />
					
						<g:sortableColumn property="name" title="${message(code: 'classHour.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="timeStart" title="${message(code: 'classHour.timeStart.label', default: 'Time Start')}" />
					
						<g:sortableColumn property="timeEnd" title="${message(code: 'classHour.timeEnd.label', default: 'Time End')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${classHourInstanceList}" status="i" var="classHourInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${classHourInstance.id}">${fieldValue(bean: classHourInstance, field: "number")}</g:link></td>
					
						<td>${fieldValue(bean: classHourInstance, field: "name")}</td>
					
						<td>${fieldValue(bean: classHourInstance, field: "timeStart")}</td>
					
						<td>${fieldValue(bean: classHourInstance, field: "timeEnd")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${classHourInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
