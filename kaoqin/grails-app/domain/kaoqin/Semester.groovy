package kaoqin

import java.util.Date;

// 学期
class Semester {
	String name
	String shortName
	Date dateStart // 开课日期
	Date dateEnd   // 结束日期
	
	static hasMany = [timetables: Timetable]

    static constraints = {
		shortName blank: false, unique: true, maxSize: 12
		name blank: false, unique: true, maxSize: 20
		dateStart nullable: false, validator: { val, obj-> val < obj.dateEnd }
		dateEnd nullable: false, validator: { val, obj-> val > obj.dateStart }
    }
	
	static mapping = {
		cache true
		sort dateStart:'desc'
		name index:'name_idx'
		shortName index:'short_name_idx'
		dateStart index:'date_start_idx'
		dateEnd index:'date_end_idx'
	}
	
	String toString() {
		name
	}
	
	// 取当前学期
	public static Semester current(Date date = new Date()) {
		return Semester.whereAny { dateStart<=date && dateEnd>=date }.find()
	}
	
	// 下一个学期
	public static Semester next(Date date = new Date()) {
		return Semester.whereAny { dateStart>date }.order('dateStart').find()
	}

	// 返回该日期在本学期内的周数
	int weekOf(Date d) {
		int w = (d - dateStart + dateStart.day - 1) / 7 + 1
		return w
	}
	
}
