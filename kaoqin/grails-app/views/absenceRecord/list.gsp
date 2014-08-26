
<%@ page import="kaoqin.AbsenceRecord" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'absenceRecord.label', default: 'AbsenceRecord')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
<style type="text/css">
.red a:link,.red  a:visited,.red  a:hover {
	color: red;
}
.gray { color: #888; font-style: italic; }
.icon_accept {
	background-position: 0.7em center;
	background-repeat: no-repeat;
	padding-left: 36px;
    background-image: url('${fam.icon(name: 'accept')}');
}
.icon_magnifier {background-image: url('${fam.icon(name: 'magnifier')}');}
.exclamation {background-image: url('${fam.icon(name: 'exclamation')}');}
</style>
<jq:resources/>
<jq:jquery>
	// 年级、专业与班级不能同时选中
	$("#grade").change(function(){
		$("#classGrade").val(0);
	});
	$("#specialty").change(function(){
		$("#classGrade").val(0);
	});
	$("#classGrade").change(function(){
		$("#grade").val(0);
		$("#specialty").val("");
	});
</jq:jquery>
</head>
	<body>
		<a href="#list-absenceRecord" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="btn exclamation ${actionName=='listNotVerified'?'btnsel':''}" action="listNotVerified">待审核</g:link></li>
				<li><g:link class="list ${actionName=='list'?'btnsel':''}" action="list">全部</g:link></li>
			</ul>
		</div>
		<div id="list-absenceRecord" class="content scaffold-list" role="main">
			<g:if test="${actionName=='list'}">
			<div style="float: right; display: inline;">
				<g:form action="list" method="get">
				<g:select id="grade" name="grade" noSelection="${['0':'-年级-']}" from="${2010..2020}" value="${grade ?: 0}"/>
				<g:select id="specialty" name="specialty" noSelection="${['':'-专业-']}" from="${['计算机科学与技术','通信工程','计算机网络技术','软件技术']}" value="${specialty ?: ''}"/>
				<g:select id="classGrade" name="classGrade" noSelection="${['0':'-班级-']}" from="${kaoqin.ClassGrade.list()}" optionKey="id" value="${classGrade ?: 0}"/>
				<span class="buttons"><g:submitButton class="btn icon_magnifier" name="filter" value="筛选"/></span>
				<br/>
				<g:render template="/layouts/dateStartEnd"/>
				</g:form>
			</div>
			</g:if>
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
						<g:sortableColumn property="report" title="课程名称" />
						<g:sortableColumn property="report" title="教师" />
						<g:sortableColumn property="report" title="上课班级" />
						<g:sortableColumn property="report" title="上课时间" />
						<g:sortableColumn property="student" title="${message(code: 'absenceRecord.student.label', default: 'Student')}" />
						<th>班级</th>
						<g:sortableColumn property="status" title="${message(code: 'absenceRecord.status.label', default: 'Status')}" />
						<g:sortableColumn property="hoursAbsence" title="学时" />
						<g:sortableColumn property="finalStatus" title="审核结果" colspan="2" />
					</tr>
				</thead>
				<tbody>
				<g:each in="${absenceRecordInstanceList}" status="i" var="absenceRecordInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'} ${absenceRecordInstance.verifier ? '' : 'red'}">
					
						<td><g:link action="show" controller="timetable" id="${absenceRecordInstance.report.timetable.id}" title="查看课表">${absenceRecordInstance.report.course}（${absenceRecordInstance.report.timetable.timetable}）</g:link></td>
						<td><g:link action="show" controller="user" id="${absenceRecordInstance.report.teacher.id}" title="查看教师">${absenceRecordInstance.report.teacher}</g:link></td>
						<g:set var="classes" value="${absenceRecordInstance.report.classes}"/>
						<g:if test="${classes.length()>10}"><g:set var="classes" value="${classes[0..9]}..."/></g:if>
						<td><span title="${absenceRecordInstance.report.classes}">${classes}</span></td>
						<td><g:link action="show" controller="report" id="${absenceRecordInstance.report.id}" title="查看考勤单"><g:formatDate date="${absenceRecordInstance.report.date}" format="yyyy-MM-dd"/> ${absenceRecordInstance.report.time}</g:link></td>
					
						<g:set var="today" value="${new Date()-1 < absenceRecordInstance.report.date}"></g:set>
						<td><g:link action="show" controller="student" id="${absenceRecordInstance.student.id}" title="查看学生">${fieldValue(bean: absenceRecordInstance, field: "student")}</g:link><g:if test="${today}"><img src='${fam.icon(name: 'new')}'/></g:if></td>
						<td><g:link action="show" controller="classGrade" id="${absenceRecordInstance.student.classGrade.id}" title="查看班级">${absenceRecordInstance.student.classGrade}</g:link></td>
					
						<td>
							<g:link action="show" id="${absenceRecordInstance.id}" title="缺勤记录">
							<g:set var="theStatus"><g:message code="absenceRecord.status.${absenceRecordInstance.status}" default=" ${absenceRecordInstance.status} "/></g:set>
							<g:if test="${absenceRecordInstance.status == absenceRecordInstance.finalStatus}">${theStatus}</g:if>
							<g:else><s class="gray">${theStatus}</s></g:else>
							</g:link>
						</td>
					
						<td>${fieldValue(bean: absenceRecordInstance, field: "hoursAbsence")}</td>
					
						<g:set var="todayVerify" value="${new Date()-1 < absenceRecordInstance.lastUpdated}"></g:set>
						<td class="${absenceRecordInstance.status == absenceRecordInstance.finalStatus ? '' : 'red'}" nowrap="nowrap">
						<g:link action="show" id="${absenceRecordInstance.id}" title="审核结果">
						<g:message code="absenceRecord.finalStatus.${absenceRecordInstance.finalStatus}" default=" ${absenceRecordInstance.finalStatus} "/>
						</g:link>
						</td>
					<g:if test="${absenceRecordInstance.verifier}">
						<td><g:link action="show" id="${absenceRecordInstance.id}" title="${fieldValue(bean: absenceRecordInstance, field: "verifier")} 审核于 ${absenceRecordInstance.lastUpdated}">${fieldValue(bean: absenceRecordInstance, field: "remarks")}</g:link><g:if test="${todayVerify}"><img src='${fam.icon(name: 'new')}' title="${absenceRecordInstance.lastUpdated} 更新"/></g:if></td>
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
				<g:paginate total="${absenceRecordInstanceTotal}" params="${params}" max="20"/>
			</div>
			<g:if test="${actionName=='list'}">
			<div class="buttons">
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
			</g:if>
		</div>
	</body>
</html>
