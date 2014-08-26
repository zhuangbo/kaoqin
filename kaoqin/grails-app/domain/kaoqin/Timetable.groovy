package kaoqin

import java.util.Date;
import java.util.Set;

// 课程表
class Timetable {
	// 教学任务
	Semester semester // 学期（默认为当前学期）
	User teacher // 教师（默认为当前用户）
	String course // 课程
	// 教学安排
	String timetable // 上课时间表（格式如：每周二/8-10节；全周二/1-2节；单周二/3-4节；双周二/3-4节；1-12周二/6-7节；3,6,9周二/1-2节；3-6,9,11-13周二/3-4节）
	String classroom // 教室
	String classes // 上课班级
	// 时间安排
	String frequency // 上课频率（每，单，双，其他如：3-6,9,11-13等）
	int weekday // 星期（日、一至六分别为0、1-6）
	int classHourStart  // 开始节次（默认第1小节，1-12小节）
	int classHourEnd  // 结束节次
	int classHours // 学时数
	
	// 是否关闭
	boolean closed // 是否关闭（学期结束自动关闭）
	
	// 选课学生
	
	// 考勤单
	SortedSet<Report> reports
	static hasMany = [reports: Report]

	static constraints = {
		course nullable: false, blank:false, maxSize: 50
		timetable nullable: false, blank:false, maxSize: 50
		classroom blank: false, maxSize: 20
		classes blank: false, maxSize: 50
		teacher nullable: false
		semester nullable: false
		
		frequency nullable: false, blank:false, maxSize: 20
		weekday nullable:false, min: 0, max: 6
		classHourStart  nullable:false, min:1, max:12
		classHourEnd  nullable:false, min:1, max:12
		classHours  nullable:false, min:1, max:12
	}
	
	static mapping = {
		course index:'course_idx'
		sort semester:'desc', weekday:'asc', classHourStart:'asc', course:'asc'
		
		semester lazy: false
		
		reports sort: 'date', order: 'desc'
	}
	
	void setTimetable(String timetable) {
		this.timetable = timetable
		splitTimetable()
	}

	def beforeInsert() {
		splitTimetable()
		
	}

	def beforeUpdate() {
		if (isDirty('timetable')) {
			splitTimetable()
		}
	}

	// 上次上课时间
	Date dateOfLastLesson(Date before = new Date()) {
		(before..semester.dateStart).find { haveLesson(it) }?.clearTime()
	}
	
	// 下次上课时间
	Date dateOfNextLesson(Date after = new Date()) {
		((after+1)..semester.dateEnd).find { haveLesson(it) }?.clearTime()
	}
	
	// 上课时间
	String timeOfLesson() {
		def start = ClassHour[classHourStart]?.timeStart
		def end = ClassHour[classHourEnd]?.timeEnd
		"${start}-${end}"
	}
	
	private void splitTimetable() {
		def t = timetable.split("[周/节]")
		frequency = t[0].replace('，', ',') // 周频率
		weekday = "日一二三四五六".indexOf(t[1]) // 星期
		if(weekday==-1) weekday = "0123456".indexOf(t[1]) // FIX: 周3 等
		int[] cl = t[2].split("-")*.toInteger() // 节次
		classHourStart = cl[0]
		classHourEnd = cl[1]
		classHours = classHourEnd - classHourStart + 1
	}

	// 判断指定日期是否上课
	boolean haveLesson(Date d = new Date()) {
		// 若 d 时间在学期时间范围之外，则不上课
		if(d<semester.dateStart || d>semester.dateEnd) return false
		// 分析课表
		if(frequency==null) splitTimetable()
		// 星期不对，则不上课
		if(d.day != weekday) return false
		// 若星期正确，根据周次分情况判断
		if(frequency=="全"|| frequency=="每") { // 若全周/每周上课，则上课
			return true
		} else if(frequency=="单") { // 单周上课
			return semester.weekOf(d)%2==1
		} else if(frequency=="双") { // 单周上课
			return semester.weekOf(d)%2==0
		} else { // 指定周上课
			def wk = semester.weekOf(d)
			return frequency.split(",").any {
				int[] w = it.split("-")*.toInteger()
				wk>=w[0] && wk<=w[-1]
			}
		}
	}
	
	String toString() {
		"${course}（${timetable}/${classroom}/${classes}）"
	}

}
