package kaoqin

import grails.plugins.springsecurity.Secured;

// 统计功能
@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class StatController {

	// 统计功能首页
    def index() {
		def g = params.grade!=null ? params.grade.toInteger() : 0  // 年级
		def s = params.specialty!=null ? params.specialty : ''  // 专业
		def c = params.classGrade!=null ? params.classGrade.toInteger() : 0 // 班级
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		// 构造条件查询
		def q = AbsenceRecord.where {}
		//   日期范围
		if(start) q = q.where {report.date>=start}
		if(end) q = q.where {report.date<=end}
		//   年级、专业、班级
		if(g || s || c) {
			def cgs = ClassGrade.where {}
			if(g) cgs = cgs.where {grade==g}
			if(s) cgs = cgs.where {specialty==s}
			if(c) cgs = cgs.where {id==c}
			def classGrades = cgs.list().collect { it.id } as Set
			classGrades << 0L  // FIX: 集合为空时生成的SQL语句有误，此处添加一个无效的id以保证集合不空
			q = q.where { student.classGrade.id in classGrades }
		}
		// 统计数据
		def stat = statData(q)

		// 返回结果
		[grade: g, specialty: s, classGrade: c, start: start, end: end, stat: stat]
	}
	
	// 统计结果（stat[0]人次数，stat[1]学时数，
	//    [0]未缺勤，[1]旷课，[2]事假，[3]病假，[4]合计，[5]未审核，
	//    如：stat[0][1] 为旷课人次）
	private def statData(q) {
		def stat = [[0,0,0,0,0,0], [0,0,0,0,0,0]]
		def a = q.list()  // all result
		a.each {
			stat[0][it.finalStatus] ++
			stat[1][it.finalStatus] += it.hoursAbsence
			stat[0][5] += it.verifier ? 0 : 1   // 统计未审核的人次数
			stat[1][5] += it.verifier ? 0 : it.hoursAbsence   // 统计未审核的学时数
		}
		stat[0][4] = stat[0][0..3].sum()
		stat[1][4] = stat[1][0..3].sum()
		
		return stat
	}

	// 根据年级、专业、时间范围统计各班级出勤情况
	def classes() {
		def g = params.grade!=null ? params.grade.toInteger() : 0  // 年级
		def s = params.specialty!=null ? params.specialty : ''  // 专业
		def c = params.classGrade!=null ? params.classGrade.toInteger() : 0 // 班级
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		// 构造条件查询
		def q = AbsenceRecord.where {}
		//   日期范围
		if(start) q = q.where {report.date>=start}
		if(end) q = q.where {report.date<=end}
		//   年级、专业、班级
		if(g || s || c) {
			def cgs = ClassGrade.where {}
			if(g) cgs = cgs.where {grade==g}
			if(s) cgs = cgs.where {specialty==s}
			if(c) cgs = cgs.where {id==c}
			def classGrades = cgs.list().collect { it.id } as Set
			classGrades << 0L  // FIX: 集合为空时生成的SQL语句有误，此处添加一个无效的id以保证集合不空
			q = q.where { student.classGrade.id in classGrades }
		}
		// 按班级统计缺勤
		def result = [:]
		q.list().each {
			def cg = it.student.classGrade
			// [0]班级id，班级名，[2]其他次数，旷课次数，事假次数，病假次数，[6]缺勤总次数，[7]其他时数，旷课时数，事假时数，病假时数，[11]缺勤总时数
			if(!result[cg]) result[cg] = [cg.id, cg.name, 0,0,0,0,0,0,0,0,0,0]
			result[cg][2 + it.status] += 1   // [2]其他次数，旷课次数，事假次数，病假次数
			result[cg][6] += it.status!=AbsenceRecord.STATUS_ATTEND ? 1 : 0  // 缺勤总次数
			
			result[cg][7 + it.status] += it.hoursAbsence  // [7]其他时数，旷课时数，事假时数，病假时数
			result[cg][11] += it.status!=AbsenceRecord.STATUS_ATTEND ? it.hoursAbsence : 0  // 缺勤总时数
		}
		// 数据排序
		def sort = params.sort!=null ? params.sort.toInteger() : 8 // 默认按旷课时数排序
		def order = params.order ?: 'desc'  // 默认倒序排序
		def sign = order=='desc' ? -1 : 1
		
		def stat = result.collect { it.value }.sort {s1,s2->
			return sign * s1[sort].compareTo(s2[sort])
		}
		// 处理分页
		def offset = params.offset!=null ? params.offset.toInteger() : 0
		def max = params.max!=null ? Math.min(params.max.toInteger(), 20) : 20
		def last = Math.min(offset+max-1, stat.size()-1)
		// 返回结果
		[grade: g, specialty: s, classGrade: c, start: start, end: end, stat: offset<=last ? stat[offset..last] : [], total: stat.size()]
	}
	
	// 统计某学生缺勤情况
	def students() {
		def g = params.grade!=null ? params.grade.toInteger() : 0  // 年级
		def s = params.specialty!=null ? params.specialty : ''  // 专业
		def c = params.classGrade!=null ? params.classGrade.toInteger() : 0 // 班级
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		// 构造条件查询
		def q = AbsenceRecord.where {}
		//   日期范围
		if(start) q = q.where {report.date>=start}
		if(end) q = q.where {report.date<=end}
		//   年级、专业、班级
		if(g || s || c) {
			def cgs = ClassGrade.where {}
			if(g) cgs = cgs.where {grade==g}
			if(s) cgs = cgs.where {specialty==s}
			if(c) cgs = cgs.where {id==c}
			def classGrades = cgs.list().collect { it.id } as Set
			classGrades << 0L  // FIX: 集合为空时生成的SQL语句有误，此处添加一个无效的id以保证集合不空
			q = q.where { student.classGrade.id in classGrades }
		}
		// 统计学生缺勤情况
		def result = [:]
		q.list().each {
			def u = it.student
			// [0]学生id，学号，姓名，班级，[4]其他次数，旷课次数，事假次数，病假次数，[8]缺勤总次数，[9]其他时数，旷课时数，事假时数，病假时数，[13]缺勤总时数
			if(!result[u]) result[u] = [u.id, u.no, u.name, u.classGrade.name, 0,0,0,0,0,0,0,0,0,0,0]
			result[u][4 + it.status] += 1   // [4]其他次数，旷课次数，事假次数，病假次数
			result[u][8] += it.status!=AbsenceRecord.STATUS_ATTEND ? 1 : 0  // 缺勤总次数
			
			result[u][9 + it.status] += it.hoursAbsence  // [9]其他时数，旷课时数，事假时数，病假时数
			result[u][13] += it.status!=AbsenceRecord.STATUS_ATTEND ? it.hoursAbsence : 0  // 缺勤总时数
		}
		// 数据排序
		def sort = params.sort!=null ? params.sort.toInteger() : 10 // 默认按旷课时数排序
		def order = params.order ?: 'desc'  // 默认倒序排序
		def sign = order=='desc' ? -1 : 1
		
		def stat = result.collect { it.value }.sort {s1,s2->
			return sign * s1[sort].compareTo(s2[sort])
		}
		// 处理分页
		def offset = params.offset!=null ? params.offset.toInteger() : 0
		def max = params.max!=null ? Math.min(params.max.toInteger(), 20) : 20
		def last = Math.min(offset+max-1, stat.size()-1)
		// 返回结果
		[grade: g, specialty: s, classGrade: c, start: start, end: end, stat: offset<=last ? stat[offset..last] : [], total: stat.size()]
	}
	
	// 按课程统计缺勤情况
	def courses() {
		def g = params.grade!=null ? params.grade.toInteger() : 0  // 年级
		def s = params.specialty!=null ? params.specialty : ''  // 专业
		def c = params.classGrade!=null ? params.classGrade.toInteger() : 0 // 班级
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		// 构造条件查询
		def q = AbsenceRecord.where {}
		//   日期范围
		if(start) q = q.where {report.date>=start}
		if(end) q = q.where {report.date<=end}
		//   年级、专业、班级
		if(g || s || c) {
			def cgs = ClassGrade.where {}
			if(g) cgs = cgs.where {grade==g}
			if(s) cgs = cgs.where {specialty==s}
			if(c) cgs = cgs.where {id==c}
			def classGrades = cgs.list().collect { it.id } as Set
			classGrades << 0L  // FIX: 集合为空时生成的SQL语句有误，此处添加一个无效的id以保证集合不空
			q = q.where { student.classGrade.id in classGrades }
		}
		// 统计课程缺勤情况
		def result = [:]
		q.list().each {
			def u = "${it.report.course}-${it.report.teacher.id}"
			// [0]课程名，教师，[2]其他次数，旷课次数，事假次数，病假次数，[6]缺勤总次数，[7]其他时数，旷课时数，事假时数，病假时数，[11]缺勤总时数
			if(!result[u]) result[u] = [it.report.course, it.report.teacher.realName, 0,0,0,0,0,0,0,0,0,0]
			result[u][2 + it.status] += 1   // [2]其他次数，旷课次数，事假次数，病假次数
			result[u][6] += it.status!=AbsenceRecord.STATUS_ATTEND ? 1 : 0  // 缺勤总次数
			
			result[u][7 + it.status] += it.hoursAbsence  // [7]其他时数，旷课时数，事假时数，病假时数
			result[u][11] += it.status!=AbsenceRecord.STATUS_ATTEND ? it.hoursAbsence : 0  // 缺勤总时数
		}
		// 数据排序
		def sort = params.sort!=null ? params.sort.toInteger() : 8 // 默认按旷课时数排序
		def order = params.order ?: 'desc'  // 默认倒序排序
		def sign = order=='desc' ? -1 : 1
		
		def stat = result.collect { it.value }.sort {s1,s2->
			return sign * s1[sort].compareTo(s2[sort])
		}
		// 处理分页
		def offset = params.offset!=null ? params.offset.toInteger() : 0
		def max = params.max!=null ? Math.min(params.max.toInteger(), 20) : 20
		def last = Math.min(offset+max-1, stat.size()-1)
		// 返回结果
		[grade: g, specialty: s, classGrade: c, start: start, end: end, stat: offset<=last ? stat[offset..last] : [], total: stat.size()]

	}
	
	// 统计老师上报情况，迟报次数，漏报次数
	// 迟报是指超过规定时间（如3天）未上报，但是在随后又上报了
	// 漏报是指超过更长时间（如7天）未上报。
	@Secured(['ROLE_LEADER'])
	def teachers() {
		// 该时间段内所有考勤单
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		def q = Report.where { }
		if(start) { q = q.where { date>=start } }
		if(end) { q = q.where { date<=end } }
		// 统计考勤次数、已确认、未确认、迟报、漏报次数
		def result = [:]
		def day7 = new Date().clearTime() - 7
		q.list().each { report->
			def u = report.timetable.teacher
			if(!result[u]) result[u] = [0,0,0,0,0] // 对应考勤次数、已确认、未确认、迟报、漏报次数
			result[u][0] ++ // 考勤次数
			result[u][1] += report.confirmed ? 1 : 0 // 已确认
			result[u][2] += !report.confirmed ? 1 : 0 // 未确认
			result[u][3] += report.confirmed && report.dateConfirmed - report.date > 3 ? 1 : 0  // 迟报
			result[u][4] += report.date<day7 && !report.confirmed ? 1 : 0  // 漏报
		}
		[stat: result, start: start, end: end]
	}
	
	// 统计辅导员对学生考勤的确认情况
	@Secured(['ROLE_LEADER'])
	def counsellors() {
		// 该时间段内缺勤记录
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		def q = AbsenceRecord.where { }
		if(start) { q = q.where { report.dateCreated>=start } }
		if(end) { q = q.where { report.dateCreated<=end } }
		// 统计审核情况（应审核总数，已审核总数，每个辅导员审核数，迟审3天，迟审7天）
		def total = q.count()   // 应审核总数
		def verified = q.where { verifier!=null }.count()  // 已审核总数
		def result = [:]
		def day7 = new Date().clearTime() - 7
		q.where { verifier!=null }.list().each { record->
			def u = record.verifier
			if(!result[u]) result[u] = [0,0,0] // 对应审核数，迟审3天，迟审7天
			result[u][0] ++  // 审核数
			result[u][1] += record.lastUpdated-record.dateCreated > 3 ? 1 : 0 // 迟审3天
			result[u][2] += record.lastUpdated-record.dateCreated > 7 ? 1 : 0 // 迟审7天
		}
		[stat: result, total: total, verified: verified, start: start, end: end]
	}
	
	// 查询出未上报的老师考勤
	def notConfirmed() {
		
	}

	// 未确认的辅导员考勤信息
	def notVerified() {
		
	}
}
