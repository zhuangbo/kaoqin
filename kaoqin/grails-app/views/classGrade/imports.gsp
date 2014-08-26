<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="layout" content="main"/>
<title>导入学生</title>
</head>
<body>
		<g:set var="entityName" value="${message(code: 'classGrade.label', default: 'ClassGrade')}" />
		<a href="#create-classGrade" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="imports-students" class="content scaffold-create" role="main">
			<h1>导入学生</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${classGradeInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${classGradeInstance}" var="error">
				<li><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form action="saveImports" >
				<fieldset class="form">
<div class="fieldcontain">
	<label for="classGrade">
		<g:message code="classGrade.label" default="Class Grade" />
	</label>
	<span id="classGrade">${classGradeInstance?.name}</span>
	<g:hiddenField name="id" value="${classGradeInstance?.id}"/>
</div>					
<div class="fieldcontain required">
	<label for="text">
		学生列表（学号、姓名，空白分隔，每行一人）
		<span class="required-indicator">*</span>
	</label>
	<g:textArea name="text" rows="20"></g:textArea>
</div>
				</fieldset>
				<fieldset class="buttons">
					<g:submitButton name="create" class="save" value="导入" />
				</fieldset>
			</g:form>
		</div>
</body>
</html>