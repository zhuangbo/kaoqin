package kaoqin

class MyKaoqinTagLib {
	
	static namespace = "kaoqin"
	
	def semester = {
		def s = Semester.current() ?: Semester.next()
		out << s?.name
	}

}
