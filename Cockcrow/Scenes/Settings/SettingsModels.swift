//
//    SettingsModels.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

enum Settings {

    enum Model {
        struct Request {
            enum RequestType {
                case fetchAlarm
                case updateAlarm(model: SettingsViewModel)
            }
        }

        struct Response {
            enum ResponseType {
                case presentAlarm(model: AlarmModel)
            }
        }

        struct ViewModel {
            enum ViewModelData {
                case displaySettings(model: SettingsViewModel)
            }
        }
    }

}

struct SettingsViewModel {
    var date: Date
    var enabled: Bool
}