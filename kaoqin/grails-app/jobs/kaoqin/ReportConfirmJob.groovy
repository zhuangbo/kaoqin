package kaoqin

import kaoqin.Report;

// 自动确认一个星期之前的空白（全勤）考勤单
class ReportConfirmJob {
	
	// 每天凌晨 2:00:00 触发执行
    static triggers = {
		cron name: 'ReportConfirmTrigger', cronExpression: "0 0 2 * * ?"
    }
	
    def execute() {
		log.info("自动确认空白（全勤）考勤单 —— 已取消")
//		log.info("自动确认空白（全勤）考勤单")
//		def dueDate = new Date() - 7 // 一个星期之前
//		Report.findAll { confirmed==false && absence==0 && content=="" && date<dueDate }.each { report->
//			report.confirmed = true
//			report.dateConfirmed = new Date()
//			report.content = "全勤（系统确认）"
//			try {
//				if(report.save(flush:true)) {
//					log.info("自动确认 ${report} 成功")
//				} else {
//					log.warn("* 自动确认 ${report} 失败")
//				}
//			} catch (Throwable e) {
//				log.warn("* 自动确认 ${report} 异常")
//			}
//		}
    }
}
