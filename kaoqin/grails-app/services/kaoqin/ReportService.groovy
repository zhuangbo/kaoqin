package kaoqin

import grails.plugins.springsecurity.Secured;

@Secured(['ROLE_USER'])
class ReportService {
	
	static transactional = true
	
	// 确认提交考勤单，自动生成
	def confirmReport(Report report) {
		// 验证考勤情况
		//	 例如验证“张三旷课2节，李四[4]事假1，王五[23]病假2”得到结果：
		//	 [['张三', '旷课', '2节', [张三, 张三]], ['李四[4]', '事假', '1', [李四]], ['王五[23]', '病假', '2', []]]
		//	 表明：找到张三两人，尾号为4的李四一个，尾号23的王五没有找到
		def records = ReportHelper.checkContent(report)
		
		if(report.hasErrors())
			throw new RuntimeException("考勤情况填写有误")
		
		report.confirmed = true
		report.dateConfirmed = new Date()
		
		if(!report.save())
			throw new RuntimeException("确认考勤单遇到错误，无法确认，请重对后再确认")
		 
		// 保存缺勤记录
		records.each {
			def status = "旷课事假病假".indexOf(it[1]) / 2 + 1
			def hours = it[2].replaceAll("[^0-9]*", "").toInteger()
			def r = new AbsenceRecord(
					report:report,
					student:it[-1].first(),
					status: status,
					hoursAbsence: hours,
					verifier: null,
					finalStatus: status,
					remarks: null
				)
			if(!r.save()) throw new RuntimeException("保存考勤记录遇到错误 ${r.errors.allErrors[0]}，无法确认，请核对后再确认")
		}
	}
}
