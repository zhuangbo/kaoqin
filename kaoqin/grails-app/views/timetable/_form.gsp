<%@ page import="kaoqin.Timetable" %>


<div class="fieldcontain ${hasErrors(bean: timetableInstance, field: 'course', 'error')} required">
	<label for="course">
		<g:message code="timetable.course.label" default="Course" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="course" maxlength="50" required="" value="${timetableInstance?.course}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: timetableInstance, field: 'timetable', 'error')} required">
	<label for="timetable">
		<g:message code="timetable.timetable.label" default="Timetable" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="timetable" maxlength="50" required="" value="${timetableInstance?.timetable}"/>
	格式：X周Y/m-n节
</div>

<div class="fieldcontain ${hasErrors(bean: timetableInstance, field: 'classroom', 'error')} required">
	<label for="classroom">
		<g:message code="timetable.classroom.label" default="Classroom" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="classroom" maxlength="20" required="" value="${timetableInstance?.classroom}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: timetableInstance, field: 'classes', 'error')} required">
	<label for="classes">
		<g:message code="timetable.classes.label" default="Classes" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="classes" maxlength="50" required="" value="${timetableInstance?.classes}"/>
</div>

