
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>学生缺勤统计</title>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<g:render template="menu"/>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<g:render template="classDateSelect"/>
			<h1>学生缺勤统计</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
				<table>
				<thead>
					<tr>
						<g:sortableColumn property="1" title="学号"/>
						<g:sortableColumn property="2" title="姓名"/>
						<g:sortableColumn property="3" title="班级"/>
						<g:sortableColumn property="5" title="旷课"/>
						<g:sortableColumn property="6" title="事假"/>
						<g:sortableColumn property="7" title="病假"/>
						<g:sortableColumn property="4" title="其他"/>
						<g:sortableColumn property="8" title="总次数"/>
						<g:sortableColumn property="10" title="旷课"/>
						<g:sortableColumn property="11" title="事假"/>
						<g:sortableColumn property="12" title="病假"/>
						<g:sortableColumn property="9" title="其他"/>
						<g:sortableColumn property="13" title="总时数"/>
					</tr>
				</thead>
				<tbody>
				<g:each in="${stat}" status="i" var="s">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td>${s[1]}</td>
						<td><g:link controller="student" action="show" id="${s[0]}">${s[2]}</g:link></td>
						<td>${s[3]}</td>
						<td class="red">${s[5]}</td>
						<td style="color: #f0f;">${s[6]}</td>
						<td style="color: blue;">${s[7]}</td>
						<td>${s[4]}</td>
						<td><g:link controller="student" action="absenceRecords" id="${s[0]}">${s[8]}</g:link></td>
						<td class="red">${s[10]}</td>
						<td style="color: #f0f;">${s[11]}</td>
						<td style="color: blue;">${s[12]}</td>
						<td>${s[9]}</td>
						<td><g:link controller="student" action="absenceRecords" id="${s[0]}">${s[13]}</g:link></td>
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
