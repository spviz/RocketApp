//
//  RocketViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

final class RocketViewController: UIViewController {

    let settingsButton = UIButton()
    let launchesButton = UIButton()
    var rocket: String?
    var rocketName: String?
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        settingsButton.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
        settingsButton.center = view.center

        launchesButton.frame = CGRect(x: view.center.x - 100, y: 100, width: 200, height: 50)
        launchesButton.setTitle("Посмотреть запуски", for: .normal)
        launchesButton.backgroundColor = .lightGray
        launchesButton.layer.cornerRadius = 10
        launchesButton.addTarget(self, action: #selector(pushLaunches), for: .touchUpInside)

        view.backgroundColor = .white
        view.addSubview(settingsButton)
        view.addSubview(launchesButton)
    }

    init(color: UIColor, rocket: String, name: String) {
        super .init(nibName: nil, bundle: nil)
        self.view.backgroundColor = color
        self.rocket = rocket
        self.rocketName = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func presentSettings() {
        present(SettingsViewController(dataManager: DataManager()), animated: true)
    }

    @objc func pushLaunches() {
        let launchesViewController = LaunchesViewController(network: networkManager)
        launchesViewController.selectedRocketID = rocket
        launchesViewController.selectedRocketName = rocketName
        self.navigationController?.pushViewController(launchesViewController, animated: true)
    }

}
