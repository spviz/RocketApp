//
//  LaunchesPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 30.01.2023.
//

import Foundation

protocol LaunchesPresenterProtocol {
    func getData()
    var launchesView: LaunchesViewProtocol? { get set }
}

class LaunchesPresenter: LaunchesPresenterProtocol {

    private let networkManager = NetworkManager()
    private let dateFormatter = DateFormatter()
    private var launchesModel = [LaunchPresenterModel]()
    weak var launchesView: LaunchesViewProtocol?
    var selectedRocketID: String?

    func getData() {

        dateFormatter.dateFormat = "d MMMM, yyyy"

        guard let selectedRocket = selectedRocketID else { return }
        networkManager.getLaunches(for: selectedRocket) { result in
            switch result {
            case .success(let launches):
                self.launchesModel = launches.docs.map { launch in
                    return LaunchPresenterModel(
                        name: launch.name,
                        date: self.dateFormatter.string(from: launch.dateUtc),
                        imageName: (launch.success ?? false) ? "rocket_true": "rocket_false"
                    )
                }
                self.launchesView?.present(launches: self.launchesModel)
            case .failure(let failure):
                self.launchesView?.present(alert: failure)
            }
        }
    }
}
