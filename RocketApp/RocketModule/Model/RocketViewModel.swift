//
//  RocketViewModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import Foundation

struct Section: Hashable {
    let type: SectionType
    let items: [Item]
}

struct Item: Hashable {
    var parameterName: Parameters?
    var rocketInfoName: RocketInfo?
    var firstStageInfoName: FirstStageInfo?
    var secondStageInfoName: SecondStageInfo?
}
enum SectionType: String {
    case parameters
    case rocketInfo
    case firstStageInfo
    case secondStageInfo
}

enum Parameters: String {
    case height = "Высота"
    case diameter = "Диаметр"
    case mass = "Масса"
    case payloadWeights = "Нагрузка"
}

enum RocketInfo: String {
    case firstFlight = "Первый запуск"
    case country = "Cтрана"
    case costPerLaunch = "Стоимость запуска"
}
enum FirstStageInfo: String {
    case engines = "Количество двигателей"
    case fuelAmountTons = "Количество топлива"
    case burnTimeSEC = "Время сгорания"
}
enum SecondStageInfo: String {
    case engines = "Количество двигателей"
    case fuelAmountTons = "Количество топлива"
    case burnTimeSEC = "Время сгорания"
}
