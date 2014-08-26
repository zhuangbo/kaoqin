
<%@ page import="kaoqin.Semester" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'semester.label', default: 'Semester')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-semester" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-semester" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="shortName" title="${message(code: 'semester.shortName.label', default: 'Short Name')}" />
					
						<g:sortableColumn property="name" title="${message(code: 'semester.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="dateStart" title="${message(code: 'semester.dateStart.label', default: 'Date Start')}" />
					
						<g:sortableColumn property="dateEnd" title="${message(code: 'semester.dateEnd.label', default: 'Date End')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${semesterInstanceList}" status="i" var="semesterInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${semesterInstance.id}">${fieldValue(bean: semesterInstance, field: "shortName")}</g:link></td>
					
						<td>${fieldValue(bean: semesterInstance, field: "name")}</td>
					
						<td><g:formatDate date="${semesterInstance.dateStart}" /></td>
					
						<td><g:formatDate date="${semesterInstance.dateEnd}" /></td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${semesterInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
