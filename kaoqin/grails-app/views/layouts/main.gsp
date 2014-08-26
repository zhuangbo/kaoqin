<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="课堂考勤"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
		<g:layoutHead/>
		<r:layoutResources />
	</head>
	<body>
		<div id="header">
			<div style="float: right; margin: 0;"><g:render template="/layouts/menu"/></div>
			<p><a href="${createLink(uri: '/')}" class="header-main">课堂考勤</a></p>
			<div style="float: right; margin: 0;">
			<ul id="coolMenu">
<sec:ifNotLoggedIn>
    <li><g:link controller="login"><img src="${fam.icon(name: 'key')}" /> 登录</g:link></li>
</sec:ifNotLoggedIn>
<sec:ifLoggedIn>
    <li><g:link controller="user" action="me" title="当前用户"><img src="${fam.icon(name: 'user')}" /> <mysec:realName/></g:link>
    	<ul>
    		<li><g:link controller="user" action="me"><img src="${fam.icon(name: 'user')}" /> 用户信息</g:link></li>
    		<li><g:link controller="user" action="changePassword"><img src="${fam.icon(name: 'key')}" /> 修改密码</g:link></li>
    		<li><g:link controller="user" action="changeContect"><img src="${fam.icon(name: 'phone')}" /> 修改联系方式</g:link></li>
    	</ul>
    </li>
    <li><g:link controller="logout"><img src="${fam.icon(name: 'cross')}" /> 退出</g:link></li>
</sec:ifLoggedIn>
			</ul>
			</div>
			<p class="header-sub">计算机系课堂考勤系统</p>
		</div>
		<g:layoutBody/>
		<div class="footer" role="contentinfo">Copyright &copy; 2013 Department of Computer Science and Technology, Binzhou University.
				<div style="float: right">Version: <g:meta name="app.version"/>,  Grails: <g:meta name="app.grails.version"/></div>
		</div>
		<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
		<g:javascript library="application"/>
		<r:layoutResources />
	</body>
</html>
