package kaoqin



import org.junit.*
import grails.test.mixin.*

@TestFor(ClassGradeController)
@Mock(ClassGrade)
class ClassGradeControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/classGrade/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.classGradeInstanceList.size() == 0
        assert model.classGradeInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.classGradeInstance != null
    }

    void testSave() {
        controller.save()

        assert model.classGradeInstance != null
        assert view == '/classGrade/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/classGrade/show/1'
        assert controller.flash.message != null
        assert ClassGrade.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/classGrade/list'

        populateValidParams(params)
        def classGrade = new ClassGrade(params)

        assert classGrade.save() != null

        params.id = classGrade.id

        def model = controller.show()

        assert model.classGradeInstance == classGrade
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/classGrade/list'

        populateValidParams(params)
        def classGrade = new ClassGrade(params)

        assert classGrade.save() != null

        params.id = classGrade.id

        def model = controller.edit()

        assert model.classGradeInstance == classGrade
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/classGrade/list'

        response.reset()

        populateValidParams(params)
        def classGrade = new ClassGrade(params)

        assert classGrade.save() != null

        // test invalid parameters in update
        params.id = classGrade.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/classGrade/edit"
        assert model.classGradeInstance != null

        classGrade.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/classGrade/show/$classGrade.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        classGrade.clearErrors()

        populateValidParams(params)
        params.id = classGrade.id
        params.version = -1
        controller.update()

        assert view == "/classGrade/edit"
        assert model.classGradeInstance != null
        assert model.classGradeInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/classGrade/list'

        response.reset()

        populateValidParams(params)
        def classGrade = new ClassGrade(params)

        assert classGrade.save() != null
        assert ClassGrade.count() == 1

        params.id = classGrade.id

        controller.delete()

        assert ClassGrade.count() == 0
        assert ClassGrade.get(classGrade.id) == null
        assert response.redirectedUrl == '/classGrade/list'
    }
}
