dataSource {
    pooled = true
    driverClassName = "com.mysql.jdbc.Driver"
    username = "root"
    password = "123456"
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = "net.sf.ehcache.hibernate.EhCacheProvider"
	flush.mode = "commit"
//	show_sql=true
}

// environment specific settings
environments {
    development {
		    dataSource {
			      dbCreate = "update" // one of 'create', 'create-drop','update'
			      url = "jdbc:mysql://localhost:3306/kaoqin_dev"
				  //logSql = true
				properties {
				    maxActive = 100
				    maxIdle = 25
				    minIdle = 5
				    initialSize = 10
				   minEvictableIdleTimeMillis=1800000
				   timeBetweenEvictionRunsMillis=1800000
				   numTestsPerEvictionRun=3
				   testOnBorrow=true
				   testWhileIdle=true
				   testOnReturn=true
				   validationQuery="SELECT 1"
				}
		    }
	  }
	  test {
		    dataSource {
			      dbCreate = "update"
			      url = "jdbc:mysql://localhost:3306/kaoqin_test"
		    }
	  }
	  production {
		    dataSource {
			      dbCreate = "update"
			      url = "jdbc:mysql://localhost:3306/kaoqin_prod"
				  properties {
				    maxActive = 100
				    maxIdle = 25
				    minIdle = 5
				    initialSize = 10
				    minEvictableIdleTimeMillis=1800000
				    timeBetweenEvictionRunsMillis=1800000
				    maxWait = 10000
					testOnBorrow=true
					testWhileIdle=true
					testOnReturn=true
					validationQuery="SELECT 1"
			      }
		    }
	  }
}