//
//  MainRouter.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

protocol MainRoutingLogic {
    func routeToSettings()
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {

    var dataStore: MainDataStore?

    weak var viewController: MainViewController?

    // MARK: Routing
    func routeToSettings() {
        let destination = SettingsViewController()
        var store = destination.router!.dataStore!
        passDataToSettings(source: dataStore!, destination: &store)
        navigateToSettings(source: viewController!, destination: destination)

    }

    func navigateToSettings(source: MainViewController, destination: SettingsViewController) {
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true)
    }

    func passDataToSettings(source: MainDataStore, destination: inout SettingsDataStore) {
        destination.date = source.date
    }
}
