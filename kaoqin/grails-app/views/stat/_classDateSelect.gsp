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
			<div style="float: right; display: inline;">
				<g:form action="${actionName}" method="get">
				<g:select id="grade" name="grade" noSelection="${['0':'-年级-']}" from="${2010..2020}" value="${grade ?: 0}"/>
				<g:select id="specialty" name="specialty" noSelection="${['':'-专业-']}" from="${['计算机科学与技术','通信工程','计算机网络技术','软件技术']}" value="${specialty ?: ''}"/>
				<g:select id="classGrade" name="classGrade" noSelection="${['0':'-班级-']}" from="${kaoqin.ClassGrade.list()}" optionKey="id" value="${classGrade ?: 0}"/>
				<span class="buttons"><g:submitButton class="btn magnifier" name="filter" value="统计"/></span>
				<br/>
				<g:render template="/layouts/dateStartEnd"/>
				</g:form>
			</div>