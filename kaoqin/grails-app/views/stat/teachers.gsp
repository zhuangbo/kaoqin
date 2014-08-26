
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>教师考勤统计</title>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<g:render template="menu"/>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<g:render template="dateSelect"/>
			<h1>教师考勤统计</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
				<table>
				<thead>
					<tr><th>任课教师</th><th>考勤次数</th><th>已确认</th><th>未确认</th><th>迟报3天</th><th>漏报7天以上</th></tr>
				</thead>
				<tbody>
				<g:each in="${stat}">
					<tr><td><g:link controller="user" action="show" id="${it.key.id}">${it.key}</g:link></td>
					<td>${it.value[0]}</td><td>${it.value[1]}</td><td class="red">${it.value[2]}</td><td>${it.value[3]}</td><td class="red">${it.value[4]}</td></tr>
				</g:each>
				</tbody>
				</table>
		</div>
	</body>
</html>
