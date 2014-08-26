<%@ page import="kaoqin.ClassGrade" %>



<div class="fieldcontain ${hasErrors(bean: classGradeInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="classGrade.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" maxlength="20" required="" value="${classGradeInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: classGradeInstance, field: 'specialty', 'error')} required">
	<label for="specialty">
		<g:message code="classGrade.specialty.label" default="Specialty" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="specialty" name="specialty" required="" from="${['计算机科学与技术','通信工程','计算机网络技术','软件技术']}" value="${classGradeInstance?.specialty}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: classGradeInstance, field: 'grade', 'error')} required">
	<label for="grade">
		<g:message code="classGrade.grade.label" default="Grade" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="grade" type="number" min="2010" max="2020" value="${classGradeInstance.grade}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: classGradeInstance, field: 'classNo', 'error')} required">
	<label for="classNo">
		<g:message code="classGrade.classNo.label" default="Class No" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="classNo" type="number" min="1" max="20" value="${classGradeInstance.classNo}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: classGradeInstance, field: 'advisor', 'error')} required">
	<label for="advisor">
		<g:message code="classGrade.advisor.label" default="Advisor" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="advisor" name="advisor.id" from="${kaoqin.User.list()}" optionKey="id" required="" value="${classGradeInstance?.advisor?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: classGradeInstance, field: 'students', 'error')} ">
	<label for="students">
		<g:message code="classGrade.students.label" default="Students" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${classGradeInstance?.students?}" var="s">
    <li><g:link controller="student" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="student" action="create" params="['classGrade.id': classGradeInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'student.label', default: 'Student')])}</g:link>
</li>
</ul>

</div>

