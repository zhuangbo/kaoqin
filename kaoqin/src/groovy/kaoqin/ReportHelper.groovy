package kaoqin

class ReportHelper {
	
	// 根据课程表创建空白考勤单
	static Report createReportOf(Timetable timetable) {
		// 创建考勤单
		return new Report(
				timetable: timetable,
				course: timetable.course,
				date: timetable.dateOfLastLesson(),
				time: timetable.timeOfLesson(),
				hours: timetable.classHours,
				classes: timetable.classes,
				classroom: timetable.classroom,
				teacher: timetable.teacher,
				confirmed: false,
				dateConfirmed: null
			)
	}
	
	// 验证考勤报告中的考勤记录，返回验证结果
	// 例如验证“张三旷课2节，李四[4]事假1，王五[23]病假2”得到结果：
	// [['张三', '旷课', '2节', [张三, 张三]], ['李四[4]', '事假', '1', [李四]], ['王五[23]', '病假', '2', []]]
	// 表明：找到张三两人，尾号为4的李四一个，尾号23的王五没有找到
	static def validateContent(String content) {
		// 分解考勤记录
		if(!content.trim()) return [] // 结果为空
		String text = content
		text = text.replace(',','，'                 // 替换逗号
			).replace('【', '[').replace('】', ']'   // 替换方括号
			).replace(' ', ''                        // 消除空格
			).replace('-', ''                        // 消除-号
			).replace('旷课', '-旷课-'               // 分解各种状态
			).replace('事假', '-事假-'
			).replace('病假', '-病假-')

		if(!text.trim()) return [] // 结果为空
		def a = text.split('，')
		if(a.length==0) return [] // 结果为空
		def result = []
		a.each { it->
			def s = it.split('-') as List
			if(s.size()==2) s << '-' // 省略学时数，用'-'临时代替
			else if(s.size()==3) {
				s[2] = s[2].replaceAll("[^0-9].*\$","")
			}
			result << s
		}
//		println "分解考勤记录：${text} 得："
//		println a
//		println result
		// 验证学生身份，补充学号，无法区分的，列出所有学号和班级供选择
		def names = result.collect { it[0].replaceAll("[\\[\\]0-9]","") }
		def nos = result.collect { it[0].replaceAll("[^0-9]","") }
		def stus = Student.where { enabled==true && name in names }.findAll() as Set
		(0..(result.size()-1)).each {i->
			result[i] << ( stus.findAll { (it.name==names[i]) && (it.no==~".*${nos[i]}\$") } )
		}
		result
	}

	// 验证考勤报告中的考勤记录，返回验证结果
	// 例如验证“张三旷课2节，李四[4]事假1，王五[23]病假2”得到结果：
	// [['张三', '旷课', '2节', [张三, 张三]], ['李四[4]', '事假', '1', [李四]], ['王五[23]', '病假', '2', []]]
	// 表明：找到张三两人，尾号为4的李四一个，尾号23的王五没有找到
	static def validateContent(Report report) {
		def result = validateContent(report.content)
		result.each {
			if(it.size()==4 && it[2]=='-') it[2] = report.hours.toString()
		}
		return result
	}

	static def checkContent(Report reportInstance) {
		// 分解缺勤记录
		def records = ReportHelper.validateContent(reportInstance)
		// 验证缺勤记录（人数正确，学生唯一，状态正确，学时正确等）
		// 缺勤人数与考勤情况不符
		if(reportInstance.absence != records.size()) {
			reportInstance.errors.rejectValue("content", "report.content.error.absence")
		}
		// 学生存在重名，不能唯一确定
		if(records.any {it[-1].size() > 1}) {
			reportInstance.errors.rejectValue("content", "report.content.error.multi.stu")
		}
		// 学生姓名错误，找不到
		if(records.any {it[-1].size() == 0}) {
			reportInstance.errors.rejectValue("content", "report.content.error.no.stu")
		}
		// 考勤记录中的学生不能重复
		if((records.collect { it[-1] } as Set).size() != records.size()) {
			reportInstance.errors.rejectValue("content", "report.content.error.same.stu")
		}
		// 考勤状态有误，只能填写旷课、事假或病假
		if(records.any {it.size() == 2}) {
			reportInstance.errors.rejectValue("content", "report.content.error.status")
		}
		// 缺勤学时数有误，至少为1，最多不超过本次课总学时数
		if(records.any { !(it[2]==~"^[0-9]+.*") || !(it[2].replaceAll("[^0-9]*", "").toInteger() in (1..reportInstance.hours)) }) {
			reportInstance.errors.rejectValue("content", "report.content.error.hours")
		}
		return records
	}

}
