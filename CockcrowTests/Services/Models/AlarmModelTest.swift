//
//  AlarmModelTest.swift
//  Cockcrow
//
//  Created by Artem Kovardin on 02.03.2020.
//  Copyright © 2020 Artem Kovardin. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Cockcrow

class AlarmModelTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testNewAlarmModel() {
        let alarm = AlarmModel(enable: false, date: DateInRegion())

        XCTAssertNotNil(alarm)
    }

}
