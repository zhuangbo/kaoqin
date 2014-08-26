
<%@page import="kaoqin.Role"%>
<%@ page import="kaoqin.User" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-user" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
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
		<div id="show-user" class="content scaffold-show" role="main">
			<h1>用户授权</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list user">
			
				<g:if test="${userInstance?.username}">
				<li class="fieldcontain">
					<span id="username-label" class="property-label"><g:message code="user.username.label" default="Username" /></span>
					
						<span class="property-value" aria-labelledby="username-label"><g:fieldValue bean="${userInstance}" field="username"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.realName}">
				<li class="fieldcontain">
					<span id="realName-label" class="property-label"><g:message code="user.realName.label" default="Real Name" /></span>
					
						<span class="property-value" aria-labelledby="realName-label"><g:fieldValue bean="${userInstance}" field="realName"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset>
				<g:set var="authorities" value="${userInstance?.authorities}" />
				<g:each var="role" in="${Role.list()}">
					<div class="fieldcontain">
						<g:set var="authority" value="${role.authority}" />
						<g:set var="msg" value="${role.toString()}" />
						<g:set var="name" value="roles.${role.id}" />
						<label for="${name}">${msg}</label><input type="checkbox" name="${name}" id="${name}" ${(authorities.contains(role)) ? 'checked="checked"' : ''} />
					</div>
				</g:each>
				</fieldset>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${userInstance.id}"/>
					<g:actionSubmit class="save" action="saveGrant" value="保存" />
					<g:link class="delete" action="show" id="${userInstance?.id}">放弃</g:link>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
