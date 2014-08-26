<%@ page import="kaoqin.Timetable" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'timetable.label', default: 'Timetable')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#create-timetable" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="create-timetable" class="content scaffold-create" role="main">
			<h1><g:message code="default.create.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${timetableInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${timetableInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:if test="${timetableInstance.semester==null}">
				<ul class="errors" role="alert"><li>注意：找不到合适的学期，请联系管理员定义学期信息。</li></ul>
			</g:if>
			<g:form action="save" >
				<fieldset class="form">
<g:if test="${timetableInstance.semester}">
	<div>
	请输入您 <b>${timetableInstance.semester.name}</b> 课程表：
	<p>1. <b>课程表中的每一次课作为一个记录输入。</b>相同课程在不同时间上课、相同时间（星期、节次）上不同课程要分别输入。</p>
	<p>2. <b>“上课时间”请按规定格式输入，系统会提取相应信息，以便实现提醒功能。</b>具体参照下面给出的七个例子（输入不包括引号）：“每周二/8-10节”，“全周二/1-2节”，“单周二/3-4节”，“双周二/3-5节”，“1-12周二/6-7节”，“3,6,9周二/1-2节”，“3-6,9,11-13周二/3-4节”。</p>
	</div>
</g:if>
					<g:render template="form"/>
				</fieldset>
				<fieldset class="buttons">
					<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
