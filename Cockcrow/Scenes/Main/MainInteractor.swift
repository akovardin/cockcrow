//
//  MainInteractor.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit
import SwiftDate

protocol MainBusinessLogic {
    func makeRequest(request: Main.Model.Request.RequestType)
}

protocol MainDataStore {
    var date: DateInRegion { set get }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    var date: DateInRegion = DateInRegion()

    var presenter: MainPresentationLogic?
    var service: MainServiceLogic?

    func makeRequest(request: Main.Model.Request.RequestType) {
        if service == nil {
            service = MainService()
        }

        switch request {
        case .fetchAlarm:
            service?.fetch { model in
                self.presenter?.presentData(response: .presentAlarm(model: model!))
            }
        case .stopAlarm:
            service?.stop { model in
                self.presenter?.presentData(response: .presentStop)
            }
        case .runAlarm:
            service?.run { model in
                self.presenter?.presentData(response: .presentRing)
            }
        }
    }

}
