//
//  MainViewController.swift
//  WakeUpper
//
//  Created by Artem Kovardin on 01.03.2020.
//  Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import UIKit

protocol MainDisplayLogic: class {
    func displayData(viewModel: Main.Model.ViewModel.ViewModelData)
}

class MainViewController: UIViewController, MainDisplayLogic {

    var interactor: (MainBusinessLogic & MainDataStore)?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?

    // Views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "WAKE ME UP AT" // @todo: localization
        label.textColor = Style.Colors.label
        label.font = UIFont(name: "Rubik-Light", size: 28)
        label.textAlignment = .center

        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "" // @todo: localization
        label.textColor = Style.Colors.label
        label.font = UIFont(name: "Rubik-Light", size: 28)
        label.textAlignment = .center

        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = ""
        label.textColor = Style.Colors.label
        label.font = UIFont(name: "Rubik-Light", size: 72)
        label.textAlignment = .center

        return label
    }()

    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("EDIT", for: .normal) // @todo: localization
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 12)
        button.backgroundColor = Style.Colors.white

        button.addTarget(self, action: #selector(settings), for: .touchUpInside)

        return button
    }()

    lazy var stopButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("WAKED UP", for: .normal) // @todo: localization
        button.setTitleColor(Style.Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Rubik-Light", size: 28)
        button.backgroundColor = Style.Colors.red
        button.isHidden = true

        button.addTarget(self, action: #selector(stop), for: .touchUpInside)

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
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
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

        view.backgroundColor = Style.Colors.background

        setupViews()

        interactor?.makeRequest(request: .runAlarm)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor?.makeRequest(request: .fetchAlarm)
    }

    func displayData(viewModel: Main.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayAlarm(let model):
            timeLabel.text = model.formatTime() ?? ""
            dateLabel.text = model.formatDate() ?? ""
        case .displayStop:
            stopButton.isHidden = true
            timeLabel.text = ""
            dateLabel.text = ""
        case .displayRing:
            stopButton.isHidden = false
        }
    }

    // MARK: Setup Views

    func setupViews() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])

        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])

        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20)
        ])

        view.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            settingsButton.heightAnchor.constraint(equalToConstant: 66),
            settingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])

        view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            stopButton.heightAnchor.constraint(equalToConstant: 89)
        ])
    }

    // MARK: Actions

    @objc func settings() {
        router?.routeToSettings()
    }

    @objc func stop() {
        interactor?.makeRequest(request: .stopAlarm)
    }
}
