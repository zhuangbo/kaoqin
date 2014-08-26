package kaoqin



import org.junit.*
import grails.test.mixin.*

@TestFor(ClassHourController)
@Mock(ClassHour)
class ClassHourControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/classHour/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.classHourInstanceList.size() == 0
        assert model.classHourInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.classHourInstance != null
    }

    void testSave() {
        controller.save()

        assert model.classHourInstance != null
        assert view == '/classHour/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/classHour/show/1'
        assert controller.flash.message != null
        assert ClassHour.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/classHour/list'

        populateValidParams(params)
        def classHour = new ClassHour(params)

        assert classHour.save() != null

        params.id = classHour.id

        def model = controller.show()

        assert model.classHourInstance == classHour
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/classHour/list'

        populateValidParams(params)
        def classHour = new ClassHour(params)

        assert classHour.save() != null

        params.id = classHour.id

        def model = controller.edit()

        assert model.classHourInstance == classHour
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/classHour/list'

        response.reset()

        populateValidParams(params)
        def classHour = new ClassHour(params)

        assert classHour.save() != null

        // test invalid parameters in update
        params.id = classHour.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/classHour/edit"
        assert model.classHourInstance != null

        classHour.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/classHour/show/$classHour.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        classHour.clearErrors()

        populateValidParams(params)
        params.id = classHour.id
        params.version = -1
        controller.update()

        assert view == "/classHour/edit"
        assert model.classHourInstance != null
        assert model.classHourInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/classHour/list'

        response.reset()

        populateValidParams(params)
        def classHour = new ClassHour(params)

        assert classHour.save() != null
        assert ClassHour.count() == 1

        params.id = classHour.id

        controller.delete()

        assert ClassHour.count() == 0
        assert ClassHour.get(classHour.id) == null
        assert response.redirectedUrl == '/classHour/list'
    }
}
