import kaoqin.ClassHour;
import kaoqin.Role;
import kaoqin.User
import kaoqin.UserRole;

class BootStrap {
	
	def grailsApplication
	
    def init = { servletContext ->
		// 系统初始化
		initRoles()  // 初始化系统权限
		initAdminUser()  // 初始化系统管理员
		initClassHours()  // 课时时间表
    }
	
    def destroy = {
    }

	// 初始化系统权限
	def initRoles = {
		// if no roles then create them
		if(Role.count()==0) {
			log.info("Create roles")
			println "Create roles"
			// create each role in Config.groovy: 'kaoqin.roles'
			grailsApplication.config.kaoqin.roles.each { role ->
				new Role(authority: role).save(true)
			}
		}
	}
	
	// 初始化系统管理员
	def initAdminUser = {
		// find admin user Config.groovy: 'kaoqin.admin'
		User admin = User.findByUsername(grailsApplication.config.kaoqin.admin.username)
		// create it if not fond
		if(admin == null) {
			log.info("Create admin user")
			// create admin user using Config.groovy: 'kaoqin.admin'
			admin = new User(grailsApplication.config.kaoqin.admin)
			admin.enabled = true
			// new admin user and save it
			if(admin.save(true)) {
				// assigned role
				UserRole.create(admin, Role.findByAuthority('ROLE_ADMIN'), true)
				log.info("Admin user created.")
			} else {
				log.error("Save admin user error:"+admin.errors)
			}
		}
	}
	
	// 初始化课时时间
	def initClassHours = {
		if(ClassHour.count()==0) {
			def start = ['08:00','08:55','10:00','10:55','10:00','14:30','15:25','16:30','17:25','16:30','19:30','20:25']
			def end =   ['08:45','09:40','10:45','11:40','12:15','15:15','16:10','17:15','18:10','18:45','20:15','21:10']
			def name = ['第一小节','第二小节','第三小节','第四小节','实验3小节','第五小节','第六小节','第七小节','第八小节','实验3小节','第九小节','第十小节']
			for(int i=0; i<12; i++) {
				new ClassHour(number:(i+1), name:name[i], timeStart:start[i], timeEnd:end[i]).save()
			}
		}
	}

}
