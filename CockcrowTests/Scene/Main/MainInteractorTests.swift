//
//  MainInteractorTests.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest
import SwiftDate

class MainInteractorTests: XCTestCase {
    // MARK: Subject under test

    var interactor: MainInteractor!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupMainInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupMainInteractor() {
        interactor = MainInteractor()
    }

    // MARK: Test doubles

    class MainPresentationLogicSpy: MainPresentationLogic {

        var presentDataCalled = false
        var presentAlarmCalled = false
        var presentStopCalled = false
        var presentRingCalled = false

        func presentData(response: Main.Model.Response.ResponseType) {
            presentDataCalled = true

            switch response {
            case .presentAlarm(let model):
                presentAlarmCalled = true
            case .presentStop:
                presentStopCalled = true
            case .presentRing:
                presentRingCalled = true
            }
        }
    }

    class MainServiceLogicSpy: MainServiceLogic {
        var model: AlarmModel?

        func fetch(completion: @escaping (AlarmModel?) -> Void) {
            completion(self.model)
        }

        func run(completion: @escaping (AlarmModel?) -> ()) {
            completion(self.model)
        }

        func stop(completion: @escaping (AlarmModel?) -> ()) {
            completion(self.model)
        }
    }

    // MARK: Tests

    func testFetchAlarm() {
        // Given
        let presenter = MainPresentationLogicSpy()
        let service = MainServiceLogicSpy()
        let model = AlarmModel(enable: true, date: DateInRegion())
        service.model = model
        interactor.presenter = presenter
        interactor.service = service

        // When
        interactor.makeRequest(request: .fetchAlarm)

        // Then
        XCTAssertTrue(presenter.presentDataCalled)
        XCTAssertTrue(presenter.presentAlarmCalled)
    }

    func testRunAlarm() {
        // Given
        let presenter = MainPresentationLogicSpy()
        let service = MainServiceLogicSpy()
        let model = AlarmModel(enable: true, date: DateInRegion())
        service.model = model
        interactor.presenter = presenter
        interactor.service = service

        // When
        interactor.makeRequest(request: .runAlarm)

        // Then
        XCTAssertTrue(presenter.presentDataCalled)
        XCTAssertTrue(presenter.presentRingCalled)
    }

    func testStopAlarm() {
        // Given
        let presenter = MainPresentationLogicSpy()
        let service = MainServiceLogicSpy()
        let model = AlarmModel(enable: true, date: DateInRegion())
        service.model = model
        interactor.presenter = presenter
        interactor.service = service

        // When
        interactor.makeRequest(request: .stopAlarm)

        // Then
        XCTAssertTrue(presenter.presentDataCalled)
        XCTAssertTrue(presenter.presentStopCalled)
    }

}
