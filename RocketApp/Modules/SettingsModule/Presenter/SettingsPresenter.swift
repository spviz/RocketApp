//
//  SettingsPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 29.01.2023.
//

import Foundation

protocol SettingsPresenterProtocol {
    func getSettings() -> [Settings]
    func getSelectedIndex(index: Int) -> SelectedUnit
    func setSettings(for indexPath: Int, selectedIndex: Int)
}

final class SettingsPresenter: SettingsPresenterProtocol {

    private let dataManager = DataManager()

    func getSelectedIndex(index: Int) -> SelectedUnit {
        dataManager.getSelectedIndex(for: index)
    }

    func getSettings() -> [Settings] {
        dataManager.settings
    }

    func setSettings(for indexPath: Int, selectedIndex: Int) {
        dataManager.setSettings(for: indexPath, selectedIndex: selectedIndex)
    }
}
