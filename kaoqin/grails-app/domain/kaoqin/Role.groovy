package kaoqin

import org.springframework.security.core.GrantedAuthority;

class Role implements GrantedAuthority, Serializable {

	Integer id
	String authority
	String description

	static mapping = {
		cache true
		version false
		sort 'id'
		authority index:'authority_idx'
	}

	static constraints = {
		authority blank: false, unique: true
		description nullable: true, blank: true
	}
	
	@Override
	String toString() {
		description ?: authority
	}
	
	@Override
	public boolean equals(Object obj) {
		if(!(obj instanceof Role)) return false
		obj.id==this.id
	}
	
	@Override
	public int hashCode() {
		this.id.hashCode()
	}
	
	def beforeDelete() {
		UserRole.removeAll(this)
	}
}
