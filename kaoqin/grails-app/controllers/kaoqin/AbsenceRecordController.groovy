package kaoqin

import grails.gorm.DetachedCriteria;
import grails.plugins.springsecurity.Secured;

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class AbsenceRecordController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def springSecurityService

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
		def g = params.grade!=null ? params.grade.toInteger() : 0  // 年级
		def s = params.specialty!=null ? params.specialty : ''  // 专业
		def c = params.classGrade!=null ? params.classGrade.toInteger() : 0 // 班级
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
        params.max = Math.min(max ?: 20, 100)
		// 构造条件查询
        def q = AbsenceRecord.where {}
		//   日期范围
		if(start) q = q.where {report.date>=start}
		if(end) q = q.where {report.date<=end}
		//   年级、专业、班级
		if(g || s || c) {
			def cgs = ClassGrade.where { }
			if(g) cgs = cgs.where {grade==g}
			if(s) cgs = cgs.where {specialty==s}
			if(c) cgs = cgs.where {id==c}
			def classGrades = cgs.list().collect { it.id } as Set
			classGrades << 0L  // FIX: 集合为空时生成的SQL语句有误，此处添加一个无效的id以保证集合不空
			q = q.where { student.classGrade.id in classGrades }
		}
		// 排序创建时间逆序
		q = defaultOrder(q)
		// 统计数据
		def stat = statData(q)

		// 返回结果
        [absenceRecordInstanceList: q.list(params), absenceRecordInstanceTotal: q.count(), 
				grade: g, specialty: s, classGrade: c, start: start, end: end, stat: stat]
    }
	
	// 默认的排序是按
	private def defaultOrder(DetachedCriteria<AbsenceRecord> q) {
		if(!params.sort) {
			q = q.order('dateCreated', 'desc') // FIXME: 这里应该按上课时间逆序，因为涉及多表查询，暂时按创建时间逆序排序
		}
		return q
	}
	
	// 统计结果（stat[0]人次数，stat[1]学时数，
	//    [0]未缺勤，[1]旷课，[2]事假，[3]病假，[4]合计，[5]未审核，
	//    如：stat[0][1] 为旷课人次）
	private def statData(q) {
		def stat = [[0,0,0,0,0,0], [0,0,0,0,0,0]]
		def a = q.list()  // all result
		a.each {
			stat[0][it.finalStatus] ++
			stat[1][it.finalStatus] += it.hoursAbsence
			stat[0][5] += it.verifier ? 0 : 1   // 统计未审核的人次数
			stat[1][5] += it.verifier ? 0 : it.hoursAbsence   // 统计未审核的学时数
		}
		stat[0][4] = stat[0][0..3].sum()
		stat[1][4] = stat[1][0..3].sum()
		
		return stat
	}
	
	// 未审核的缺勤记录
	def listNotVerified(Integer max) {
		params.max = Math.min(max ?: 20, 100)
		def q = AbsenceRecord.where {verifier==null}
		// 排序创建时间逆序
		q = defaultOrder(q)
		render(view:'list', model:[absenceRecordInstanceList: q.list(params), absenceRecordInstanceTotal: q.count()])
	}

    def show(Long id) {
        def absenceRecordInstance = AbsenceRecord.get(id)
        if (!absenceRecordInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'absenceRecord.label', default: 'AbsenceRecord'), id])
            redirect(action: "list")
            return
        }

        [absenceRecordInstance: absenceRecordInstance]
    }
	
	// 已经审核过的除审核人意外，不再编辑
	// 检查是否是当前用户审核的
	private boolean isOwner(AbsenceRecord absenceRecordInstance) {
		if(absenceRecordInstance.verifier!=null && absenceRecordInstance.verifier.id != springSecurityService.currentUser.id) {
			flash.message = "该考勤记录已经由其他人审核，您不能修改"
			redirect(action: "show", id: absenceRecordInstance.id)
			return false
		}
		return true
	}

	@Secured(['ROLE_COUNSELLOR', 'ROLE_LEADER']) // FIX30130920: 允许领导修改审核结果
    def edit(Long id) {
        def absenceRecordInstance = AbsenceRecord.get(id)
        if (!absenceRecordInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'absenceRecord.label', default: 'AbsenceRecord'), id])
            redirect(action: "list")
            return
        }
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) { // FIX30130920: 允许领导修改审核结果
			if(! isOwner(absenceRecordInstance)) return
		}

        [absenceRecordInstance: absenceRecordInstance]
    }

	@Secured(['ROLE_COUNSELLOR', 'ROLE_LEADER']) // FIX30130920: 允许领导修改审核结果
    def update(Long id, Long version) {
        def absenceRecordInstance = AbsenceRecord.get(id)
        if (!absenceRecordInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'absenceRecord.label', default: 'AbsenceRecord'), id])
            redirect(action: "list")
            return
        }
		if(! SpringSecurityUtils.ifAnyGranted("ROLE_LEADER")) { // FIX30130920: 允许领导修改审核结果
			if(! isOwner(absenceRecordInstance)) return
		}

        if (version != null) {
            if (absenceRecordInstance.version > version) {
                absenceRecordInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'absenceRecord.label', default: 'AbsenceRecord')] as Object[],
                          "Another user has updated this AbsenceRecord while you were editing")
                render(view: "edit", model: [absenceRecordInstance: absenceRecordInstance])
                return
            }
        }

        absenceRecordInstance.properties = params
		if(absenceRecordInstance.verifier==null) {
			absenceRecordInstance.verifier = springSecurityService.currentUser // 审核人是当前用户
		}
		
		if(! absenceRecordInstance.remarks) {
			if(absenceRecordInstance.finalStatus == absenceRecordInstance.status) {
				absenceRecordInstance.remarks = ['取消','旷课','事假','病假'][absenceRecordInstance.status]
			} else {
				def old = ['取消','旷课','事假','病假'][absenceRecordInstance.status]
				def checked = ['取消','旷课','事假','病假'][absenceRecordInstance.finalStatus]
				absenceRecordInstance.remarks = "${old}->${checked}"
			}
		} else {
			if(absenceRecordInstance.remarks.indexOf(['取消','旷课','事假','病假'][absenceRecordInstance.finalStatus])==-1) {
				absenceRecordInstance.errors.rejectValue("remarks", "absenceRecord.remarks.error")
			}
		}

        if (absenceRecordInstance.hasErrors() || !absenceRecordInstance.save(flush: true)) {
        	render(view: "edit", model: [absenceRecordInstance: absenceRecordInstance])
        	return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'absenceRecord.label', default: 'AbsenceRecord'), absenceRecordInstance.id])
        redirect(action: "show", id: absenceRecordInstance.id)
    }
	
	// 快速审核
	@Secured(['ROLE_COUNSELLOR'])
	def approve(Long id) {
		def absenceRecordInstance = AbsenceRecord.get(id)
		if (!absenceRecordInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'absenceRecord.label', default: 'AbsenceRecord'), id])
			redirect(action: "list")
			return
		}
        if(! isOwner(absenceRecordInstance)) return

		// 审核通过
		absenceRecordInstance.verifier = springSecurityService.currentUser // 当前用户（辅导员）
		absenceRecordInstance.finalStatus = absenceRecordInstance.status   // 与提交的考勤相同
		absenceRecordInstance.remarks = ['取消','旷课','事假','病假'][absenceRecordInstance.status]

		if (!absenceRecordInstance.save(flush: true)) {
			flash.message = "缺勤记录 ${absenceRecordInstance.id} 审核遇到问题，请仔细核对"
			render(view: "edit", model: [absenceRecordInstance: absenceRecordInstance])
			return
		}

		flash.message = "缺勤记录 ${absenceRecordInstance.id} 已审核"
		redirect(action: "list")
	}
}
