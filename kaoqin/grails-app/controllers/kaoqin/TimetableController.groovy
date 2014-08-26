package kaoqin

import grails.gorm.DetachedCriteria;
import grails.plugins.springsecurity.Secured;
import grails.plugins.springsecurity.SpringSecurityService;

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class TimetableController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def springSecurityService

    def index() {
		if(springSecurityService.loggedIn) {
			redirect(action: "listMine", params: params) // 登录后显示自己的课程表
		} else {
        	redirect(action: "list", params: params)
		}
    }
	
	// 全部（可以筛选）
    def list(Integer max) {
        params.max = Math.min(max ?: 20, 100)
		def t = params.teacher!=null ? params.teacher.toInteger() : 0
		def s = params.semester!=null ? params.semester.toInteger() : 0
		def c = params.closed!=null ? params.closed : false
		def q = Timetable.where {closed==c}
		if(t) q = q.where {teacher.id==t}
		if(s) q = q.where {semester.id==s}
		q = defaultOrder(q) // 默认情况下的排序
		
        [timetableInstanceList: q.list(params), timetableInstanceTotal: q.count(), teacher: t, semester: s, closed: c]
    }
	
	// 默认情况下的排序，按学期逆序、星期顺序、节次顺序、名称顺序
	private def defaultOrder(DetachedCriteria<Timetable> q) {
		if(!params.sort) {
			q = q.sort('semester', 'desc').sort('weekday').sort('classHourStart').sort('course')
		}
		return q
	}

	
	// 我的课表（当前用户，未关闭的）
	@Secured(['ROLE_USER'])
	def listMine(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def me = springSecurityService.currentUser
		def q = Timetable.where { teacher==me && closed==false }
		q = defaultOrder(q) // 默认情况下的排序
		render(view:'list', model:[timetableInstanceList: q.list(params), timetableInstanceTotal: q.count()])
	}
	
	// 我的课表（当前用户，未关闭的，今天的）
	@Secured(['ROLE_USER'])
	def listMyToday(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def me = springSecurityService.currentUser
		def today = new Date().clearTime()
		def q = Timetable.where { teacher==me && closed==false }
		q = defaultOrder(q) // 默认情况下的排序
		q = q.findAll { it.haveLesson() }
		render(view:'list', model:[timetableInstanceList: q, timetableInstanceTotal: q.size()]) // 无须分页
	}

	// 过去的（当前用户，已关闭的）
	@Secured(['ROLE_USER'])
	def listMyClosed(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def me = springSecurityService.currentUser
		def q = Timetable.where { teacher==me && closed==true }
		q = defaultOrder(q) // 默认情况下的排序
		render(view:'list', model:[timetableInstanceList: q.list(params), timetableInstanceTotal: q.count()])
	}

	@Secured(['ROLE_USER'])
    def create() {
		def timetableInstance = new Timetable(params)
		timetableInstance.semester = Semester.current() ?: Semester.next()  // 默认为当前学期
		timetableInstance.teacher = springSecurityService.currentUser  // 教师为当前用户
        [timetableInstance: timetableInstance]
    }

	@Secured(['ROLE_USER'])
    def save() {
        def timetableInstance = new Timetable(params)
		timetableInstance.semester = Semester.current() ?: Semester.next()  // 默认为当前学期
		timetableInstance.teacher = springSecurityService.currentUser  // 教师为当前用户
        if (!timetableInstance.save(flush: true)) {
            render(view: "create", model: [timetableInstance: timetableInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'timetable.label', default: 'Timetable'), timetableInstance.id])
        redirect(action: "show", id: timetableInstance.id)
    }

    def show(Long id) {
        def timetableInstance = Timetable.get(id)
        if (!timetableInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
            redirect(action: "list")
            return
        }

        [timetableInstance: timetableInstance]
    }

	@Secured(['ROLE_USER'])
    def edit(Long id) {
        def timetableInstance = Timetable.get(id)
        if (!timetableInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
            redirect(action: "list")
            return
        }
		
		if(! checkOwner(timetableInstance)) return

        [timetableInstance: timetableInstance]
    }
	
	private boolean checkOwner(Timetable it) {
		if(it?.teacher.id != springSecurityService.currentUser.id) {
			redirect action:'denied', controller:'login'
			return false
		}
		return true
	}

	@Secured(['ROLE_USER'])
    def update(Long id, Long version) {
        def timetableInstance = Timetable.get(id)
        if (!timetableInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
            redirect(action: "list")
            return
        }
		
		if(! checkOwner(timetableInstance)) return
		
        if (version != null) {
            if (timetableInstance.version > version) {
                timetableInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'timetable.label', default: 'Timetable')] as Object[],
                          "Another user has updated this Timetable while you were editing")
                render(view: "edit", model: [timetableInstance: timetableInstance])
                return
            }
        }

        timetableInstance.properties = params

        if (!timetableInstance.save(flush: true)) {
            render(view: "edit", model: [timetableInstance: timetableInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'timetable.label', default: 'Timetable'), timetableInstance.id])
        redirect(action: "show", id: timetableInstance.id)
    }
	
	@Secured(['ROLE_USER', 'ROLE_LEADER'])
	def closeIt(Long id) {
		closeTimetable(id, true)
	}
	
	private def closeTimetable(Long id, boolean closed=true) {
		def timetableInstance = Timetable.get(id)
		if (!timetableInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
			redirect(action: "list")
			return
		}
		
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) {
			if(! checkOwner(timetableInstance)) return
		}
		
		// 关闭/打开课程表
		timetableInstance.closed = closed

		if (!timetableInstance.save(flush: true)) {
			render(view: "edit", model: [timetableInstance: timetableInstance])
			return
		}

		flash.message = message(code: 'default.updated.message', args: [message(code: 'timetable.label', default: 'Timetable'), timetableInstance.id])
		redirect(action: "show", id: timetableInstance.id)
	}
	
	@Secured(['ROLE_USER', 'ROLE_LEADER'])
	def openIt(Long id) {
		closeTimetable(id, false)
	}

	@Secured(['ROLE_USER'])
    def delete(Long id) {
        def timetableInstance = Timetable.get(id)
        if (!timetableInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
            redirect(action: "list")
            return
        }
		
		if(! checkOwner(timetableInstance)) return
		
        try {
            timetableInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'timetable.label', default: 'Timetable'), id])
            redirect(action: "show", id: id)
        }
    }
	
}
