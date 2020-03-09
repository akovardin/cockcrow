//
//    SettingsPresenterTests.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest
import SwiftDate

class SettingsPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var presenter: SettingsPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupSettingsPresenter()
    }
    
    override func tearDown() {
        presenter = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSettingsPresenter() {
        presenter = SettingsPresenter()
    }
    
    // MARK: Test doubles
    
    class SettingsDisplayLogicSpy: SettingsDisplayLogic {
        var displayDataCalled = false
        
        func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
            displayDataCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentAlarm() {
        // Given
        let model = AlarmModel(enable: true, date: DateInRegion())
        let controller = SettingsDisplayLogicSpy()
        presenter.viewController = controller
        
        // When
        presenter.presentData(response: .presentAlarm(model: model))
        
        // Then
        XCTAssertTrue(controller.displayDataCalled, "presentData(response:) should ask the view controller to display the result")
    }
    
}
