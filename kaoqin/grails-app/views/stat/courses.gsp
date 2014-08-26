
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>课程缺勤统计</title>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<g:render template="menu"/>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<g:render template="classDateSelect"/>
			<h1>课程缺勤统计</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
				<table>
				<thead>
					<tr>
						<g:sortableColumn property="0" title="课程"/>
						<g:sortableColumn property="1" title="教师"/>
						<g:sortableColumn property="3" title="旷课"/>
						<g:sortableColumn property="4" title="事假"/>
						<g:sortableColumn property="5" title="病假"/>
						<g:sortableColumn property="2" title="其他"/>
						<g:sortableColumn property="6" title="总次数"/>
						<g:sortableColumn property="8" title="旷课"/>
						<g:sortableColumn property="9" title="事假"/>
						<g:sortableColumn property="10" title="病假"/>
						<g:sortableColumn property="7" title="其他"/>
						<g:sortableColumn property="11" title="总时数"/>
					</tr>
				</thead>
				<tbody>
				<g:each in="${stat}" status="i" var="s">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td>${s[0]}</td>
						<td>${s[1]}</td>
						<td class="red">${s[3]}</td>
						<td style="color: #f0f;">${s[4]}</td>
						<td style="color: blue;">${s[5]}</td>
						<td>${s[2]}</td>
						<td>${s[6]}</td>
						<td class="red">${s[8]}</td>
						<td style="color: #f0f;">${s[9]}</td>
						<td style="color: blue;">${s[10]}</td>
						<td>${s[7]}</td>
						<td>${s[11]}</td>
					</tr>
				</g:each>
				</tbody>
				</table>
			<div class="pagination">
				<g:paginate total="${total}" params="${params}" max="20"/>
			</div>
		</div>
	</body>
</html>
