//
//  RocketPresenterTests.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 01.03.2023.
//

import XCTest
@testable import RocketApp

final class RocketPresenterTests: XCTestCase {

    private var presenter: RocketPresenter!
    private var mockView: RocketMockView!
    private var dataManager = MockDataManager()

    override func setUp() {
        super.setUp()

        let rocket = Rocket(
            flickrImages: [URL(string: "https://imgur.com/DaCfMsj.jpg")!],
            name: "rocketName",
            height: .init(meters: 1, feet: 2),
            diameter: .init(meters: 3, feet: 4),
            mass: .init(kg: 5, lb: 6),
            payloadWeights: [.init(kg: 7, lb: 8)],
            firstFlight: Date(timeIntervalSince1970: 0),
            country: "USA",
            costPerLaunch: 1000000,
            firstStage: .init(engines: 9, fuelAmountTons: 10, burnTimeSec: 11),
            secondStage: .init(engines: 12, fuelAmountTons: 13, burnTimeSec: 14),
            id: "rocketID"
        )

        presenter = RocketPresenter(rocket: rocket)
        mockView = RocketMockView()
        presenter.rocketView = mockView
        presenter.dataManager = dataManager

    }

    func testGetDataForMetric() {
        dataManager.selectedUnit = .metric
        presenter.getData()

        let headSection = Section(type: .header, items: [
            .header(URL(string: "https://imgur.com/DaCfMsj.jpg")!, "rocketName")])

        let horizontalSection = Section(type: .horizontal, items: [
            .info(.heightMetric, "1.0"),
            .info(.diameterMetric, "3.0"),
            .info(.massMetric, "5"),
            .info(.payloadWeightsMetric, "7")])

        let infoSection = Section(type: .vertical, items: [
            .info(.firstFlight, "1 января, 1970"),
            .info(.country, "USA"),
            .info(.costPerLaunch, "$1 млн")
        ])

        let firstStageSection = Section(title: "firstStageSection", type: .vertical, items: [
            .info(.engines, "9"),
            .info(.fuelAmountTons, "10 ton"),
            .info(.burnTimeSec, "11 sec")
        ])

        let secondStageSection = Section(title: "secondStageSection", type: .vertical, items: [
            .info(.engines, "12"),
            .info(.fuelAmountTons, "13 ton"),
            .info(.burnTimeSec, "14 sec")
        ])

        let buttonSection = Section(type: .button, items: [.button])

        let sections = mockView.sections
        let sectionsMock = [headSection, horizontalSection, infoSection, firstStageSection, secondStageSection, buttonSection]

        for i in 0...sections.count - 1 {
            for (element1, element2) in zip( sections[i].items, sectionsMock[i].items) {
                switch (element1, element2) {

                case let (.info(item1, title1, _), .info(item2, title2, _)):
                    XCTAssertEqual(item1, item2)
                    XCTAssertEqual(title1, title2)

                case let (.header(url1, title1), .header(url2, title2)):
                    XCTAssertEqual(url1, url2)
                    XCTAssertEqual(title1, title2)

                case (.button, .button):
                    XCTAssertEqual(element1, element2)

                default:
                    XCTFail("Unexpected result")
                }
            }
        }
    }

    func testGetDataForImperial() {
        dataManager.selectedUnit = .imperial
        presenter.getData()

        let horizontalSection = Section(type: .horizontal, items: [
            .info(.heightImperial, "2.0"),
            .info(.diameterImperial, "4.0"),
            .info(.massImperial, "6"),
            .info(.payloadWeightsImperial, "8")])

        let section = mockView.sections[1]

        for (element1, element2) in zip( section.items, horizontalSection.items) {
            switch (element1, element2) {
            case let (.info(item1, title1, _), .info(item2, title2, _)):
                XCTAssertEqual(item1, item2)
                XCTAssertEqual(title1, title2)
            default:
                XCTFail("Unexpected result")
            }
        }
    }

    func testGetDataWithNoBurnTime() {

        dataManager.selectedUnit = .metric
        presenter.rocket.firstStage.burnTimeSec = nil
        presenter.rocket.secondStage.burnTimeSec = nil
        presenter.getData()

        let firstStageSection = Section(title: "firstStageSection", type: .vertical, items: [
            .info(.engines, "9"),
            .info(.fuelAmountTons, "10 ton"),
            .info(.burnTimeSec, "Нет данных")
        ])

        let secondStageSection = Section(title: "secondStageSection", type: .vertical, items: [
            .info(.engines, "12"),
            .info(.fuelAmountTons, "13 ton"),
            .info(.burnTimeSec, "Нет данных")
        ])

        let sections = [mockView.sections[3], mockView.sections[4]]
        let mockSections = [firstStageSection, secondStageSection]

        for i in 0..<sections.count {
            for (element1, element2) in zip( sections[i].items, mockSections[i].items) {
                switch (element1, element2) {

                case let (.info(item1, title1, _), .info(item2, title2, _)):
                    XCTAssertEqual(item1, item2)
                    XCTAssertEqual(title1, title2)
                default:
                    XCTFail("Unexpected result")
                }
            }
        }
    }
}

// MARK: - MockView

private extension RocketPresenterTests {
    final class RocketMockView: RocketViewProtocol {

        var sections = [Section]()

        func present(sections: [Section]) {
            self.sections = sections

        }
    }
}
