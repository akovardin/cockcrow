//
//    SettingsRouter.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

protocol SettingsRoutingLogic {
    func routeToMain()
}

protocol SettingsDataPassing {
    var dataStore: SettingsDataStore? { get }
}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing {
    var dataStore: SettingsDataStore?

    weak var viewController: SettingsViewController?
    
    // MARK: Routing

    func routeToMain() {
        navigateToMain(source: viewController!)
    }

    func navigateToMain(source: SettingsViewController) {
        source.dismiss(animated: true)
    }
    
}
