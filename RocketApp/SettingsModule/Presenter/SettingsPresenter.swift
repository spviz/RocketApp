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
        let settings = [Settings(
                            settingType: .height, units: [.m, .ft],
                            selectedUnits: dataManager.getSelectedUnit(for: .height)
                        ),
                        Settings(
                            settingType: .diameter, units: [.m, .ft],
                            selectedUnits: dataManager.getSelectedUnit(for: .diameter)
                        ),
                        Settings(
                            settingType: .mass, units: [.kg, .lb],
                            selectedUnits: dataManager.getSelectedUnit(for: .mass)
                        ),
                        Settings(
                            settingType: .payloadWeights, units: [.kg, .lb],
                            selectedUnits: dataManager.getSelectedUnit(for: .payloadWeights)
                        )]

        settingsView?.present(settings: settings)
    }

    func setSettings(setting: SettingType?, selectedIndex: Int) {
        guard let parameter = setting else { return }

        let selectedUnit = selectedIndex == 0
        ? SelectedUnit.metric
        : SelectedUnit.imperial

        dataManager.setSettings(for: parameter, selectedUnit: selectedUnit)
    }

}
