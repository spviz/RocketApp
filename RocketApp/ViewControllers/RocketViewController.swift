//
//  RocketViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

final class RocketViewController: UIViewController {

    let settingsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        settingsButton.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
        settingsButton.center = view.center

        view.backgroundColor = .white
        view.addSubview(settingsButton)
    }

    init(color: UIColor) {
        super .init(nibName: nil, bundle: nil)
        self.view.backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func presentSettings() {
        present(SettingsViewController(dataManager: DataManager()), animated: true)
    }

}
