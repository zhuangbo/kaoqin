package kaoqin

// 学生缺勤记录（根据教师提交的考勤情况自动创建）
class AbsenceRecord {
	// 任课教师提交
	Report report     // 考勤报告单
	Student student   // 学生
	int status        // 状态（旷课，事假，病假）
	int hoursAbsence  // 缺勤学时数
	// 辅导员审核
	User verifier     // 审核人（辅导员权限）
	int finalStatus   // 审核状态（取消，旷课，事假，病假）最终统计用
	String remarks     // 备注（填写取消、旷课、事假、病假或更改原因）
	
	// 时间戳
	Date dateCreated
	Date lastUpdated
	
	// 各类考勤状态
	public static final int STATUS_ATTEND = 0 // 取消
	public static final int STATUS_TRUANT = 1 // 旷课
	public static final int STATUS_LEAVE = 2 // 事假
	public static final int STATUS_SICK_LEAVE = 3 // 病假
	
	static belongsTo = [report : Report]

    static constraints = {
		report nullable:false
		student nullable:false
		status nullable:false, inList:[1,2,3]
		hoursAbsence nullable:false, min:1, max:12
		verifier nullable:true
		finalStatus nullable: false, inList:[0,1,2,3]
		remarks nullable:true, blank:true, validator: {val, obj->
			if(obj.verifier!=null && val==null) return 'null'
		}
    }
	
	static mapping = {
		status index:'status_idx'
		finalStatus index:'final_status_idx'
		report lazy: false
		
		sort dateCreated:'desc'
	}
}
