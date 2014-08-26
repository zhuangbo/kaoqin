package kaoqin



import org.junit.*
import grails.test.mixin.*

@TestFor(TimetableController)
@Mock(Timetable)
class TimetableControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/timetable/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.timetableInstanceList.size() == 0
        assert model.timetableInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.timetableInstance != null
    }

    void testSave() {
        controller.save()

        assert model.timetableInstance != null
        assert view == '/timetable/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/timetable/show/1'
        assert controller.flash.message != null
        assert Timetable.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/timetable/list'

        populateValidParams(params)
        def timetable = new Timetable(params)

        assert timetable.save() != null

        params.id = timetable.id

        def model = controller.show()

        assert model.timetableInstance == timetable
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/timetable/list'

        populateValidParams(params)
        def timetable = new Timetable(params)

        assert timetable.save() != null

        params.id = timetable.id

        def model = controller.edit()

        assert model.timetableInstance == timetable
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/timetable/list'

        response.reset()

        populateValidParams(params)
        def timetable = new Timetable(params)

        assert timetable.save() != null

        // test invalid parameters in update
        params.id = timetable.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/timetable/edit"
        assert model.timetableInstance != null

        timetable.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/timetable/show/$timetable.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        timetable.clearErrors()

        populateValidParams(params)
        params.id = timetable.id
        params.version = -1
        controller.update()

        assert view == "/timetable/edit"
        assert model.timetableInstance != null
        assert model.timetableInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/timetable/list'

        response.reset()

        populateValidParams(params)
        def timetable = new Timetable(params)

        assert timetable.save() != null
        assert Timetable.count() == 1

        params.id = timetable.id

        controller.delete()

        assert Timetable.count() == 0
        assert Timetable.get(timetable.id) == null
        assert response.redirectedUrl == '/timetable/list'
    }
}
