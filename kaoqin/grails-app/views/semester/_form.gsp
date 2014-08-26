<%@ page import="kaoqin.Semester" %>



<div class="fieldcontain ${hasErrors(bean: semesterInstance, field: 'shortName', 'error')} required">
	<label for="shortName">
		<g:message code="semester.shortName.label" default="Short Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="shortName" maxlength="12" required="" value="${semesterInstance?.shortName}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: semesterInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="semester.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" maxlength="20" required="" value="${semesterInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: semesterInstance, field: 'dateStart', 'error')} required">
	<label for="dateStart">
		<g:message code="semester.dateStart.label" default="Date Start" />
		<span class="required-indicator">*</span>
	</label>
	<g:render template="/layouts/datePicker" model="[name:'dateStart', value:semesterInstance?.dateStart, relativeYears:-4..4]"/>
</div>

<div class="fieldcontain ${hasErrors(bean: semesterInstance, field: 'dateEnd', 'error')} required">
	<label for="dateEnd">
		<g:message code="semester.dateEnd.label" default="Date End" />
		<span class="required-indicator">*</span>
	</label>
	<g:render template="/layouts/datePicker" model="[name:'dateEnd', value:semesterInstance?.dateEnd, relativeYears:-4..4]"/>
</div>

<div class="fieldcontain ${hasErrors(bean: semesterInstance, field: 'timetables', 'error')} ">
	<label for="timetables">
		<g:message code="semester.timetables.label" default="Timetables" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${semesterInstance?.timetables?}" var="t">
    <li><g:link controller="timetable" action="show" id="${t.id}">${t?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="timetable" action="create" params="['semester.id': semesterInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'timetable.label', default: 'Timetable')])}</g:link>
</li>
</ul>

</div>

