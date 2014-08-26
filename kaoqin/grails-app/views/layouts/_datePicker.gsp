<g:if test="${years==null}">
<g:set var="_year" value="${new GregorianCalendar().get(GregorianCalendar.YEAR)}"/>
<g:if test="${relativeYears!=null}">
<g:set var="years" value="${(_year+relativeYears.fromInt)..(_year+relativeYears.toInt)}"/>
</g:if><g:else>
<g:set var="years" value="${(_year-1)..(_year+1)}"/>
</g:else></g:if>
<g:hiddenField name="${name}" value="date.struct"/>
<g:select name="${name}_year" value="${value ? value.year+1900 : ''}" from="${years}" noSelection="${noSelection}"/>
<g:select name="${name}_month" value="${value ? value.month+1 : ''}" from="${1..12}" noSelection="${noSelection}"/>
<g:select name="${name}_day" value="${value ? value.date : ''}" from="${1..31}" noSelection="${noSelection}"/>
