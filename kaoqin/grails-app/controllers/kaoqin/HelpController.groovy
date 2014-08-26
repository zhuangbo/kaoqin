package kaoqin

import grails.plugins.springsecurity.Secured;

@Secured(['ROLE_ADMIN', 'ROLE_USER', 'ROLE_ADVISOR', 'ROLE_COUNSELLOR', 'ROLE_LEADER'])
class HelpController {

    def index() { }
}
