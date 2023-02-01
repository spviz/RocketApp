//
//  SettingsPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 01.02.2023.
//

import Foundation

protocol SettingsPresenterProtocol {
    func getData()
    func setSettings(row: Int, selectedIndex: Int)
}

final class SettingsPresenter: SettingsPresenterProtocol {

    private let dataManager: DataManagerProtocol
    weak var settingsView: SettingsViewProtocol?

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }

    func getData() {
        let selectedUnit = dataManager.settings.indices.map {
            dataManager.getSelectedIndex(row: $0)
        }
        settingsView?.present(settings: dataManager.settings, selectedUnit: selectedUnit)
    }

    func setSettings(row: Int, selectedIndex: Int) {
        dataManager.setSettings(row: row, selectedIndex: selectedIndex)
    }

}
