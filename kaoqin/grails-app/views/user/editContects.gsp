
<%@ page import="kaoqin.User" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title>更新联系方式</title>
	</head>
	<body>
		<a href="#show-user" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_LEADER">
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
				</sec:ifAnyGranted>
			</ul>
		</div>
		<div id="show-user" class="content scaffold-show" role="main">
			<h1>更新联系方式</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
		<g:form method="post" >
			<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'username', 'error')} required">
				<label for="text">
				</label>
				<span>联系方式允许多行，可省略手机号码或邮箱，每行必须符合格式：教师号&lt;TAB&gt;手机&lt;TAB&gt;邮箱</span>
			</div>
			<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'username', 'error')} required">
				<fieldset class="form">
				<label for="text">
					联系方式
					<span class="required-indicator">*</span>
				</label>
				<g:textArea name="text" rows="20" style="width: 70%">${text}</g:textArea>
				</fieldset>
				<fieldset class="buttons">
					<g:actionSubmit class="save" action="updateContects" value="更新" />
				</fieldset>
			</div>
		</g:form>
		</div>
	</body>
</html>
