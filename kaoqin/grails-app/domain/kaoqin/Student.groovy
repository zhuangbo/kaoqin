package kaoqin

// 学生
class Student {
	String no // 学号
	String name // 姓名
	ClassGrade classGrade // 班级
	boolean enabled = true  // 在校
	
	static belongsTo = [classGrade: ClassGrade]

	static constraints = {
		no blank: false, unique: true, maxSize: 20
		name blank: false, maxSize: 20
		classGrade nullable: false
		enabled nullable: false
	}
	
	static mapping = {
		no index:'no_idx'
		name index:'name_idx'
		enabled index:'enabled_idx'
		
		classGrade lazy: false
	}
	
	String toString() {
		name
	}
}
