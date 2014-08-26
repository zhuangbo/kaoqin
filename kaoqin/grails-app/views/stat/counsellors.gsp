
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>审核情况统计</title>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<g:render template="menu"/>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<g:render template="dateSelect"/>
			<h1>审核情况统计</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
				<table>
				<thead>
					<tr><th>审核人</th><th>审核数</th><th>迟审3天</th><th>迟审7天</th></tr>
				</thead>
				<tbody>
				<g:each in="${stat}">
					<tr><td>${it.key}</td><td>${it.value[0]}</td><td style="color: blue;">${it.value[1]}</td><td class="red">${it.value[2]}</td></tr>
				</g:each>
				</tbody>
				</table>
				
				<table>
					<tr><td></td><td>应审核</td><td>已审核</td><td>未审核</td></tr>
					<tr><td>合计</td><td>${total}</td><td style="color: blue;">${verified}</td><td class="red">${total - verified}</td></tr>
				</table>
		</div>
	</body>
</html>
