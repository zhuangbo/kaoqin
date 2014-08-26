<g:set var="yearNow" value="${new Date().year+1900}"/>
<g:hiddenField name="start" value="date.struct"/>
<g:select name="start_year" value="${start ? start.year+1900 : ''}" from="${yearNow-2..yearNow+2}" noSelection="['':'-年-']"/>
<g:select name="start_month" value="${start ? start.month+1 : ''}" from="${1..12}" noSelection="['':'-月-']"/>
<g:select name="start_day" value="${start ? start.date : ''}" from="${1..31}" noSelection="['':'-日-']"/>
至
<g:hiddenField name="end" value="date.struct"/>
<g:select name="end_year" value="${end ? end.year+1900 : ''}" from="${yearNow-2..yearNow+2}" noSelection="['':'-年-']"/>
<g:select name="end_month" value="${end ? end.month+1 : ''}" from="${1..12}" noSelection="['':'-月-']"/>
<g:select name="end_day" value="${end ? end.date : ''}" from="${1..31}" noSelection="['':'-日-']"/>