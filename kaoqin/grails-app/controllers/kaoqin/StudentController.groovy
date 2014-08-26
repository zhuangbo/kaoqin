package kaoqin

import grails.plugins.springsecurity.Secured;

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class StudentController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 50, 100)
        [studentInstanceList: Student.list(params), studentInstanceTotal: Student.count()]
    }
	
	def searchJSON(String term) {
		// 按姓名查询
		def list = Student.where { enabled==true && name =~ "${term}%" }.sort('name').list()
		// 统计重名
		def counter = [:]
		list.each {
			if(! counter.containsKey(it.name)) counter[it.name] = 0
			counter[it.name]++
		}
		def result = list.collect {
			// 重名学生自动提示学号
			counter[it.name]==1 ? "${it.name} - ${it.classGrade.name}" : "${it.name}[${it.no}] - ${it.classGrade.name}"
		}
		// 返回 JSON 格式的结果
		render result.encodeAsJSON()
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def create() {
        [studentInstance: new Student(params)]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def save() {
        def studentInstance = new Student(params)
        if (!studentInstance.save(flush: true)) {
            render(view: "create", model: [studentInstance: studentInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'student.label', default: 'Student'), studentInstance.id])
        redirect(action: "show", id: studentInstance.id)
    }

    def show(Long id) {
        def studentInstance = Student.get(id)
        if (!studentInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "list")
            return
        }

        [studentInstance: studentInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def edit(Long id) {
        def studentInstance = Student.get(id)
        if (!studentInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "list")
            return
        }

        [studentInstance: studentInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def update(Long id, Long version) {
        def studentInstance = Student.get(id)
        if (!studentInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (studentInstance.version > version) {
                studentInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'student.label', default: 'Student')] as Object[],
                          "Another user has updated this Student while you were editing")
                render(view: "edit", model: [studentInstance: studentInstance])
                return
            }
        }

        studentInstance.properties = params

        if (!studentInstance.save(flush: true)) {
            render(view: "edit", model: [studentInstance: studentInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'student.label', default: 'Student'), studentInstance.id])
        redirect(action: "show", id: studentInstance.id)
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def delete(Long id) {
        def studentInstance = Student.get(id)
        if (!studentInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "list")
            return
        }

        try {
            studentInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "show", id: id)
        }
    }
	
	// 查看缺勤记录
	def absenceRecords(Long id, Integer max) {
        def studentInstance = Student.get(id)
        if (!studentInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'student.label', default: 'Student'), id])
            redirect(action: "list")
            return
        }
		params.max = Math.min(max ?: 10, 100)
		// 构造条件查询
		def q = AbsenceRecord.where { student==studentInstance }
		//   日期范围
		def start = params.start  // 开始日期
		def end = params.end  // 结束日期
		if(start) q = q.where {report.date>=start}
		if(end) q = q.where {report.date<=end}
		// 统计结果（stat[0]次数，stat[1]学时数，stat[2]未审核次，
		//         对前两者还有：[0]未缺勤，[1]旷课，[2]事假，[3]病假，[4]合计，如：stat[0][1] 为旷课次数）
		def stat = [[0,0,0,0,0], [0,0,0,0,0], 0]
		q.list().each {
			stat[0][it.finalStatus] ++
			stat[1][it.finalStatus] += it.hoursAbsence
			stat[2] += it.verifier ? 0 : 1   // 统计未审核的数量
		}
		stat[0][4] = stat[0][0..3].sum()
		stat[1][4] = stat[1][0..3].sum()

		// 返回结果
        [studentInstance: studentInstance, absenceRecordInstanceList: q.order('lastUpdated', 'desc').list(params), absenceRecordInstanceTotal: q.count(), 
				start: start, end: end, stat: stat]
	}
}
