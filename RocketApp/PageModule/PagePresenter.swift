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
    var presentSettingsClosure: (() -> Void)?
    var onChangeSettings: (() -> Void)?
    var pushLaunchesClosure: ((String, String) -> Void)?

    func getData() {
        networkManager.getRockets { result in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    let rocketViewControllersArray = rockets.map { rocket in
                        let rocketPresenter = RocketPresenter(rocket: rocket)
                        let rocketView = RocketViewController(presenter: rocketPresenter)
                        rocketView.pushLaunchesClosure = {
                            self.pushLaunchesClosure?(rocket.id, rocket.name)
                        }
                        rocketView.presentSettingsClosure = self.presentSettingsClosure
                        rocketPresenter.rocketView = rocketView
                        return rocketView
                    }
                    self.onChangeSettings = {
                        for rocketView in rocketViewControllersArray {
                            rocketView.reloadCollectionView()
                        }
                    }
                    self.pageView?.present(rocketViewControllers: rocketViewControllersArray)
                }
            case .failure(let failure):
                self.pageView?.present(alert: failure)
            }
        }
    }
}
