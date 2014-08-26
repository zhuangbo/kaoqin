package kaoqin

import java.awt.SplashScreen;

import grails.plugins.springsecurity.Secured;
import grails.plugins.springsecurity.SpringSecurityService;

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class UserController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST", doResetPassword: "POST", doChangeContect:"POST"]
	
	def springSecurityService
	
    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 50, 100)
        [userInstanceList: User.list(params), userInstanceTotal: User.count()]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
    def create() {
        [userInstance: new User(params)]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
    def save() {
        def userInstance = new User(params)
        if (!userInstance.save(flush: true)) {
            render(view: "create", model: [userInstance: userInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])
        redirect(action: "show", id: userInstance.id)
    }

    def show(Long id) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        [userInstance: userInstance]
    }
	
	def me() {
		redirect(action:'show', id:springSecurityService.currentUser.id)
	}
	
	// 重置密码
	def changePassword() { }
	def doChangePassword(ChangePasswordCommand changePasswordCommand) {
		if(changePasswordCommand.hasErrors()) {
			render(view:'changePassword', model:[changePasswordCommand:changePasswordCommand])
			return
		}
		// 修改密码
		def user = springSecurityService.currentUser
		user.password = changePasswordCommand.newPassword
		if(!user.save(flush:true)) {
			flash.message = "修改密码遇到错误"
			render(view:'changePassword', model:[changePasswordCommand:changePasswordCommand])
			return
		}
		flash.message = "修改密码成功"
		redirect action:'show', id:user.id
	}
	
	// 修改联系方式（手机号码，邮件地址）
	def changeContect() {
		def user = springSecurityService.currentUser
		[userInstance: user]
	}
	def doChangeContect() {
		def user = springSecurityService.currentUser
		user.phone = params.phone ?: user.phone
		user.email = params.email ?: user.email
		if(! user.save(flush:true)) {
			flash.message = "修改联系方式遇到错误"
			render view:'changeContect', model:[userInstance: user]
			return
		}
		flash.message = "修改联系方式成功"
		redirect action:'show', id:user.id
	}
	
	// 批量更新手机号码和邮件地址
	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def editContects() {
	}
	
	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def updateContects() {
		def text = params.text
		if(!text) {
			flash.message = "请输联系方式，允许多行，可省略手机号码或邮箱，每行必须符合格式：教师号&lt;TAB&gt;手机&lt;TAB&gt;邮箱"
			render(view:'editContects', model:[text: text])
			return
		}
		// 格式：<username><TAB>[<phone>]<TAB>[<email>]
		int n = 0
		text.eachLine {
			String[] t = it.split('\t') // TAB 分隔
			if(t.length == 3 ) {
				def u = User.findByUsername(t[0])
				if(u) {
					u.phone = t[1]
					u.email = t[2]
					if(u.save(flush:true)) ++n
				}
			}
		}
		flash.message = "成功更新 ${n} 个联系信息"
		render(view:'editContects', model:[text: text])
	}


	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
    def edit(Long id) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        [userInstance: userInstance]
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
    def update(Long id, Long version) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (userInstance.version > version) {
                userInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'user.label', default: 'User')] as Object[],
                          "Another user has updated this User while you were editing")
                render(view: "edit", model: [userInstance: userInstance])
                return
            }
        }

        userInstance.properties = params

        if (!userInstance.save(flush: true)) {
            render(view: "edit", model: [userInstance: userInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])
        redirect(action: "show", id: userInstance.id)
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
    def delete(Long id) {
        def userInstance = User.get(id)
        if (!userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
            return
        }

        try {
            userInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
            redirect(action: "show", id: id)
        }
    }

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
	def grant(Long id) {
        def userInstance = User.get(id)
        [userInstance: userInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_LEADER','IS_AUTHENTICATED_FULLY'])
	def saveGrant(Long id) {
        def userInstance = User.get(id)
		// 更新权限
		def authorities = userInstance.authorities
		def roles = params.roles.collect { Role.get(it.key) }
		(roles - authorities).each { UserRole.create(userInstance, it, true) } // 新增权限
		(authorities - roles).each { UserRole.remove(userInstance, it, true) } // 删除权限
		// 如果授权用户为当前用户则重新认证
		if(userInstance.id == springSecurityService.currentUser.id) {
			springSecurityService.reauthenticate(userInstance.username)
		}
		
		flash.message = "用户权限更新成功"
        redirect(action: "show", id: params.id)
	}

}

class ChangePasswordCommand {
	def springSecurityService
	
	String oldPassword
	String newPassword
	String repeatPassword
	
	static constraints = {
		oldPassword nullable:false, blank:false, validator: { val, obj->
			def user = obj.springSecurityService.currentUser as User
			obj.springSecurityService.passwordEncoder.isPasswordValid(user.password, val, null)
		}
		newPassword nullable:false, blank:false
		repeatPassword  nullable:false, blank:false, validator: { val, obj ->
			val == obj.newPassword
		}
	}

}
