package kaoqin

// 各个节次的时间
// 注意：一般通过节次查询作息时间，而不是引用该类的对象。
//       当作息时间变化时，需要修改对应的时间。
class ClassHour {
	int number // 节次
	String name // 节次（第1-12节）
	String timeStart // 开始时间（HH:mm）
	String timeEnd // 结束时间（HH:mm）

	static constraints = {
		number min: 1, max: 12, nullable: false, unique: true
		name maxSize: 20, blank: false
		timeStart size: 5..5, blank: false, matches: '^((0[7-9])|(1[0-9])|(2[0-2])):([0-5][0-9])$', validator: { val,obj-> val < obj.timeEnd }
		timeEnd size: 5..5, blank: false, matches: '^((0[7-9])|(1[0-9])|(2[0-2])):([0-5][0-9])$', validator: { val,obj-> val > obj.timeStart }
	}
	
	static mapping = {
		cache true
		sort 'number'
		number index:'number_idx'
	}
	
	def beforeInsert() {
		reloadCache()
	}

	def beforeUpdate() {
		reloadCache()
	}
	
	def beforeDelete() {
		reloadCache()
	}
	
	// 辅助方法
	static cache = [:]
	
	static reloadCache() {
		ClassHour.list().each {
			cache[it.number] = it
		}
	}
	
	static ClassHour getAt(int number) {
		if(!cache) {
			reloadCache()
		}
		cache[number]
	}
}
