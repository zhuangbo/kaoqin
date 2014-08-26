<style type="text/css">
.door_open { background-image: url('${fam.icon(name: 'door_open')}'); }
.chart { background-image: url('${fam.icon(name: 'chart_bar')}'); }
.magnifier { background-image: url('${fam.icon(name: 'magnifier')}'); }
.group { background-image: url('${fam.icon(name: 'group')}'); }
.book { background-image: url('${fam.icon(name: 'book_open')}'); }
.user_suit { background-image: url('${fam.icon(name: 'user_suit')}'); }
.accept { background-image: url('${fam.icon(name: 'accept')}'); }
</style>

		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="btn door_open ${actionName=='classes'?'btnsel':''}" action="classes">班级统计</g:link></li>
				<li><g:link class="btn group ${actionName=='students'?'btnsel':''}" action="students">学生统计</g:link></li>
				<li><g:link class="btn book ${actionName=='courses'?'btnsel':''}" action="courses">课程统计</g:link></li>
				<sec:ifAllGranted roles="ROLE_LEADER">
				<li><g:link class="btn user_suit ${actionName=='teachers'?'btnsel':''}" action="teachers">教师考勤</g:link></li>
				<li><g:link class="btn accept ${actionName=='counsellors'?'btnsel':''}" action="counsellors">审核情况</g:link></li>
				</sec:ifAllGranted>
			</ul>
		</div>
