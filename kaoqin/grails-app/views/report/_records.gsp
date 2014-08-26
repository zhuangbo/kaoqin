<%@ page contentType="text/html;charset=UTF-8" %>
<g:if test="${records}">
<style type="text/css" media="screen">
.icon_user {
	background-position: 0.7em center;
	background-repeat: no-repeat;
	text-indent: 25px;
	padding-left: 36px;
    background-image: url('${fam.icon(name: 'user')}');
}
</style>
		<table style="font-size: 0.8em">
		<thead>
			<tr><th>学生姓名</th><th>缺勤情况</th><th>缺勤节数</th><th>提示</th></tr>
		</thead>
		<tbody>
		<g:each in="${records}">
			<g:set var="stu_status" value="${it.size()>2 ? it[1] : ''}"/>
			<g:set var="stu_hours" value="${it.size()>3 ? it[2] : ''}"/>
			<tr>
			<td>${it[0]}</td>
			<td class="${stu_status ? '' : 'red'}">${stu_status}</td>
			<td class="${!(it[2]==~"^[0-9]+.*") || !(it[2].replaceAll("[^0-9]*", "").toInteger() in (1..reportInstance.hours)) ? 'red' : ''}">${stu_hours}</td>
			<td class="${it[-1].size()==1 ? '' : 'red'}">
				<g:each var="s" in="${it[-1]}">
					<span class="icon_user">${s.name}【${s.no}】${s.classGrade}</span>
				</g:each>
			</td>
			</tr>
		</g:each>
		</tbody>
		</table>
</g:if>
