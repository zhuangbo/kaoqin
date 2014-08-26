package kaoqin

import org.springframework.dao.DataIntegrityViolationException

import grails.plugins.springsecurity.Secured;

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class ClassGradeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 20, 100)
        [classGradeInstanceList: ClassGrade.list(params), classGradeInstanceTotal: ClassGrade.count()]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
    def create() {
        [classGradeInstance: new ClassGrade(params)]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
    def save() {
        def classGradeInstance = new ClassGrade(params)
        if (!classGradeInstance.save(flush: true)) {
            render(view: "create", model: [classGradeInstance: classGradeInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), classGradeInstance.id])
        redirect(action: "show", id: classGradeInstance.id)
    }

    def show(Long id) {
        def classGradeInstance = ClassGrade.get(id)
        if (!classGradeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), id])
            redirect(action: "list")
            return
        }

        [classGradeInstance: classGradeInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
    def edit(Long id) {
        def classGradeInstance = ClassGrade.get(id)
        if (!classGradeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), id])
            redirect(action: "list")
            return
        }

        [classGradeInstance: classGradeInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
    def update(Long id, Long version) {
        def classGradeInstance = ClassGrade.get(id)
        if (!classGradeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (classGradeInstance.version > version) {
                classGradeInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'classGrade.label', default: 'ClassGrade')] as Object[],
                          "Another user has updated this ClassGrade while you were editing")
                render(view: "edit", model: [classGradeInstance: classGradeInstance])
                return
            }
        }

        classGradeInstance.properties = params

        if (!classGradeInstance.save(flush: true)) {
            render(view: "edit", model: [classGradeInstance: classGradeInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), classGradeInstance.id])
        redirect(action: "show", id: classGradeInstance.id)
    }

	@Secured(['ROLE_ADMIN']) // 只有管理员能够删除
    def delete(Long id) {
        def classGradeInstance = ClassGrade.get(id)
        if (!classGradeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), id])
            redirect(action: "list")
            return
        }

        try {
            classGradeInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'classGrade.label', default: 'ClassGrade'), id])
            redirect(action: "show", id: id)
        }
    }
	
	// 导入本班学生
	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
	def imports(Long id) {
		println id
		[classGradeInstance : ClassGrade.get(id)]
	}
	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
	def saveImports(Long id) {
		def classGrade = ClassGrade.get(id)
		// 取学生列表（学号、姓名）
		def text = params.text
		// 逐行取出学生信息并保存
		int n = 0
		text.eachLine {
			def t = it.split()
			if(t.length==2) {
				def s = new Student(no: t[0], name: t[1], classGrade: classGrade)
				if(s.save())
					++n
				else
					classGrade.errors.reject("classGrade.students.imports.error", [it] as Object[], "${it} 导入错误（请勿重复导入）")
			} else if(t.length!=0) {
				classGrade.errors.reject("classGrade.students.imports.format.error", [it] as Object[], "${it} 格式错误")
			}
		}
		// 返回结果信息
		flash.message = "正确导入学生 ${n} 人"
		render view:'imports', model:[classGradeInstance: classGrade]
	}

	// 毕业了，清除本班所有学生在读标志
	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
	def disableStudents(Long id) {
		int n = 0
		int ex = 0
		ClassGrade.get(id)?.students.each {
			try {
				it.enabled = false  // 注销
				if(it.save(flush:true)) {
					++n
				} else {
					++ex
				}
			} catch (Throwable e) {
				++ex
			}
		}
		flash.message = "成功注销 ${n} 名学生，失败 ${ex} 个"
        redirect(action: "show", id: id)
	}
	// 撤销注销操作
	@Secured(['ROLE_ADMIN', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
	def enableStudents(Long id) {
		int n = 0
		int ex = 0
		ClassGrade.get(id)?.students.each {
			try {
				it.enabled = true  // 撤销注销
				if(it.save(flush:true)) {
					++n
				} else {
					++ex
				}
			} catch (Throwable e) {
				++ex
			}
		}
		flash.message = "成功注销 ${n} 名学生，失败 ${ex} 个"
        redirect(action: "show", id: id)
	}
}
