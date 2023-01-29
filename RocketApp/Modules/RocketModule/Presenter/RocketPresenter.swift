//
//  RocketPresenter.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 29.01.2023.
//

import Foundation

protocol RocketPresenterProtocol {
    func getSections() -> [Section]
    func getRocketInfo() -> Rocket
    func setupData()
}
class RocketPresenter: RocketPresenterProtocol {
    enum Constants: String {
        case noData = "Нет данных"
        case firstStage = "ПЕРВАЯ СТУПЕНЬ"
        case secondStage = "ВТОРАЯ СТУПЕНЬ"
        case million = "млн"
        case ton = "ton"
        case sec = "sec"
    }

    private let rocket: Rocket
    private let dataManager: DataManagerProtocol
    private let dateFormatter = DateFormatter()
    var sections = [Section]()

    init(rocket: Rocket, dataManager: DataManagerProtocol) {
        self.rocket = rocket
        self.dataManager = dataManager
    }

    func getSections() -> [Section] {
        sections
    }

    func getRocketInfo() -> Rocket {
        rocket
    }

    func setupData() {

        dateFormatter.dateFormat = "d MMMM, yyyy"

        let height = dataManager.getSelectedIndex(for: 0) == .metric
        ? String(rocket.height.meters)
        : String(rocket.height.feet)

        let diameter = dataManager.getSelectedIndex(for: 1) == .metric
        ? String(rocket.diameter.meters)
        : String(rocket.diameter.feet)

        let mass = dataManager.getSelectedIndex(for: 2) == .metric
        ? String(rocket.mass.kg)
        : String(rocket.mass.lb)

        let payloadWeights = dataManager.getSelectedIndex(for: 3) == .metric
        ? String(rocket.payloadWeights[0].kg)
        : String(rocket.payloadWeights[0].lb)

        let burnTimeFirstStage: String
        let burnTimeSecondStage: String

        if let burnTime = rocket.firstStage.burnTimeSec {
            burnTimeFirstStage = String(burnTime) + " " + Constants.sec.rawValue
        } else {
            burnTimeFirstStage = Constants.noData.rawValue
        }

        if let burnTime = rocket.secondStage.burnTimeSec {
            burnTimeSecondStage = String(burnTime) + " " + Constants.sec.rawValue
        } else {
            burnTimeSecondStage = Constants.noData.rawValue
        }

        let headSection = Section(type: .header, items: [
            .header(rocket.flickrImages[Int.random(in: 0...rocket.flickrImages.count - 1)], rocket.name)])

        let horizontalSection = Section(type: .horizontal, items: [
            .info(dataManager.getSelectedIndex(for: 0) == .metric ? .heightMetric : .heightImperial, height),
            .info(dataManager.getSelectedIndex(for: 1) == .metric ? .diameterMetric : .diameterImperial, diameter),
            .info(dataManager.getSelectedIndex(for: 2) == .metric ? .massMetric : .massImperial, mass),
            .info(dataManager.getSelectedIndex(for: 3) == .metric ? .payloadWeightsMetric : .payloadWeightsImperial, payloadWeights)])

        let infoSection = Section(type: .vertical, items: [
            .info(.firstFlight, dateFormatter.string(from: rocket.firstFlight)),
            .info(.country, rocket.country),
            .info(.costPerLaunch,
                  "$" + String(format: "%.0f", Double(rocket.costPerLaunch) / 1000000) + " " + Constants.million.rawValue
                 )])

        let firstStageSection = Section(title: Constants.firstStage.rawValue, type: .vertical, items: [
            .info(.engines, String(rocket.firstStage.engines)),
            .info(.fuelAmountTons, String(format: "%.0f", rocket.firstStage.fuelAmountTons) + " " + Constants.ton.rawValue),
            .info(.burnTimeSec, burnTimeFirstStage)])

        let secondStageSection = Section(title: Constants.secondStage.rawValue, type: .vertical, items: [
            .info(.engines, String(rocket.secondStage.engines)),
            .info(.fuelAmountTons, String(format: "%.0f", rocket.secondStage.fuelAmountTons) + " " + Constants.ton.rawValue),
            .info(.burnTimeSec, burnTimeSecondStage)])

        let buttonSection = Section(type: .button, items: [.button])

        sections = [headSection, horizontalSection, infoSection, firstStageSection, secondStageSection, buttonSection]
    }
}
