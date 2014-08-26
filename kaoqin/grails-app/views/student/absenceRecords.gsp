
<%@ page import="kaoqin.AbsenceRecord" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'student.label', default: 'Student')}" />
		<title>${studentInstance.name}[${studentInstance.no}]的缺勤记录</title>
<style type="text/css">
.red a:link,.red  a:visited,.red  a:hover {
	color: red;
}
.gray { color: #888; font-style: italic;}
.icon_accept {
	background-position: 0.7em center;
	background-repeat: no-repeat;
	padding-left: 36px;
    background-image: url('${fam.icon(name: 'accept')}');
}
.icon_magnifier {
    background-image: url('${fam.icon(name: 'magnifier')}');
}
</style>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<div style="float: right; display: inline;">
				<g:form action="absenceRecords" method="get">
				<g:hiddenField name="id" value="${studentInstance.id}"/>
				<g:datePicker name="start" precision="day" value="${start}" default="none" noSelection="['':'']" relativeYears="${-4..4}"/>至<g:datePicker name="end" precision="day" value="${end}" default="none" noSelection="['':'']" relativeYears="${-4..4}"/>
				<span class="buttons"><g:submitButton class="btn icon_magnifier" name="filter" value="筛选"/></span>
				</g:form>
			</div>
			<h1>${studentInstance.name}[${studentInstance.no}]的缺勤记录</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
						<th>课程名称</th>
						<th>教师</th>
						<th>上课班级</th>
						<th>上课时间</th>
						<g:sortableColumn property="student" title="${message(code: 'absenceRecord.student.label', default: 'Student')}" />
						<th>班级</th>
						<th>${message(code: 'absenceRecord.status.label', default: 'Status')}</th>
						<th>学时</th>
						<th colspan="2">审核结果</th>
					</tr>
				</thead>
				<tbody>
				<g:each in="${absenceRecordInstanceList}" status="i" var="absenceRecordInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'} ${absenceRecordInstance.verifier ? '' : 'red'}">
					
						<td><g:link action="show" controller="timetable" id="${absenceRecordInstance.report.timetable.id}" title="查看课表">${absenceRecordInstance.report.course}（${absenceRecordInstance.report.timetable.timetable}）</g:link></td>
						<td>${absenceRecordInstance.report.teacher}</td>
						<td>${absenceRecordInstance.report.classes}</td>
						<td><g:link action="show" controller="report" id="${absenceRecordInstance.report.id}" title="查看考勤单"><g:formatDate date="${absenceRecordInstance.report.date}" format="yyyy-MM-dd"/> ${absenceRecordInstance.report.time}</g:link></td>
					
						<g:set var="today" value="${new Date()-1 < absenceRecordInstance.report.date}"></g:set>
						<td><g:link action="show" controller="student" id="${absenceRecordInstance.student.id}" title="查看学生">${fieldValue(bean: absenceRecordInstance, field: "student")}</g:link><g:if test="${today}"><img src='${fam.icon(name: 'new')}'/></g:if></td>
						<td>${absenceRecordInstance.student.classGrade}</td>
					
						<td>
							<g:link action="show" controller="absenceRecord" id="${absenceRecordInstance.id}" title="查看缺勤记录">
							<g:set var="theStatus"><g:message code="absenceRecord.status.${absenceRecordInstance.status}" default=" ${absenceRecordInstance.status} "/></g:set>
							<g:if test="${absenceRecordInstance.status == absenceRecordInstance.finalStatus}">${theStatus}</g:if>
							<g:else><s class="gray">${theStatus}</s></g:else>
							</g:link>
						</td>
					
						<td>${fieldValue(bean: absenceRecordInstance, field: "hoursAbsence")}</td>
					
						<g:set var="todayVerify" value="${new Date()-1 < absenceRecordInstance.lastUpdated}"></g:set>
						<td class="${absenceRecordInstance.status == absenceRecordInstance.finalStatus ? '' : 'red'}">
						<g:message code="absenceRecord.finalStatus.${absenceRecordInstance.finalStatus}" default=" ${absenceRecordInstance.finalStatus} "/>
						</td>
					<g:if test="${absenceRecordInstance.verifier}">
						<td>${fieldValue(bean: absenceRecordInstance, field: "verifier")}：${fieldValue(bean: absenceRecordInstance, field: "remarks")}<g:if test="${todayVerify}"><img src='${fam.icon(name: 'new')}'/></g:if></td>
					</g:if>
					<g:else>
						<td nowrap="nowrap">
						<span class="buttons">
						<g:link class="btn icon_accept" action="approve" id="${absenceRecordInstance.id}" title="审核通过">&nbsp;</g:link>
						<g:link class="btn edit" action="edit" id="${absenceRecordInstance.id}" title="修改审核意见">&nbsp;</g:link>
						</span>
						</td>
					</g:else>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${absenceRecordInstanceTotal}" params="${params}"/>
			</div>
			<div class="buttons" style="color:blue;">
				合计：共${stat[0][4]}次（旷课${stat[0][1]}/事假${stat[0][2]}/病假${stat[0][3]}/其他${stat[0][0]}，含未确认${stat[2]}），共${stat[1][4]}学时（旷课${stat[1][1]}/事假${stat[1][2]}/病假${stat[1][3]}/其他${stat[1][0]}）
			</div>
		</div>
	</body>
</html>
