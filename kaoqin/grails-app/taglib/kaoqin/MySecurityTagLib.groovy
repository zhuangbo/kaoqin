package kaoqin

class MySecurityTagLib {
	
	static namespace = "mysec"
	
	def springSecurityService
	
	def realName = {
		if(springSecurityService.loggedIn) {
			User user = User.read(springSecurityService.principal.id)
			if(user) {
				out << user.realName;
			}
		} else {
			out << "未登录"
		}
	}
	
	def userid = {
		if(springSecurityService.loggedIn)
			out << springSecurityService.principal?.id
	}

	/**
	 * 判断当前用户是否是拥有某个对象
	 *   timetable  课表
	 *   ... 其他对象，可以继续扩展
	 */
	def ifOwner = { attrs, body ->
		if(springSecurityService.loggedIn) {
			// timetable
			if(attrs.timetable) {
				def t = attrs.timetable as Timetable
				if(t.teacher.id == springSecurityService.currentUser.id) {
					out << body()
					return
				}
			}
			// report
			if(attrs.report) {
				def r = attrs.report as Report
				if(r.teacher.id == springSecurityService.currentUser.id) {
					out << body()
					return
				}
			}
		}
	}
	
	def ifNotOwner = { attrs, body ->
		if(springSecurityService.loggedIn) {
			// timetable
			if(attrs.timetable) {
				def t = attrs.timetable as Timetable
				if(t.teacher.id != springSecurityService.currentUser.id) {
					out << body()
					return
				}
			}
			// report
			if(attrs.report) {
				def r = attrs.report as Report
				if(r.teacher.id != springSecurityService.currentUser.id) {
					out << body()
					return
				}
			}
		} else {
			out << body()
			return
		}
	}
}
