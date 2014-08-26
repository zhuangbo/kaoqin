package kaoqin

import grails.plugins.springsecurity.Secured;

@Secured(['ROLE_ADMIN', 'ROLE_LEADER'])
class SemesterController {

    def scaffold = true
}
