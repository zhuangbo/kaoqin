<%@ page import="kaoqin.Student" %>



<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'no', 'error')} required">
	<label for="no">
		<g:message code="student.no.label" default="No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="no" maxlength="20" required="" value="${studentInstance?.no}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="student.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" maxlength="20" required="" value="${studentInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'classGrade', 'error')} required">
	<label for="classGrade">
		<g:message code="student.classGrade.label" default="Class Grade" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="classGrade" name="classGrade.id" from="${kaoqin.ClassGrade.list()}" optionKey="id" required="" value="${studentInstance?.classGrade?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'enabled', 'error')} ">
	<label for="enabled">
		<g:message code="student.enabled.label" default="Enabled" />
		
	</label>
	<g:checkBox name="enabled" value="${studentInstance?.enabled}" />
</div>

