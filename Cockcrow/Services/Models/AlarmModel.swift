//
// Created by Artem Kovardin on 02.02.2020.
// Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import Foundation
import SwiftDate

class AlarmModel: Codable {
    var enable: Bool
    var date: DateInRegion
    
    static let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.russian)

    init(enable: Bool, date: DateInRegion) {
        self.enable = enable
        self.date = date
    }

    func formatString() -> String {
        return date.toFormat("HH:mm")
    }

    func formatDate() -> Date {
        return Date(year: 2020, month: 1, day: 1, hour: date.hour, minute: date.minute)
    }


    func nextDay() {
        date = date + 1.days
    }

    func isTimeToRing() -> Bool {
        if !enable {
            return false
        }

        let now = DateInRegion(region: AlarmModel.moscow)

        return now > date
    }
}