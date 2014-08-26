package kaoqin

// 自动创建当天上课用的考勤单
class ReportCreateJob {
	
	// 每天凌晨 2:30:00 触发执行
    static triggers = {
      cron name: 'ReportCreateTrigger', cronExpression: "0 30 2 * * ?"
    }
	
	def group = "KaoqinJobs"

    def execute() {
        // 检查本学期课程表，找出今天上课的课程，为其创建空白的考勤单（自动避免重复创建）
    	log.info("准备为今天的课程创建考勤单")
		Semester.current()?.timetables.findAll { it.closed==false && it.haveLesson() }.each {
			if(!ReportHelper.createReportOf(it).save(flush:true)) {
				log.warn("创建考勤单 ${it} 失败")
			} else {
				log.info("创建考勤单 ${it} 成功")
			}
		}
    }
}
