package kaoqin



import org.junit.*
import grails.test.mixin.*

@TestFor(AbsenceRecordController)
@Mock(AbsenceRecord)
class AbsenceRecordControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/absenceRecord/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.absenceRecordInstanceList.size() == 0
        assert model.absenceRecordInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.absenceRecordInstance != null
    }

    void testSave() {
        controller.save()

        assert model.absenceRecordInstance != null
        assert view == '/absenceRecord/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/absenceRecord/show/1'
        assert controller.flash.message != null
        assert AbsenceRecord.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/absenceRecord/list'

        populateValidParams(params)
        def absenceRecord = new AbsenceRecord(params)

        assert absenceRecord.save() != null

        params.id = absenceRecord.id

        def model = controller.show()

        assert model.absenceRecordInstance == absenceRecord
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/absenceRecord/list'

        populateValidParams(params)
        def absenceRecord = new AbsenceRecord(params)

        assert absenceRecord.save() != null

        params.id = absenceRecord.id

        def model = controller.edit()

        assert model.absenceRecordInstance == absenceRecord
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/absenceRecord/list'

        response.reset()

        populateValidParams(params)
        def absenceRecord = new AbsenceRecord(params)

        assert absenceRecord.save() != null

        // test invalid parameters in update
        params.id = absenceRecord.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/absenceRecord/edit"
        assert model.absenceRecordInstance != null

        absenceRecord.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/absenceRecord/show/$absenceRecord.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        absenceRecord.clearErrors()

        populateValidParams(params)
        params.id = absenceRecord.id
        params.version = -1
        controller.update()

        assert view == "/absenceRecord/edit"
        assert model.absenceRecordInstance != null
        assert model.absenceRecordInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/absenceRecord/list'

        response.reset()

        populateValidParams(params)
        def absenceRecord = new AbsenceRecord(params)

        assert absenceRecord.save() != null
        assert AbsenceRecord.count() == 1

        params.id = absenceRecord.id

        controller.delete()

        assert AbsenceRecord.count() == 0
        assert AbsenceRecord.get(absenceRecord.id) == null
        assert response.redirectedUrl == '/absenceRecord/list'
    }
}
