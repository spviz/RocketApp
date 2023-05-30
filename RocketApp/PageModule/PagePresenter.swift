//
//  PagePresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 03.02.2023.
//

import Foundation

protocol PagePresenterProtocol {
    func getData()
}

final class PagePresenter: PagePresenterProtocol {

    private let networkManager: NetworkManagerProtocol
    weak var pageView: PageViewProtocol?
    var presentSettingsClosure: (() -> Void)?
    var pushLaunchesClosure: ((String, String) -> Void)?

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getData() {
        networkManager.getRockets { result in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    let rocketViewControllersArray = rockets.map { rocket in
                        let rocketPresenter = RocketPresenter(rocket: rocket)
                        let rocketView = RocketViewController(presenter: rocketPresenter)
                        rocketView.pushLaunchesClosure = { [weak self] in
                            self?.pushLaunchesClosure?(rocket.id, rocket.name)
                        }
                        rocketView.presentSettingsClosure = self.presentSettingsClosure
                        rocketPresenter.rocketView = rocketView
                        return rocketView
                    }
                    self.pageView?.present(rocketViewControllers: rocketViewControllersArray)
                }
            case .failure(let failure):
                self.pageView?.present(alert: failure)
            }
        }
    }
}
