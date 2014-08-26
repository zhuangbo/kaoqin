
<%@ page import="kaoqin.Report" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'report.label', default: 'Report')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
<style type="text/css">
.icon_accept { background-image: url('${fam.icon(name: 'accept')}'); }
.right {text-align: right;}
.center {text-align: center;}
.bl { color: #008; }
.property-list span {margin: 0.5em 0.2em 0.5em 0.2em;}
.property-label {color: #777;}
.fieldcontain {padding: 0px; margin: 0px;}
</style>
	</head>
	<body>
		<a href="#show-report" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-report" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
			<ol class="property-list report">
			
				<g:if test="${reportInstance?.course}">
				<li class="fieldcontain">
					<span id="course-label" class="property-label"><g:message code="report.course.label" default="Course" /></span>
					
						<span class="property-value" aria-labelledby="course-label"><g:fieldValue bean="${reportInstance}" field="course"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.date}">
				<li class="fieldcontain">
					<span id="date-label" class="property-label"><g:message code="report.date.label" default="Date" /></span>
					
						<span class="property-value" aria-labelledby="date-label"><g:formatDate date="${reportInstance?.date}" format="yyyy-MM-dd"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.time}">
				<li class="fieldcontain">
					<span id="time-label" class="property-label"><g:message code="report.time.label" default="Time" /></span>
					
						<span class="property-value" aria-labelledby="time-label"><g:fieldValue bean="${reportInstance}" field="time"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.hours}">
				<li class="fieldcontain">
					<span id="hours-label" class="property-label"><g:message code="report.hours.label" default="Hours" /></span>
					
						<span class="property-value" aria-labelledby="hours-label"><g:fieldValue bean="${reportInstance}" field="hours"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.classes}">
				<li class="fieldcontain">
					<span id="classes-label" class="property-label"><g:message code="report.classes.label" default="Classes" /></span>
					
						<span class="property-value" aria-labelledby="classes-label"><g:fieldValue bean="${reportInstance}" field="classes"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.classroom}">
				<li class="fieldcontain">
					<span id="classroom-label" class="property-label"><g:message code="report.classroom.label" default="Classroom" /></span>
					
						<span class="property-value" aria-labelledby="classroom-label"><g:fieldValue bean="${reportInstance}" field="classroom"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.absence}">
				<li class="fieldcontain">
					<span id="absence-label" class="property-label"><g:message code="report.absence.label" default="Absence" /></span>
					
						<span class="property-value" aria-labelledby="absence-label"><g:fieldValue bean="${reportInstance}" field="absence"/></span>
					
				</li>
				</g:if>
			
				<li class="fieldcontain">
					<span id="content-label" class="property-label"><g:message code="report.content.label" default="Content" /></span>
					
						<span class="property-value" aria-labelledby="content-label">
				<g:if test="${reportInstance?.content}">
						<g:fieldValue bean="${reportInstance}" field="content"/>
				</g:if>
				<g:else>全勤</g:else>
						</span>
					
				</li>
			
				<g:if test="${reportInstance?.teacher}">
				<li class="fieldcontain">
					<span id="teacher-label" class="property-label"><g:message code="report.teacher.label" default="Teacher" /></span>
					
						<span class="property-value" aria-labelledby="teacher-label"><g:link controller="user" action="show" id="${reportInstance?.teacher?.id}">${reportInstance?.teacher?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.timetable}">
				<li class="fieldcontain">
					<span id="timetable-label" class="property-label"><g:message code="report.timetable.label" default="Timetable" /></span>
					
						<span class="property-value" aria-labelledby="timetable-label"><g:link controller="timetable" action="show" id="${reportInstance?.timetable?.id}">${reportInstance?.timetable?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.confirmed}">
				<li class="fieldcontain">
					<span id="confirmed-label" class="property-label"><g:message code="report.confirmed.label" default="Confirmed" /></span>
					
						<span class="property-value" aria-labelledby="confirmed-label"><g:formatBoolean boolean="${reportInstance?.confirmed}" /></span>
					
				</li>
				</g:if>
				<g:else>
				<li class="fieldcontain">
					<span id="confirmed-label" class="property-label"><g:message code="report.confirmed.label" default="Confirmed" /></span>
						<span class="property-value red" aria-labelledby="confirmed-label">尚未提交</span>
				</li>
				</g:else>
			
				<g:if test="${reportInstance?.dateConfirmed}">
				<li class="fieldcontain">
					<span id="dateConfirmed-label" class="property-label"><g:message code="report.dateConfirmed.label" default="Date Confirmed" /></span>
						<span class="property-value" aria-labelledby="dateConfirmed-label"><g:formatDate date="${reportInstance?.dateConfirmed}" /></span>
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="report.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${reportInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${reportInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="report.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${reportInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
			</ol>

			<mysec:ifOwner report="${reportInstance}">
			<g:if test="${! reportInstance?.confirmed}">
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${reportInstance?.id}" />
					<g:link class="edit" action="edit" id="${reportInstance?.id}">检查修改</g:link>
					<g:link class="btn icon_accept" action="confirm" id="${reportInstance?.id}" onclick="return confirm('提交之后不能再修改，你确定要提交本次考勤结果么？');">确认提交</g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
			</g:if>
			</mysec:ifOwner>
			<mysec:ifNotOwner report="${reportInstance}">
			<sec:ifAnyGranted roles="ROLE_LEADER">
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${reportInstance?.id}" />
					<g:link class="edit" action="edit" id="${reportInstance?.id}">检查修改</g:link>
					<g:link class="btn icon_accept" action="confirm" id="${reportInstance?.id}" onclick="return confirm('提交之后不能再修改，你确定要提交本次考勤结果么？');">确认提交</g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
			</sec:ifAnyGranted>
			</mysec:ifNotOwner>
		</div>
	</body>
</html>
