//
//  SettingsPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 01.02.2023.
//

import Foundation

protocol SettingsPresenterProtocol {
    func getData()
    func setSettings(setting: SettingType?, selectedIndex: Int)
}

final class SettingsPresenter: SettingsPresenterProtocol {

    private let dataManager: DataManagerProtocol
    weak var settingsView: SettingsViewProtocol?

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }

    func getData() {
        let selectedUnit = [
            dataManager.getSelectedIndex(for: .height),
            dataManager.getSelectedIndex(for: .diameter),
            dataManager.getSelectedIndex(for: .mass),
            dataManager.getSelectedIndex(for: .payloadWeights)
            ]
        settingsView?.present(settings: dataManager.settings, selectedUnits: selectedUnit)
    }

    func setSettings(setting: SettingType?, selectedIndex: Int) {
        guard let parameter = setting else { return }

        let selectedUnit = selectedIndex == 0
        ? SelectedUnit.metric
        : SelectedUnit.imperial

        dataManager.setSettings(for: parameter, selectedUnit: selectedUnit)
    }

}
