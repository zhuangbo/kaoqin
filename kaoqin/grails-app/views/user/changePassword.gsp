<%@ page import="kaoqin.User" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title>修改密码</title>
	</head>
	<body>
		<a href="#edit-user" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_LEADER">
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="editContects">批量更新联系方式</g:link></li>
				</sec:ifAnyGranted>
			</ul>
		</div>
		<div id="edit-user" class="content scaffold-edit" role="main">
			<h1>修改密码</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${changePasswordCommand}">
			<ul class="errors" role="alert">
				<g:eachError bean="${changePasswordCommand}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form method="post" >
				<fieldset class="form">
<div class="fieldcontain ${hasErrors(bean: changePasswordCommand, field: 'oldPassword', 'error')} required">
	<label for="oldPassword">输入原密码<span class="required-indicator">*</span></label>
	<g:passwordField name="oldPassword" required="" value="${changePasswordCommand?.oldPassword}"/>
</div>
<div class="fieldcontain ${hasErrors(bean: changePasswordCommand, field: 'newPassword', 'error')} required">
	<label for="newPassword">输入新密码<span class="required-indicator">*</span></label>
	<g:passwordField name="newPassword" required="" value="${changePasswordCommand?.newPassword}"/>
</div>
<div class="fieldcontain ${hasErrors(bean: changePasswordCommand, field: 'repeatPassword', 'error')} required">
	<label for="repeatPassword">重复新密码<span class="required-indicator">*</span></label>
	<g:passwordField name="repeatPassword" required="" value="${changePasswordCommand?.repeatPassword}"/>
</div>
				</fieldset>
				<fieldset class="buttons">
					<g:actionSubmit class="save" action="doChangePassword" value="修改" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
