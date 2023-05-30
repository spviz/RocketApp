//
//  LaunchesPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 30.01.2023.
//

import Foundation

protocol LaunchesPresenterProtocol {
    func getData()
}

final class LaunchesPresenter: LaunchesPresenterProtocol {

    private let networkManager: NetworkManagerProtocol
    private let dateFormatter = DateFormatter()
    private let selectedRocketID: String
    private let selectedRocketName: String
    weak var launchesView: LaunchesViewProtocol?

    init(selectedRocketID: String, selectedRocketName: String, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.selectedRocketID = selectedRocketID
        self.selectedRocketName = selectedRocketName
        self.networkManager = networkManager
        dateFormatter.dateFormat = "d MMMM, yyyy"
    }

    func getData() {
        networkManager.getLaunches(for: selectedRocketID) { [weak self] result in
            switch result {
            case .success(let launches):
                let launchesArray = launches.docs.map { launch in
                    return LaunchItem(
                        name: launch.name,
                        date: self?.dateFormatter.string(from: launch.dateUtc) ?? "No Data",
                        imageName: (launch.success ?? false) ? "rocket_true": "rocket_false"
                    )
                }
                let launchesInfo = LaunchesInfo(
                    rocketName: self?.selectedRocketName ?? "No Data",
                    launches: launchesArray
                )
                self?.launchesView?.present(launchesInfo: launchesInfo)
            case .failure(let failure):
                self?.launchesView?.present(alert: failure)
            }
        }
    }
}
