package kaoqin

import grails.plugins.springsecurity.Secured;

@Secured(['ROLE_USER'])
class TimetableService {

    def list() {

    }
}
