//
//    SettingsViewControllerTests.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest
import SwiftDate

class SettingsViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var controller: SettingsViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupSettingsViewController()
    }

    override func tearDown() {
        window = nil
        controller = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupSettingsViewController() {
        controller = SettingsViewController()
    }

    func loadView() {
        window.addSubview(controller.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class SettingsBusinessLogicSpy: SettingsBusinessLogic, SettingsDataStore {
        var date: DateInRegion = DateInRegion()

        var model: SettingsViewModel?

        var makeRequestCalled = false
        var fetchAlarmCalled = false
        var updateAlarmCalled = false

        func makeRequest(request: Settings.Model.Request.RequestType) {
            makeRequestCalled = true

            switch request {
            case .fetchAlarm:
                fetchAlarmCalled = true
            case .updateAlarm(let model):
                updateAlarmCalled = true
                self.model = model
            }
        }
    }

    class SettingsRoutingLogicSpy: NSObject, SettingsRoutingLogic, SettingsDataPassing {
        var dataStore: SettingsDataStore?

        var routeToMainCalled = false

        func routeToMain() {
            routeToMainCalled = true
        }
    }

    // MARK: Tests

    func testShouldmakeRequestWhenViewIsLoaded() {
        // Given
        let interactor = SettingsBusinessLogicSpy()
        controller.interactor = interactor

        // When
        loadView()
        controller.viewWillAppear(true)

        // Then
        XCTAssertTrue(interactor.makeRequestCalled)
    }

    func testDisplaySettingsWhenAlarmEnabled() {
        // Given
        let date = Date()
        let viewModel = SettingsViewModel(date: date, enabled: true)

        // When
        loadView()
        controller.displayData(viewModel: .displaySettings(model: viewModel))

        // Then
        XCTAssertEqual(controller.timePicker.date, date)
        XCTAssertEqual(controller.onButton.tintColor, Style.Colors.black)
        XCTAssertEqual(controller.offButton.tintColor, Style.Colors.disable)
    }

    func testDisplaySettingsWhenAlarmDisabled() {
        // Given
        let date = Date()
        let viewModel = SettingsViewModel(date: date, enabled: false)

        // When
        loadView()
        controller.displayData(viewModel: .displaySettings(model: viewModel))

        // Then
        XCTAssertEqual(controller.timePicker.date, date)
        XCTAssertEqual(controller.onButton.tintColor, Style.Colors.disable)
        XCTAssertEqual(controller.offButton.tintColor, Style.Colors.black)
    }

    func testClose() {
        // Given
        let date = Date()
        let model = SettingsViewModel(date: date, enabled: true)
        let router = SettingsRoutingLogicSpy()
        let interactor = SettingsBusinessLogicSpy()
        controller.router = router
        controller.interactor = interactor
        controller.model = model

        // When
        loadView()
        controller.close()

        // Then
        XCTAssertTrue(interactor.updateAlarmCalled)
        XCTAssertEqual(interactor.model?.date.hour, model.date.hour)
        XCTAssertEqual(interactor.model?.date.minute, model.date.minute)
        XCTAssertTrue(router.routeToMainCalled)
    }

}
