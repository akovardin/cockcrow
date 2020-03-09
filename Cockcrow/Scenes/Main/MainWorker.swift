//
//  MainWorker.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftDate


protocol MainServiceLogic {
    func fetch(completion: @escaping (AlarmModel?) -> Void)
    func run(completion: @escaping (AlarmModel?) -> Void)
    func stop(completion: @escaping (AlarmModel?) -> Void)
}

class MainService: MainServiceLogic {
    let service = AlarmService()

    func fetch(completion: @escaping (AlarmModel?) -> Void) {
        let model = service.fetch()
        completion(model)
    }

    // запускаем цикл, который проверяет время в моделе
    // и вызывает completion, когда время совпадает
    func run(completion: @escaping (AlarmModel?) -> Void) {
        service.run { model in
            completion(model)
        }

    }

    // останавливаем воспроизведение музыки
    func stop(completion: @escaping (AlarmModel?) -> Void) {
        service.stop { model in
            completion(model)
        }
    }

}
