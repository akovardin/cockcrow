//
//    SettingsInteractorTests.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest
import SwiftDate

class SettingsInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var interactor: SettingsInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupSettingsInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSettingsInteractor() {
        interactor = SettingsInteractor()
    }
    
    // MARK: Test doubles
    
    class SettingsPresentationLogicSpy: SettingsPresentationLogic {
        var model: AlarmModel?
        var presentDataCalled = false
        var presentAlarmCalled = false
        
        func presentData(response: Settings.Model.Response.ResponseType) {
            presentDataCalled = true

            switch response {
            case .presentAlarm(let model):
                self.model = model
                presentAlarmCalled = true
            }
        }
    }

    class SettingsServiceLogicSpy: SettingsServiceLogic {
        var model: AlarmModel?
        
        func fetch(completion: @escaping (AlarmModel?) -> ()) {
            completion(self.model)
        }

        func update(_ model: AlarmModel, completion: @escaping (AlarmModel?) -> ()) {
            completion(model)
        }
    }
    
    // MARK: Tests
    
    func testFetchAlarm() {
        // Given
        let date = DateInRegion()
        let model = AlarmModel(enable: true, date: date)
        let service = SettingsServiceLogicSpy()
        let presenter = SettingsPresentationLogicSpy()
        interactor.presenter = presenter
        interactor.service = service
        
        // When
        interactor.makeRequest(request: .fetchAlarm)
        
        // Then
        XCTAssertTrue(presenter.presentDataCalled)
        XCTAssertTrue(presenter.presentAlarmCalled)
    }

    func testUpdateAlarm() {
        // Given
        let date = Date()
        let model = SettingsViewModel(date: date, enabled: false)
        let service = SettingsServiceLogicSpy()
        let presenter = SettingsPresentationLogicSpy()
        interactor.presenter = presenter
        interactor.service = service

        // When
        interactor.makeRequest(request: .updateAlarm(model: model))

        // Then
        XCTAssertTrue(presenter.presentDataCalled)
        XCTAssertTrue(presenter.presentAlarmCalled)
        XCTAssertFalse(presenter.model?.enable ?? true)
    }
    
}
