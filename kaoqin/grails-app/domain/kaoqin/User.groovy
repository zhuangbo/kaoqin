package kaoqin

class User {

	transient springSecurityService

	String username
	String password
	String realName
	String phone
	String email
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	static constraints = {
		username blank: false, unique: true
		password blank: false
		realName blank: false
		phone nullable: true, blank: true
		email nullable: true, blank: true, email: true
		enabled ()
		accountExpired ()
		accountLocked ()
		passwordExpired ()
	}

	static mapping = {
		cache true
		password column: '`password`'
		sort 'username'
		username index:'username_idx'
		realName index:'real_name_idx'
	}
	
	String toString() {
		realName
	}

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role } as Set
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}
}
