
<%@ page import="kaoqin.AbsenceRecord" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'absenceRecord.label', default: 'AbsenceRecord')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="list" action="list" controller="report">考勤单</g:link></li>
			</ul>
		</div>
		<div id="show-absenceRecord" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list absenceRecord">
			
				<g:if test="${absenceRecordInstance?.report}">
				<li class="fieldcontain">
					<span id="report-label" class="property-label"><g:message code="absenceRecord.report.label" default="Report" /></span>
					
						<span class="property-value" aria-labelledby="report-label"><g:link controller="report" action="show" id="${absenceRecordInstance?.report?.id}">${absenceRecordInstance?.report?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.student}">
				<li class="fieldcontain">
					<span id="student-label" class="property-label"><g:message code="absenceRecord.student.label" default="Student" /></span>
					
						<span class="property-value" aria-labelledby="student-label"><g:link controller="student" action="show" id="${absenceRecordInstance?.student?.id}">${absenceRecordInstance?.student?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.status}">
				<li class="fieldcontain">
					<span id="status-label" class="property-label"><g:message code="absenceRecord.status.label" default="Status" /></span>
					
						<span class="property-value" aria-labelledby="status-label"><g:message code="absenceRecord.status.${absenceRecordInstance.status}" default=" ${absenceRecordInstance.status} "/></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.hoursAbsence}">
				<li class="fieldcontain">
					<span id="hoursAbsence-label" class="property-label"><g:message code="absenceRecord.hoursAbsence.label" default="Hours Absence" /></span>
					
						<span class="property-value" aria-labelledby="hoursAbsence-label"><g:fieldValue bean="${absenceRecordInstance}" field="hoursAbsence"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.verifier}">
				<li class="fieldcontain">
					<span id="verifier-label" class="property-label"><g:message code="absenceRecord.verifier.label" default="Verifier" /></span>
					
						<span class="property-value" aria-labelledby="verifier-label"><g:link controller="user" action="show" id="${absenceRecordInstance?.verifier?.id}">${absenceRecordInstance?.verifier?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.finalStatus}">
				<li class="fieldcontain">
					<span id="finalStatus-label" class="property-label"><g:message code="absenceRecord.finalStatus.label" default="Final Status" /></span>
					
						<span class="property-value" aria-labelledby="finalStatus-label"><g:message code="absenceRecord.finalStatus.${absenceRecordInstance.finalStatus}" default=" ${absenceRecordInstance.finalStatus} "/></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.remarks}">
				<li class="fieldcontain">
					<span id="remarks-label" class="property-label"><g:message code="absenceRecord.remarks.label" default="Remarks" /></span>
					
						<span class="property-value" aria-labelledby="remarks-label"><g:fieldValue bean="${absenceRecordInstance}" field="remarks"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="absenceRecord.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${absenceRecordInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${absenceRecordInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="absenceRecord.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${absenceRecordInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${absenceRecordInstance?.id}" />
					<g:link class="edit" action="edit" id="${absenceRecordInstance?.id}">${absenceRecordInstance?.lastUpdated > absenceRecordInstance?.dateCreated ? '修改审核意见' : '审核'}</g:link>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
