//
//  MainModels.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit
import SwiftDate

enum Main {

    enum Model {
        struct Request {
            enum RequestType {
                case runAlarm // run main loop
                case fetchAlarm
                case stopAlarm
            }
        }

        struct Response {
            enum ResponseType {
                case presentAlarm(model: AlarmModel)
                case presentStop
                case presentRing
            }
        }

        struct ViewModel {
            enum ViewModelData {
                case displayAlarm(model: AlarmViewModel)
                case displayStop
                case displayRing
            }
        }
    }

}

struct AlarmViewModel {
    var enable: Bool
    var date: DateInRegion

    func formatTime() -> String {
        if !enable {
            return ""
        }
        return date.toFormat("HH:mm")
    }

    func formatDate() -> String {
        if !enable {
            return ""
        }
        return date.toFormat("dd.MM")
    }
}