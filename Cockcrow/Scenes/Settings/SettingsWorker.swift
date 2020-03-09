//
//    SettingsWorker.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

protocol SettingsServiceLogic {
    func fetch(completion: @escaping (AlarmModel?) -> Void)
    func update(_  model: AlarmModel, completion: @escaping (AlarmModel?) -> Void)
}

class SettingsService: SettingsServiceLogic {
    let service = AlarmService()

    func fetch(completion: @escaping (AlarmModel?) -> Void) {
        let model = service.fetch()
        completion(model)
    }

    func update(_ model: AlarmModel, completion: @escaping (AlarmModel?) -> Void) {
        service.update(model)
        completion(model)
    }
}
