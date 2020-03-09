//
//    SettingsInteractor.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit
import SwiftDate

protocol SettingsBusinessLogic {
    func makeRequest(request: Settings.Model.Request.RequestType)
}

protocol SettingsDataStore {
    var date: DateInRegion { set get }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    var date: DateInRegion = DateInRegion()

    var presenter: SettingsPresentationLogic?
    var service: SettingsServiceLogic?

    func makeRequest(request: Settings.Model.Request.RequestType) {
        if service == nil {
            service = SettingsService()
        }

        switch request {
        case .fetchAlarm:
            service?.fetch { model in
                self.presenter?.presentData(response: .presentAlarm(model: model ?? AlarmModel(enable: false, date: DateInRegion(region: AlarmModel.moscow))))
            }

        case .updateAlarm(let viewModel):
            let model = AlarmModel(
                    enable: viewModel.enabled,
                    date: DateInRegion(region: AlarmModel.moscow).dateBySet(hour: viewModel.date.hour, min: viewModel.date.minute, secs: 0)!
            )

            service?.update(model) { model in
                self.presenter?.presentData(response: .presentAlarm(model: model ?? AlarmModel(enable: false, date: DateInRegion(region: AlarmModel.moscow))))
            }
        }
    }

}
