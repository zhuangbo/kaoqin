package kaoqin

// 考勤单
class Report implements Comparable<Report> {
	Timetable timetable // 课程表
	String course   // 课程名称（自动填写）
	Date date       // 上课日期（默认为上次课日期）
	String time     // 上课时间（自动填写上课时间）
	int hours       // 学时数（自动填写）
	String classes  // 上课班级（自动填写）
	String classroom  // 上课地点（自动填写）
	int absence    // 缺课人数
	String content = ""  // 考勤情况（手动填写，“姓名[学号]旷课事假病假2节”，...
	                // 学号为区分重名学生可填写最后几位，也可不填）
	User teacher    // 任课教师
	boolean confirmed // 已确认（尚未确认的考勤单表明该考勤而未考勤）
	Date dateConfirmed // 确认时间
	
	Date dateCreated
	Date lastUpdated
	
	String toString() {
		"${course} ${teacher.realName} ${date.format('M-d')} ${time}"
	}
	
	static hasMany = [absenceRecords: AbsenceRecord]

    static constraints = {
		course nullable:false, blank:false
		date nullable:false
		time nullable:false, blank:false, unique:['timetable', 'date']
		hours nullable:false, min:1, max:12
		classes nullable:false, blank:false
		classroom nullable:false, blank:false
		absence nullable:false, min:0, max:100
		content nullable:false, blank:true
		teacher nullable:false
		timetable nullable:false
		confirmed nullable:false
		dateConfirmed nullable:true
		dateCreated()
		lastUpdated()
    }
	
	static mapping = {
		sort date:'desc', time:'desc', course:'asc'
		
		date index:'date_idx'
		time index:'time_idx'
		course index:'course_idx'
		confirmed index:'confirmed_idx'
		dateConfirmed index:'date_confirmed_idx'
	}

	@Override
	public int compareTo(Report o) {
		// 默认按上课日期逆序、时间逆序、课程名顺序
		if(o==null) return 1;
		- date.compareTo(o.date) ?: - time.compareTo(o.time) ?: course.compareTo(o.course)
	}
}
