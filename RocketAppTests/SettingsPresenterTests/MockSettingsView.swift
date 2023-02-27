//
//  MockSettingsView.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 27.02.2023.
//

import Foundation
@testable import RocketApp

final class MockView: SettingsViewProtocol {

    var settings = [Settings]()

    func present(settings: [Settings]) {
        self.settings = settings
    }
}
