<%@ page import="kaoqin.ClassHour" %>



<div class="fieldcontain ${hasErrors(bean: classHourInstance, field: 'number', 'error')} required">
	<label for="number">
		<g:message code="classHour.number.label" default="Number" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="number" type="number" min="1" max="12" value="${classHourInstance.number}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: classHourInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="classHour.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" maxlength="20" required="" value="${classHourInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: classHourInstance, field: 'timeStart', 'error')} required">
	<label for="timeStart">
		<g:message code="classHour.timeStart.label" default="Time Start" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="timeStart" maxlength="5" pattern="${classHourInstance.constraints.timeStart.matches}" required="" value="${classHourInstance?.timeStart}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: classHourInstance, field: 'timeEnd', 'error')} required">
	<label for="timeEnd">
		<g:message code="classHour.timeEnd.label" default="Time End" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="timeEnd" maxlength="5" pattern="${classHourInstance.constraints.timeEnd.matches}" required="" value="${classHourInstance?.timeEnd}"/>
</div>

