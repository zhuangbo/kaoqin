
<%@ page import="kaoqin.ClassGrade" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'classGrade.label', default: 'ClassGrade')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-classGrade" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-classGrade" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="name" title="${message(code: 'classGrade.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="specialty" title="${message(code: 'classGrade.specialty.label', default: 'Specialty')}" />
					
						<g:sortableColumn property="grade" title="${message(code: 'classGrade.grade.label', default: 'Grade')}" />
					
						<g:sortableColumn property="classNo" title="${message(code: 'classGrade.classNo.label', default: 'Class No')}" />
					
						<th><g:message code="classGrade.advisor.label" default="Advisor" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${classGradeInstanceList}" status="i" var="classGradeInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${classGradeInstance.id}">${fieldValue(bean: classGradeInstance, field: "name")}</g:link></td>
					
						<td>${fieldValue(bean: classGradeInstance, field: "specialty")}</td>
					
						<td>${fieldValue(bean: classGradeInstance, field: "grade")}</td>
					
						<td>${fieldValue(bean: classGradeInstance, field: "classNo")}</td>
					
						<td>${fieldValue(bean: classGradeInstance, field: "advisor")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${classGradeInstanceTotal}" max="20"/>
			</div>
		</div>
	</body>
</html>
