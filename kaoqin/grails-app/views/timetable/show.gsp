
<%@page import="kaoqin.ClassHour"%>
<%@ page import="kaoqin.Timetable" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'timetable.label', default: 'Timetable')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-timetable" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-timetable" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list timetable">
			
				<g:if test="${timetableInstance?.course}">
				<li class="fieldcontain">
					<span id="course-label" class="property-label"><g:message code="timetable.course.label" default="Course" /></span>
						<span class="property-value" aria-labelledby="course-label"><g:fieldValue bean="${timetableInstance}" field="course"/></span>
				</li>
				</g:if>
			
				<g:if test="${timetableInstance?.timetable}">
				<li class="fieldcontain">
					<span id="timetable-label" class="property-label"><g:message code="timetable.timetable.label" default="Timetable" /></span>
						<span class="property-value" aria-labelledby="timetable-label"><g:fieldValue bean="${timetableInstance}" field="timetable"/></span>
				</li>
				</g:if>
			
				<g:if test="${timetableInstance?.classroom}">
				<li class="fieldcontain">
					<span id="classroom-label" class="property-label"><g:message code="timetable.classroom.label" default="Classroom" /></span>
						<span class="property-value" aria-labelledby="classroom-label"><g:fieldValue bean="${timetableInstance}" field="classroom"/></span>
				</li>
				</g:if>
			
				<g:if test="${timetableInstance?.classes}">
				<li class="fieldcontain">
					<span id="classes-label" class="property-label"><g:message code="timetable.classes.label" default="Classes" /></span>
						<span class="property-value" aria-labelledby="classes-label"><g:fieldValue bean="${timetableInstance}" field="classes"/></span>
				</li>
				</g:if>
			
				<g:if test="${timetableInstance?.teacher}">
				<li class="fieldcontain">
					<span id="teacher-label" class="property-label"><g:message code="timetable.teacher.label" default="Teacher" /></span>
						<span class="property-value" aria-labelledby="teacher-label"><g:link controller="user" action="show" id="${timetableInstance?.teacher?.id}">${timetableInstance?.teacher?.encodeAsHTML()}</g:link></span>
				</li>
				</g:if>
			
				<g:if test="${timetableInstance?.semester}">
				<li class="fieldcontain">
					<span id="semester-label" class="property-label"><g:message code="timetable.semester.label" default="Semester" /></span>
						<span class="property-value" aria-labelledby="semester-label"><g:link controller="semester" action="show" id="${timetableInstance?.semester?.id}">${timetableInstance?.semester?.encodeAsHTML()}</g:link></span>
				</li>
				</g:if>
			
				<g:if test="${timetableInstance?.closed}">
				<li class="fieldcontain">
					<span id="closed-label" class="property-label"><g:message code="timetable.closed.label" default="Closed" /></span>
					<span class="property-value" aria-labelledby="closed-label"><g:formatBoolean boolean="${timetableInstance?.closed}" /></span>
				</li>
				</g:if>
				
				<g:set var="timeOfLesson" value="${timetableInstance.timeOfLesson()}"></g:set>
				<li class="fieldcontain">
					<span id="lastLesson-label" class="property-label">上一次课</span>
						<span class="property-value" aria-labelledby="lastLesson-label"><g:formatDate date="${timetableInstance.dateOfLastLesson()}" format="yyyy-MM-dd"/> ${timeOfLesson}</span>
				</li>
				<g:if test="${!(timetableInstance?.closed)}">
				<li class="fieldcontain">
					<span id="lastLesson-label" class="property-label">下一次课</span>
						<span class="property-value" aria-labelledby="lastLesson-label"><g:formatDate date="${timetableInstance.dateOfNextLesson()}" format="yyyy-MM-dd"/> ${timeOfLesson}</span>
				</li>
				</g:if>
				
			
			</ol>
			<g:set var="operations" value="false"/>
			<mysec:ifOwner timetable="${timetableInstance}">
				<g:set var="operations" value="true"/>
			</mysec:ifOwner>
			<sec:ifAnyGranted roles="ROLE_LEADER">
				<g:set var="operations" value="true"/>
			</sec:ifAnyGranted>
			<g:if test="${operations}">
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${timetableInstance?.id}" />
					<g:if test="${timetableInstance?.closed}">
						<g:link class="save" action="openIt" id="${timetableInstance?.id}">重新开课</g:link>
					</g:if>
					<g:else>
						<g:link class="edit" action="create" controller="report" id="${timetableInstance?.id}">课堂考勤</g:link>
						<g:link class="save" action="closeIt" id="${timetableInstance?.id}">结束开课</g:link>
						<g:link class="edit" action="edit" id="${timetableInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</g:else>
				</fieldset>
			</g:form>
			</g:if>
		</div>
	</body>
</html>
