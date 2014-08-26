<%@ page import="kaoqin.AbsenceRecord" %>

<div class="fieldcontain">
	<label for="">课程名称</label>
	<span><g:link action="show" controller="timetable" id="${absenceRecordInstance.report.timetable.id}">${absenceRecordInstance.report.course}（${absenceRecordInstance.report.timetable.timetable}）</g:link></span>
</div>
<div class="fieldcontain">
	<label for="">教师</label>
	<span><g:link action="show" controller="user" id="${absenceRecordInstance.report.teacher.id}">${absenceRecordInstance.report.teacher}</g:link></span>
</div>
<div class="fieldcontain">
	<label for="">上课班级</label>
	<span>${absenceRecordInstance.report.classes}</span>
</div>
<div class="fieldcontain">
	<label for="">上课时间</label>
	<span><g:link action="show" controller="report" id="${absenceRecordInstance.report.id}"><g:formatDate date="${absenceRecordInstance.report.date}" format="yyyy-MM-dd"/> ${absenceRecordInstance.report.time}</g:link></span>
</div>

<div class="fieldcontain ${hasErrors(bean: absenceRecordInstance, field: 'student', 'error')} required">
	<label for="student">
		<g:message code="absenceRecord.student.label" default="Student" />
	</label>
	<g:link action="show" controller="student" id="${absenceRecordInstance?.student?.id}">${absenceRecordInstance?.student}</g:link>
</div>

<div class="fieldcontain">
	<label for="">班级</label>
	<span><g:link action="show" controller="classGrade" id="${absenceRecordInstance?.student?.classGrade?.id}">${absenceRecordInstance.student.classGrade}</g:link></span>
</div>

<div class="fieldcontain ${hasErrors(bean: absenceRecordInstance, field: 'status', 'error')} required">
	<label for="status">
		<g:message code="absenceRecord.status.label" default="Status" />
	</label>
	<span><g:message code="absenceRecord.status.${absenceRecordInstance.status}" default=" ${absenceRecordInstance.status} "/></span>
</div>

<div class="fieldcontain ${hasErrors(bean: absenceRecordInstance, field: 'hoursAbsence', 'error')} required">
	<label for="hoursAbsence">
		<g:message code="absenceRecord.hoursAbsence.label" default="Hours Absence" />
	</label>
	<span>${absenceRecordInstance.hoursAbsence}</span>
</div>

<div class="fieldcontain ${hasErrors(bean: absenceRecordInstance, field: 'finalStatus', 'error')} required">
	<label for="finalStatus">
		<g:message code="absenceRecord.finalStatus.label" default="Final Status" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="finalStatus" from="${absenceRecordInstance.constraints.finalStatus.inList}" required="" value="${fieldValue(bean: absenceRecordInstance, field: 'finalStatus')}" valueMessagePrefix="absenceRecord.finalStatus"/>
</div>

<div class="fieldcontain ${hasErrors(bean: absenceRecordInstance, field: 'remarks', 'error')} required">
	<label for="remarks">
		<g:message code="absenceRecord.remarks.label" default="Remarks" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="remarks" required="" value="${absenceRecordInstance?.remarks}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: absenceRecordInstance, field: 'verifier', 'error')} ">
	<label for="verifier">
		<g:message code="absenceRecord.verifier.label" default="Verifier" />
	</label>
	<span><mysec:realName/></span>
</div>
