package kaoqin

import grails.gorm.DetachedCriteria;
import grails.plugins.springsecurity.Secured;

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class ReportController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def springSecurityService
	def reportService

    def index() {
		// 如果已经登录，默认只显示自己的考勤单，否则显示所有考勤单
		if(springSecurityService.isLoggedIn())
			redirect(action: "listMine", params: params)
		else
        	redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 20, 100)
		def q = Report.where {}
		q = defaultOrder(q) // 默认按上课日期逆序、时间逆序、课程名顺序
        [reportInstanceList: q.list(params), reportInstanceTotal: q.count()]
    }
	
	// 列出当前用户的考勤单
	@Secured(['ROLE_USER'])
	def listMine(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def q = Report.where { teacher==springSecurityService.currentUser }
		q = defaultOrder(q) // 默认按上课日期逆序、时间逆序、课程名顺序
		render(view:'list', model: [reportInstanceList: q.list(params), reportInstanceTotal: q.count()])
	}
	
	// 列出今天上课的考勤单
	def listToday(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def today = new Date().clearTime()
		def q = Report.where { date==today }
		q = defaultOrder(q) // 默认按上课日期逆序、时间逆序、课程名顺序
		render(view:'list', model: [reportInstanceList: q.list(params), reportInstanceTotal: q.count()])
	}
	
	// 列出未确认的考勤单
	def listNotConfirmed(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def q = Report.where { confirmed==false }
		q = defaultOrder(q) // 默认按上课日期逆序、时间逆序、课程名顺序
		render(view:'list', model: [reportInstanceList: q.list(params), reportInstanceTotal: q.count()])
	}
	
	// 列出未确认的考勤单，JSON格式
	@Secured(['IS_AUTHENTICATED_ANONYMOUSLY']) // 无需访问权限
	def listNotConfirmedJSON() {
		render dataOfNotConfirmed().encodeAsJSON()
	}
	// 列出未确认的考勤单，XML格式
	@Secured(['IS_AUTHENTICATED_ANONYMOUSLY']) // 无需访问权限
	def listNotConfirmedXML() {
		render dataOfNotConfirmed().encodeAsXML()
	}
	
	private def dataOfNotConfirmed() {
		Report.where { confirmed==false }.list().collect {
			['date':it.date.format('yyyy-MM-dd'), 'time':it.time,
				'timetable':['course':it.timetable.course, 'classes':it.timetable.classes],
				'teacher':['id':it.teacher.id, 'name':it.teacher.realName, 'phone':it.teacher.phone, 'email':it.teacher.email]
			]
		}
	}

	// 默认按上课日期逆序、时间逆序、课程名顺序
	private def defaultOrder(DetachedCriteria<Report> q) {
		if(!params.sort) {
			q = q.sort('date', 'desc').sort('time', 'desc').sort('course')
		}
		return q
	}
	
	// 根据课程表创建默认考勤单
	private Report createReportOfTimetable(Long id) {
		// 根据id取课程表
		def timetable = Timetable.get(id)
		if(timetable==null) {
			flash.message = "请选择您正在讲授的课程"
			redirect(action: "listMine", controller:"timetable")
			return new Report(params)
		}
		// 验证课程表的所有者
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) {
			if(! checkOwner(timetable)) return
		}
		// 课程表必须是未关闭的
		if(timetable.closed) {
			flash.message = "该课程已经结束，无法创建考勤单"
			redirect(action: "show", controller:'timetable', id: timetable.id)
			return new Report(params)
		}
		// 创建考勤单
		return ReportHelper.createReportOf(timetable)
	}

	@Secured(['ROLE_USER', 'ROLE_LEADER'])
    def create(Long id) {
		// 根据课程表创建考勤单
		def reportInstance = createReportOfTimetable(id)
		if(!reportInstance) return
		// 填写内容
		reportInstance.properties = params
		reportInstance.confirmed = false // 初次建立并未确认
		// 在页面中显示
        [reportInstance: reportInstance]
    }

	private boolean checkOwner(Timetable it) {
		if(it?.teacher.id != springSecurityService.currentUser.id) {
			redirect action:'denied', controller:'login'
			return false
		}
		return true
	}

	@Secured(['ROLE_USER', 'ROLE_LEADER'])
    def save() {
		// 根据课程表创建考勤单
		def reportInstance = new Report(params)
		reportInstance.confirmed = false // 初次保存并未确认
		// 保存考勤单
        if (!reportInstance.save(flush:true)) {
            render(view: "create", model: [reportInstance: reportInstance])
            return
        }
		
        flash.message = "考勤单 ${reportInstance.id} 已创建，尚未确认"
		redirect(action: 'show', id: reportInstance.id)
    }

    def show(Long id) {
        def reportInstance = Report.get(id)
        if (!reportInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'report.label', default: 'Report'), id])
            redirect(action: "index")
            return
        }

        [reportInstance: reportInstance]
    }

	@Secured(['ROLE_USER', 'ROLE_LEADER'])
    def edit(Long id) {
        def reportInstance = Report.get(id)
        if (!reportInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'report.label', default: 'Report'), id])
            redirect(action: "index")
            return
        }
		// 验证课程表的所有者
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) {
			if(! checkOwner(reportInstance)) return
		}
		
		// 已经确认的不允许再编辑
		if(reportInstance.confirmed) {
			flash.message = "该考勤单已经确认，不允许修改"
			redirect(action:'show', model: [reportInstance: reportInstance])
		}
		// 验证缺勤记录（人数正确，学生唯一，状态正确，学时正确等）
		def records = ReportHelper.checkContent(reportInstance)

        [reportInstance: reportInstance, records: records]
    }
	
	private boolean checkOwner(Report it) {
		if(it?.teacher.id != springSecurityService.currentUser.id) {
			redirect action:'denied', controller:'login'
			return false
		}
		return true
	}
	
	@Secured(['ROLE_USER', 'ROLE_LEADER'])
    def update(Long id, Long version) {
        def reportInstance = Report.get(id)
        if (!reportInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'report.label', default: 'Report'), id])
            redirect(action: "index")
            return
        }
		// 验证课程表的所有者
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) {
			if(! checkOwner(reportInstance)) return
		}
		// 已经确认的不允许再编辑
		if(reportInstance.confirmed) {
			flash.message = "该考勤单已经确认，不允许修改"
			redirect(action:'show', model: [reportInstance: reportInstance])
		}

        if (version != null) {
            if (reportInstance.version > version) {
                reportInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'report.label', default: 'Report')] as Object[],
                          "Another user has updated this Report while you were editing")
                render(view: "edit", model: [reportInstance: reportInstance])
                return
            }
        }

        reportInstance.properties = params
		reportInstance.confirmed = false // 修改后尚未确认
		
        if (!reportInstance.save(flush:true)) {
			flash.message = "更新遇到问题，请重新核对"
			render(view:'edit', model:[reportInstance: reportInstance])
            return
        }
		
		// 更新完毕，继续修改
        flash.message = "考勤单已更新，但尚未确认"
		redirect(action:'show', id:reportInstance.id)
    }
	
	@Secured(['ROLE_USER', 'ROLE_LEADER'])
	def confirm(Long id) {
		def reportInstance = Report.get(id)
		if (!reportInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'report.label', default: 'Report'), id])
			redirect(action: "index")
			return
		}
		// 验证课程表的所有者
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) {
			if(! checkOwner(reportInstance)) return
		}
		// 已经确认的不允许再确认
		if(reportInstance.confirmed) {
			flash.message = "该考勤单已经确认，不允许修改"
			redirect(action:'show', model: [reportInstance: reportInstance])
			return
		}
		
 		// 验证缺勤记录（人数正确，学生唯一，状态正确，学时正确等）
		def records = ReportHelper.checkContent(reportInstance)
		if(reportInstance.hasErrors()) {
			flash.message = "缺勤记录还存在问题，未完成确认"
			render(view: "edit", model: [reportInstance: reportInstance, records: records])
			return
		}
		
		// 已经确认没有问题，则进行确认
		try {
			reportService.confirmReport(reportInstance)
			flash.message = "考勤单已确认"
			redirect(action: "show", id: reportInstance.id)
		} catch (Exception e) {
			flash.message = "更新考勤单遇到问题，未完成确认：${e}"
			redirect(action:'edit', id: reportInstance.id)
		}
	}

	@Secured(['ROLE_USER', 'ROLE_LEADER'])
    def delete(Long id) {
        def reportInstance = Report.get(id)
        if (!reportInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'report.label', default: 'Report'), id])
            redirect(action: "index")
            return
        }
		// 验证课程表的所有者
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) {
			if(! checkOwner(reportInstance)) return
		}
		// 已经确认的不允许再删除
		if(reportInstance.confirmed) {
			flash.message = "该考勤单已经确认，不允许修改"
			redirect(action:'show', model: [reportInstance: reportInstance])
			return
		}

        try {
            reportInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'report.label', default: 'Report'), id])
            redirect(action: "index")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'report.label', default: 'Report'), id])
            redirect(action: "show", id: id)
        }
    }
}
