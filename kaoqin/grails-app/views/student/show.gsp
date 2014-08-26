
<%@ page import="kaoqin.Student" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'student.label', default: 'Student')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
<style type="text/css">
.exclamation {
    background-image: url('${fam.icon(name: 'exclamation')}');
}
</style>
	</head>
	<body>
		<a href="#show-student" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-student" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list student">
			
				<g:if test="${studentInstance?.no}">
				<li class="fieldcontain">
					<span id="no-label" class="property-label"><g:message code="student.no.label" default="No" /></span>
					
						<span class="property-value" aria-labelledby="no-label"><g:fieldValue bean="${studentInstance}" field="no"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="student.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${studentInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.classGrade}">
				<li class="fieldcontain">
					<span id="classGrade-label" class="property-label"><g:message code="student.classGrade.label" default="Class Grade" /></span>
					
						<span class="property-value" aria-labelledby="classGrade-label"><g:link controller="classGrade" action="show" id="${studentInstance?.classGrade?.id}">${studentInstance?.classGrade?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<li class="fieldcontain">
					<span id="enabled-label" class="property-label"><g:message code="student.enabled.label" default="Enabled" /></span>
					
						<span class="property-value" aria-labelledby="enabled-label"><g:formatBoolean boolean="${studentInstance?.enabled}" /></span>
					
				</li>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${studentInstance?.id}" />
					<g:link class="btn exclamation" action="absenceRecords" id="${studentInstance?.id}">缺勤记录</g:link>
					<g:link class="edit" action="edit" id="${studentInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
