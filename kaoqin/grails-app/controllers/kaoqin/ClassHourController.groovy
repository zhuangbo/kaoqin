package kaoqin

import grails.plugins.springsecurity.Secured;

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class ClassHourController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 20, 100)
        [classHourInstanceList: ClassHour.list(params), classHourInstanceTotal: ClassHour.count()]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def create() {
        [classHourInstance: new ClassHour(params)]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def save() {
        def classHourInstance = new ClassHour(params)
        if (!classHourInstance.save(flush: true)) {
            render(view: "create", model: [classHourInstance: classHourInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'classHour.label', default: 'ClassHour'), classHourInstance.id])
        redirect(action: "show", id: classHourInstance.id)
    }

    def show(Long id) {
        def classHourInstance = ClassHour.get(id)
        if (!classHourInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classHour.label', default: 'ClassHour'), id])
            redirect(action: "list")
            return
        }

        [classHourInstance: classHourInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def edit(Long id) {
        def classHourInstance = ClassHour.get(id)
        if (!classHourInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classHour.label', default: 'ClassHour'), id])
            redirect(action: "list")
            return
        }

        [classHourInstance: classHourInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
    def update(Long id, Long version) {
        def classHourInstance = ClassHour.get(id)
        if (!classHourInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classHour.label', default: 'ClassHour'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (classHourInstance.version > version) {
                classHourInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'classHour.label', default: 'ClassHour')] as Object[],
                          "Another user has updated this ClassHour while you were editing")
                render(view: "edit", model: [classHourInstance: classHourInstance])
                return
            }
        }

        classHourInstance.properties = params

        if (!classHourInstance.save(flush: true)) {
            render(view: "edit", model: [classHourInstance: classHourInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'classHour.label', default: 'ClassHour'), classHourInstance.id])
        redirect(action: "show", id: classHourInstance.id)
    }

	@Secured(['ROLE_ADMIN'])
    def delete(Long id) {
        def classHourInstance = ClassHour.get(id)
        if (!classHourInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'classHour.label', default: 'ClassHour'), id])
            redirect(action: "list")
            return
        }

        try {
            classHourInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'classHour.label', default: 'ClassHour'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'classHour.label', default: 'ClassHour'), id])
            redirect(action: "show", id: id)
        }
    }
}
