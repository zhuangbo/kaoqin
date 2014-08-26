
<%@ page import="kaoqin.AbsenceRecord" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>缺勤总数统计</title>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<g:render template="menu"/>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<g:render template="classDateSelect"/>
			<h1>缺勤总数统计</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
				<table>
				<thead>
					<tr><th>缺勤情况</th><th>合计</th><th>旷课</th><th>事假</th><th>病假</th><th>其他</th><th>备注</th></tr>
				</thead>
				<tbody>
					<tr><td>人次数</td><td>${stat[0][4]}</td><td>${stat[0][1]}</td><td>${stat[0][2]}</td><td>${stat[0][3]}</td><td>${stat[0][0]}</td><td><g:if test="${stat[0][5]}">含未审核${stat[0][5]}人次</g:if></td></tr>
					<tr><td>学时数</td><td>${stat[1][4]}</td><td>${stat[1][1]}</td><td>${stat[1][2]}</td><td>${stat[1][3]}</td><td>${stat[1][0]}</td><td><g:if test="${stat[0][5]}">含未审核${stat[1][5]}学时</g:if></td></tr>
				</tbody>
				</table>
		</div>
	</body>
</html>
