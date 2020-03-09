//
//    SettingsViewController.swift
//    WakeUpper
//
//    Created by Artem Kovardin on 01.03.2020.
//    Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

protocol SettingsDisplayLogic: class {
    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {

    var interactor: (SettingsBusinessLogic & SettingsBusinessLogic)?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?

    var model: SettingsViewModel!

    // MARK: Views
    let timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.datePickerMode = .time
        timePicker.setValue(UIColor.black, forKey: "textColor")
        timePicker.timeZone = TimeZone(identifier: "UTC")
        timePicker.locale = Locale(identifier: "ru_RU")

        return timePicker
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLOSE", for: .normal) // @todo: localization
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 12)
        button.backgroundColor = Style.Colors.white

        button.addTarget(self, action: #selector(close), for: .touchUpInside)

        return button
    }()

    lazy var onButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ON", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Light", size: 28)
        button.tintColor = Style.Colors.label

        button.addTarget(self, action: #selector(on), for: .touchUpInside)

        return button
    }()

    let offButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OFF", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Light", size: 28)
        button.tintColor = Style.Colors.label

        button.addTarget(self, action: #selector(off), for: .touchUpInside)

        return button
    }()

    // MARK: Object lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Style.Colors.white

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor?.makeRequest(request: .fetchAlarm)
    }

    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displaySettings(let model):
            self.model = model
            timePicker.setDate(model.date, animated: true)
            toggle(enable: model.enabled)
        }
    }

    // MARK: Setup Views

    func setupViews() {
        view.addSubview(timePicker)
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
        ])

        view.addSubview(onButton)
        NSLayoutConstraint.activate([
            onButton.topAnchor.constraint(equalTo: view.centerYAnchor),
            onButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
        ])

        view.addSubview(offButton)
        NSLayoutConstraint.activate([
            offButton.topAnchor.constraint(equalTo: view.centerYAnchor),
            offButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
        ])

        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            closeButton.heightAnchor.constraint(equalToConstant: 66),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
    }

    // MARK: Action

    @objc func close() {
        self.model.date = timePicker.date
        interactor?.makeRequest(request: .updateAlarm(model: self.model))
        router?.routeToMain()
    }

    @objc func on() {
        toggle(enable: true)
    }

    @objc func off() {
        toggle(enable: false)
    }

    func toggle(enable: Bool) {
        self.model.enabled = enable
        if enable {
            onButton.tintColor = UIColor.black
            offButton.tintColor = Style.Colors.disable
        } else {
            onButton.tintColor = Style.Colors.disable
            offButton.tintColor = UIColor.black
        }
    }

}
