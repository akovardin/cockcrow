//
//  MainPresenterTests.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest
import SwiftDate


class MainPresenterTests: XCTestCase {
    // MARK: Subject under test

    var presenter: MainPresenter!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupMainPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupMainPresenter() {
        presenter = MainPresenter()
    }

    // MARK: Test doubles

    class MainDisplayLogicSpy: MainDisplayLogic {
        var displayDataCalled = false

        func displayData(viewModel: Main.Model.ViewModel.ViewModelData) {
            displayDataCalled = true
        }
    }

    // MARK: Tests

    func testPresentData() {
        // Given
        let model = AlarmModel(enable: true, date: DateInRegion())
        let controller = MainDisplayLogicSpy()
        presenter.viewController = controller

        // When
        presenter.presentData(response: .presentAlarm(model: model))

        // Then
        XCTAssertTrue(controller.displayDataCalled)
    }

}
