//
//    SettingsPresenter.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit
import SwiftDate

protocol SettingsPresentationLogic {
    func presentData(response: Settings.Model.Response.ResponseType)
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?

    func presentData(response: Settings.Model.Response.ResponseType) {
        switch response {
        case .presentAlarm(let model):
            let viewModel = SettingsViewModel(date: model.formatDate(), enabled: model.enable)
            viewController?.displayData(viewModel: .displaySettings(model: viewModel))
        }
    }

}
