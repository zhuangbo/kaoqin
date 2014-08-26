
<%@ page import="kaoqin.Semester" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'semester.label', default: 'Semester')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-semester" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-semester" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list semester">
			
				<g:if test="${semesterInstance?.shortName}">
				<li class="fieldcontain">
					<span id="shortName-label" class="property-label"><g:message code="semester.shortName.label" default="Short Name" /></span>
					
						<span class="property-value" aria-labelledby="shortName-label"><g:fieldValue bean="${semesterInstance}" field="shortName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${semesterInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="semester.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${semesterInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${semesterInstance?.dateStart}">
				<li class="fieldcontain">
					<span id="dateStart-label" class="property-label"><g:message code="semester.dateStart.label" default="Date Start" /></span>
					
						<span class="property-value" aria-labelledby="dateStart-label"><g:formatDate date="${semesterInstance?.dateStart}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${semesterInstance?.dateEnd}">
				<li class="fieldcontain">
					<span id="dateEnd-label" class="property-label"><g:message code="semester.dateEnd.label" default="Date End" /></span>
					
						<span class="property-value" aria-labelledby="dateEnd-label"><g:formatDate date="${semesterInstance?.dateEnd}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${semesterInstance?.timetables}">
				<li class="fieldcontain">
					<span id="timetables-label" class="property-label"><g:message code="semester.timetables.label" default="Timetables" /></span>
					
						<g:each in="${semesterInstance.timetables}" var="t">
						<span class="property-value" aria-labelledby="timetables-label"><g:link controller="timetable" action="show" id="${t.id}">${t?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${semesterInstance?.id}" />
					<g:link class="edit" action="edit" id="${semesterInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
