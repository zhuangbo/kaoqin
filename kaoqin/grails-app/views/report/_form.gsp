<%@ page import="kaoqin.Report" %>
<style>
.ui-autocomplete-loading {
    background: white url("${resource(dir:'images', file:'spinner.gif')}") right center no-repeat;
}
.ui-autocomplete {
	max-height: 180px;
	overflow-y: auto;
	overflow-x: hidden;
}
* html .ui-autocomplete {
	height: 180px;
}
</style>
<jq:resources/>
<jqui:resources/>
<jq:jquery>
    function split( val ) {
      return val.split( /[,，]\s*/ );
    }
    
    function extractLast( term ) {
      return split( term ).pop();
    }
    
    $( "#content" )
      // don't navigate away from the field on tab when selecting an item
      .bind( "keydown", function( event ) {
        if ( event.keyCode === $.ui.keyCode.TAB &&
            $( this ).data( "ui-autocomplete" ).menu.active ) {
          event.preventDefault();
        }
      })
      .autocomplete({
        source: function( request, response ) {
          // 前面是文字，则查找学生，前面是空格则提示旷课、事假和病假
          var lastChar = request.term.length>0 ? request.term.charAt(request.term.length-1) : ""
          if(lastChar==" ") {
	          response(["旷课","事假","病假"]);
          } else if(lastChar!="，" || lastChar!=",") {
            $.getJSON( "${createLink(controller:'student', action:'searchJSON')}", { term: extractLast( request.term ) }, response );
          }
        },
        search: function() {
          var term = extractLast( this.value );
          if ( term.length < 1 ) {
            return false;
          }
        },
        focus: function() {
          return false;
        },
        select: function( event, ui ) {
          var x = ui.item.value.split(/\s-\s/)[0]
          if(x=="旷课" || x=="事假" || x=="病假") {
            this.value = this.value.substr(0, this.value.length-1) + x
          } else {
            var terms = split( this.value );
            // remove the current input
            terms.pop();
            // add the selected item
            terms.push( x );
            this.value = terms.join( "，" );
          }
          return false;
        }
      });
</jq:jquery>



<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'timetable', 'error')} ">
	<label for="course">课程</label>
	<span style="color: green;"><b>${reportInstance?.timetable}</b></span>
</div>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'date', 'error')} required">
	<label for="date">上课时间 <span class="required-indicator">*</span></label>
	<g:render template="/layouts/datePicker" model="[name:'date', value:reportInstance?.date]"/>
	<span class="required-indicator">*</span>
	<g:textField name="time" required="" value="${reportInstance?.time}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'time', 'error')} required">
</div>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'absence', 'error')} required">
	<label for="absence">
		<g:message code="report.absence.label" default="Absence" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="absence" type="number" min="0" max="100" value="${reportInstance.absence}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'content', 'error')} ">
	<label for="content">
		<g:message code="report.content.label" default="Content" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="content" value="${reportInstance?.content}" style="width: 60%" title="全勤不填。缺勤如：张三旷课，李四事假1节，王五[3]病假"/>
</div>
<div class="fieldcontain ">
	<label for="content"></label>
	<div style="display: inline-block; vertical-align: top;">
	<g:if test="${actionName=='create'}">
	举例：<b>张三旷课，李四事假1节，王五[3]病假</b><br/>
	格式：全勤不填；缺勤记录“<span style="color: blue">姓名状态x节</span>”状态={旷课|事假|病假}。<br/>
	（1）姓名后加 [ ] 或【】注明<i>学号后几位</i>区分重名。<br/>
	（2）学时数可只写数字 x，省略则表示整次课缺勤。<br/>
	（3）多项之间用逗号（中英文均可）隔开。<br/>
	（4）输入部分姓名自动提示，按空格提示状态（旷课、事假、病假）。
	</g:if>
	<g:elseif test="${records}">
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
	</g:elseif>
	</div>
</div>

<div class="fieldcontain ">
	<span>如有必要，请填写以下内容：</span>
</div>
<hr/>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'hours', 'error')} required">
	<label for="hours">
		<g:message code="report.hours.label" default="Hours" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="hours" type="number" min="1" max="12" value="${reportInstance.hours}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'classes', 'error')} required">
	<label for="classes">
		<g:message code="report.classes.label" default="Classes" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="classes" required="" value="${reportInstance?.classes}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: reportInstance, field: 'classroom', 'error')} required">
	<label for="classroom">
		<g:message code="report.classroom.label" default="Classroom" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="classroom" required="" value="${reportInstance?.classroom}"/>
</div>
