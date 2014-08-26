// Place your Spring DSL code here
beans = {
	daoAndWebPortalAuthenticationProvider(kaoqin.DaoAndWebPortalAuthenticationProvider) {
		daoAuthenticationProvider = ref("daoAuthenticationProvider")
	}
}
