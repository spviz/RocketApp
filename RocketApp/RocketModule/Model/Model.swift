//
//  Model.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import Foundation

struct Section: Hashable {
    let title: String?
    let type: SectionType
    let items: [ItemType]
}

enum ItemType: Hashable {
    case header(URL, String)
    case info(ParametersName, String, UUID)
    case button
}

enum SectionType {
    case header
    case horizontal
    case vertical
    case button
}

enum ParametersName: String {
    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case payloadWeights = "Нагрузка"
    case firstFlight = "Первый запуск"
    case country = "Cтрана"
    case costPerLaunch = "Стоимость запуска"
    case engines = "Количество двигателей"
    case fuelAmountTons = "Количество топлива"
    case burnTimeSec = "Время сгорания"
}

enum Parameters {
    case height
    case diameter
    case mass
    case payloadWeights
    case firstFlight
    case country
    case costPerLaunch
    case enginesFirstStage
    case fuelAmountTonsFirstStage
    case burnTimeSecFirstStage
    case enginesSecondStage
    case fuelAmountTonsSecondStage
    case burnTimeSecSecondStage
}
