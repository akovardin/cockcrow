//
//  MainViewControllerTests.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest
import SwiftDate

class MainViewControllerTests: XCTestCase {
    // MARK: Subject under test

    var controller: MainViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupMainViewController()
    }

    override func tearDown() {
        window = nil
        controller = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupMainViewController() {
        controller = MainViewController()
    }

    func loadView() {
        window.addSubview(controller.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles

    class MainBusinessLogicSpy: MainBusinessLogic, MainDataStore {
        var date: DateInRegion = DateInRegion()

        var makeRequestCalled = false
        var runAlarmCalled = false
        var fetchAlarmCalled = false
        var stopAlarmCalled = false

        func makeRequest(request: Main.Model.Request.RequestType) {
            makeRequestCalled = true

            switch request {
            case .runAlarm:
                runAlarmCalled = true
            case .fetchAlarm:
                fetchAlarmCalled = true
            case .stopAlarm:
                stopAlarmCalled = true
            }
        }
    }

    class MainRoutingLogicSpy: NSObject, MainRoutingLogic, MainDataPassing {
        var dataStore: MainDataStore?

        var routeToSettingsCalled = false

        func routeToSettings() {
            routeToSettingsCalled = true
        }

    }

    // MARK: Tests

    func testShouldmakeRequestWhenViewIsLoaded() {
        // Given
        let interactor = MainBusinessLogicSpy()
        controller.interactor = interactor

        // When
        loadView()

        // Then
        XCTAssertTrue(interactor.makeRequestCalled)
        XCTAssertTrue(interactor.fetchAlarmCalled)
        XCTAssertTrue(interactor.runAlarmCalled)
    }

    func testShouldmakeRequestWhenViewIsAppear() {
        // Given
        let interactor = MainBusinessLogicSpy()
        controller.interactor = interactor

        // When
        loadView()
        controller.viewWillAppear(true)

        // Then
        XCTAssertTrue(interactor.makeRequestCalled)
    }

    func testDisplayEnabledAlarm() {
        // Given
        let model = AlarmViewModel(
                enable: true,
                date: DateInRegion().dateBySet(hour: 10, min: 01, secs: 00)!
        )

        // When
        loadView()
        controller.displayData(viewModel: .displayAlarm(model: model))

        // Then
        XCTAssertEqual(controller.titleLabel.text, "WAKE ME UP AT")
        XCTAssertEqual(controller.timeLabel.text, model.formatTime())
        XCTAssertEqual(controller.dateLabel.text, model.formatDate())
    }

    func testDisplayDisabledAlarm() {
        // Given
        let model = AlarmViewModel(
                enable: false,
                date: DateInRegion().dateBySet(hour: 10, min: 01, secs: 00)!
        )

        // When
        loadView()
        controller.displayData(viewModel: .displayAlarm(model: model))

        // Then
        XCTAssertEqual(controller.timeLabel.text, "")
    }

    func testDisplayRingAlarm() {
        // Given
        let model = AlarmViewModel(
                enable: false,
                date: DateInRegion().dateBySet(hour: 10, min: 01, secs: 00)!
        )
        controller.stopButton.isHidden = true

        // When
        loadView()
        controller.displayData(viewModel: .displayRing)

        // Then
        XCTAssertEqual(controller.stopButton.isHidden, false)
    }

    func testDisplayStopAlarm() {
        // Given
        let model = AlarmViewModel(
                enable: false,
                date: DateInRegion().dateBySet(hour: 10, min: 01, secs: 00)!
        )
        controller.stopButton.isHidden = false

        // When
        loadView()
        controller.displayData(viewModel: .displayStop)

        // Then
        XCTAssertEqual(controller.stopButton.isHidden, true)
    }

    func testRouteToSettings() {
        // Given
        let router = MainRoutingLogicSpy()
        controller.router = router

        // When
        controller.settings()

        // Then
        XCTAssertTrue(router.routeToSettingsCalled)
    }

    func testStop() {
        // Given
        let interactor = MainBusinessLogicSpy()
        controller.interactor = interactor
        controller.stopButton.isHidden = false

        // When
        loadView()
        controller.stop()

        // Then
        XCTAssertTrue(interactor.makeRequestCalled)
    }

}
