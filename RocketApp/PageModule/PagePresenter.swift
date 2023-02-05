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

    private let networkManager = NetworkManager()
    weak var pageView: PageViewProtocol?

    func getData() {
        networkManager.getRockets { result in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    let rocketViewControllersArray = rockets.map { rocket in

                        let presenter = RocketPresenter(rocket: rocket)
                        let rocketVC = RocketViewController(presenter: presenter)
                        presenter.rocketView = rocketVC
                        return rocketVC
                    }
                    self.pageView?.present(rocketViewControllers: rocketViewControllersArray)
                }
            case .failure(let failure):
                self.pageView?.present(alert: failure)
            }
        }
    }
}
