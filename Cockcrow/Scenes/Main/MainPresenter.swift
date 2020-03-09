//
//  MainPresenter.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
    func presentData(response: Main.Model.Response.ResponseType)
}

class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    func presentData(response: Main.Model.Response.ResponseType) {
        switch response {
        case .presentAlarm(let model):
            let viewModel = AlarmViewModel(enable: model.enable, date: model.date)
            viewController?.displayData(viewModel: .displayAlarm(model: viewModel))
        case .presentRing:
            viewController?.displayData(viewModel: .displayRing)
        case .presentStop:
            viewController?.displayData(viewModel: .displayStop)
        }
    }

}
