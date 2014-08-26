
<%@ page import="kaoqin.ClassGrade" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'classGrade.label', default: 'ClassGrade')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-classGrade" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
				<li><g:link class="list" action="imports" id="${params.id}">导入学生</g:link></li>
			</ul>
		</div>
		<div id="show-classGrade" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list classGrade">
			
				<g:if test="${classGradeInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="classGrade.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${classGradeInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classGradeInstance?.specialty}">
				<li class="fieldcontain">
					<span id="specialty-label" class="property-label"><g:message code="classGrade.specialty.label" default="Specialty" /></span>
					
						<span class="property-value" aria-labelledby="specialty-label"><g:fieldValue bean="${classGradeInstance}" field="specialty"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classGradeInstance?.grade}">
				<li class="fieldcontain">
					<span id="grade-label" class="property-label"><g:message code="classGrade.grade.label" default="Grade" /></span>
					
						<span class="property-value" aria-labelledby="grade-label"><g:fieldValue bean="${classGradeInstance}" field="grade"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classGradeInstance?.classNo}">
				<li class="fieldcontain">
					<span id="classNo-label" class="property-label"><g:message code="classGrade.classNo.label" default="Class No" /></span>
					
						<span class="property-value" aria-labelledby="classNo-label"><g:fieldValue bean="${classGradeInstance}" field="classNo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${classGradeInstance?.advisor}">
				<li class="fieldcontain">
					<span id="advisor-label" class="property-label"><g:message code="classGrade.advisor.label" default="Advisor" /></span>
					
						<span class="property-value" aria-labelledby="advisor-label"><g:link controller="user" action="show" id="${classGradeInstance?.advisor?.id}">${classGradeInstance?.advisor?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${classGradeInstance?.students}">
				<li class="fieldcontain">
					<span id="students-label" class="property-label"><g:message code="classGrade.students.label" default="Students" /></span>
					
						<g:each in="${classGradeInstance.students}" var="s">
						<span class="property-value" aria-labelledby="students-label"><g:link controller="student" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${classGradeInstance?.id}" />
					<g:link class="edit" action="edit" id="${classGradeInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:link class="edit" action="disableStudents" id="${classGradeInstance?.id}">注销学生</g:link>
					<g:link class="edit" action="enableStudents" id="${classGradeInstance?.id}">撤销注销</g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
