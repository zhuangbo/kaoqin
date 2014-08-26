
<%@ page import="kaoqin.ClassHour" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'classHour.label', default: 'ClassHour')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-classHour" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-classHour" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list classHour">
			
				<g:if test="${classHourInstance?.number}">
				<li class="fieldcontain">
					<span id="number-label" class="property-label"><g:message code="classHour.number.label" default="Number" /></span>
					
						<span class="property-value" aria-labelledby="number-label"><g:fieldValue bean="${classHourInstance}" field="number"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classHourInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="classHour.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${classHourInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classHourInstance?.timeStart}">
				<li class="fieldcontain">
					<span id="timeStart-label" class="property-label"><g:message code="classHour.timeStart.label" default="Time Start" /></span>
					
						<span class="property-value" aria-labelledby="timeStart-label"><g:fieldValue bean="${classHourInstance}" field="timeStart"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classHourInstance?.timeEnd}">
				<li class="fieldcontain">
					<span id="timeEnd-label" class="property-label"><g:message code="classHour.timeEnd.label" default="Time End" /></span>
					
						<span class="property-value" aria-labelledby="timeEnd-label"><g:fieldValue bean="${classHourInstance}" field="timeEnd"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${classHourInstance?.id}" />
					<g:link class="edit" action="edit" id="${classHourInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
