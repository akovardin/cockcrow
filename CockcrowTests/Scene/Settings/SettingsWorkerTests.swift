//
//    SettingsWorkerTests.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

@testable import Cockcrow
import XCTest

class SettingsServiceTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: SettingsService!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupSettingsService()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSettingsService() {
        sut = SettingsService()
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testModel() {
        // Given
        
        // When
        
        // Then
    }
    
}
