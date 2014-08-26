package kaoqin

// 班级
class ClassGrade {
	String specialty // 专业
	int grade // 年级
	int classNo // 班
	String name // 名称
	User advisor // 班主任
	
	static hasMany = [students: Student]

	static constraints = {
		name nullable: false, blank: false, unique: true, maxSize: 20
		specialty nullable: false, blank: false, maxSize: 50
		grade nullable: false, min: 2010, max: 2020
		classNo nullable: false, min: 1, max: 20
		advisor nullable: false
	}
	
	String toString() {
		name
	}
}
