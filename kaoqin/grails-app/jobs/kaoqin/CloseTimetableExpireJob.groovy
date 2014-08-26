package kaoqin

import kaoqin.Timetable;

// 自动关闭过期的课程表
//   注意：主要依据学期结束日期来判断
//   因为有时候经常会有延迟的情况发生
//   所以暂不严格按照课程表检查
class CloseTimetableExpireJob {
	// 星期一凌晨 2:10 执行
    static triggers = {
		cron name: 'CloseTimetableExpireTrigger', cronExpression: "0 10 2 ? * MON"
    }

    def execute() {
        // 关闭过期的课程表
		log.info("关闭过期的课程表")
		def now = new Date()
		Timetable.findAll { semester.dateEnd < now }.each {
			try {
				it.closed = true
				if(it.save(flush:true)) {
					log.info("关闭课程表 ${it} 成功")
				} else {
					log.warn("* 关闭课程表 ${it} 失败")
				}
			} catch (Throwable e) {
				log.warn("* 关闭课程表 ${it} 异常")
			}
		}
    }
}
