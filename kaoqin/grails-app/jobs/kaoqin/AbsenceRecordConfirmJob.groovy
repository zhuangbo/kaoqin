package kaoqin

import kaoqin.AbsenceRecord;
import kaoqin.Role;
import kaoqin.UserRole;

// 自动审核一个星期之前的缺勤记录
class AbsenceRecordConfirmJob {
	// 每天凌晨 2:15:00 触发执行
    static triggers = {
		cron name: 'AbsenceRecordConfirmTrigger', cronExpression: "0 15 2 * * ?"
    }
	
    def execute() {
		log.info("自动审核缺勤记录")
		// 任选一位辅导员
		def counsellor = UserRole.findByRole(Role.findByAuthority('ROLE_COUNSELLOR')).collect { it.user }.find()
		if(counsellor) {
			log.info("自动选择 ${counsellor} 审核缺勤记录")
			// 自动审核
			def dueDate = new Date() - 7 // 一个星期之前
			AbsenceRecord.findAll { verifier==null && dateCreated<dueDate }.each { record->
				record.verifier = counsellor
				record.finalStatus = record.status
				record.remarks = ['取消（自动）','旷课（自动）','事假（自动）','病假（自动）'][record.status]
				try {
					if(record.save(flush:true)) {
						log.info("自动审核 ${record} 成功")
					} else {
						log.warn("* 自动审核 ${record} 失败")
					}
				} catch (Throwable e) {
					log.warn("* 自动审核 ${record} 异常")
				}
			}
		} else {
			log.warn("* 自动审核：没找到辅导员")
		}
    }
}
