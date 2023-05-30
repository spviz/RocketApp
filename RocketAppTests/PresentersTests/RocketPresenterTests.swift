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
    private var mockDataManager: MockDataManager!

    override func setUp() {
        super.setUp()
        mockView = RocketMockView()
        mockDataManager = MockDataManager()
    }

    func testGetDataForMetric() {

        presenter = RocketPresenter(rocket: makeStubRocket(burnTimeSec: 20), dataManager: mockDataManager)
        presenter.rocketView = mockView

        mockDataManager.selectedUnit = .metric
        presenter.getData()

        let headSection = Section(type: .header, items: [
            .header(URL(string: TestConstants.url.rawValue)!, TestConstants.rocketName.rawValue)])

        let horizontalSection = Section(type: .horizontal, items: [
            .info(.heightMetric, TestConstants.checkNumberDouble.rawValue),
            .info(.diameterMetric, TestConstants.checkNumberDouble.rawValue),
            .info(.massMetric, TestConstants.checkNumberInt.rawValue),
            .info(.payloadWeightsMetric, TestConstants.checkNumberInt.rawValue)])

        let infoSection = Section(type: .vertical, items: [
            .info(.firstFlight, TestConstants.date.rawValue),
            .info(.country, TestConstants.country.rawValue),
            .info(.costPerLaunch, TestConstants.million.rawValue)
        ])

        let firstStageSection = Section(title: TestConstants.firstStageSection.rawValue, type: .vertical, items: [
            .info(.engines, TestConstants.checkNumberInt.rawValue),
            .info(.fuelAmountTons, TestConstants.checkFuel.rawValue),
            .info(.burnTimeSec, TestConstants.checkSec.rawValue)
        ])

        let secondStageSection = Section(title: TestConstants.secondStageSection.rawValue, type: .vertical, items: [
            .info(.engines, TestConstants.checkNumberInt.rawValue),
            .info(.fuelAmountTons, TestConstants.checkFuel.rawValue),
            .info(.burnTimeSec, TestConstants.checkSec.rawValue)
        ])

        let buttonSection = Section(type: .button, items: [.button])

        let sections = mockView.sections
        let actualSections = [headSection, horizontalSection, infoSection, firstStageSection, secondStageSection, buttonSection]

        compareSection(sections, actualSections)
    }

    func testGetDataForImperial() {

        presenter = RocketPresenter(rocket: makeStubRocket(burnTimeSec: 20), dataManager: mockDataManager)
        presenter.rocketView = mockView

        mockDataManager.selectedUnit = .imperial
        presenter.getData()

        let sections = [mockView.sections[1]]
        let actualSections = [Section(type: .horizontal, items: [
            .info(.heightImperial, TestConstants.checkNumberDouble.rawValue),
            .info(.diameterImperial, TestConstants.checkNumberDouble.rawValue),
            .info(.massImperial, TestConstants.checkNumberInt.rawValue),
            .info(.payloadWeightsImperial, TestConstants.checkNumberInt.rawValue)
        ])]

        compareSection(sections, actualSections)
    }

    func testGetDataWithNoBurnTime() {

        presenter = RocketPresenter(rocket: makeStubRocket(burnTimeSec: nil), dataManager: mockDataManager)
        presenter.rocketView = mockView

        mockDataManager.selectedUnit = .metric
        presenter.getData()

        let firstStageSection = Section(title: TestConstants.firstStageSection.rawValue, type: .vertical, items: [
            .info(.engines, TestConstants.checkNumberInt.rawValue),
            .info(.fuelAmountTons, TestConstants.checkFuel.rawValue),
            .info(.burnTimeSec, TestConstants.noData.rawValue)
        ])

        let secondStageSection = Section(title: TestConstants.firstStageSection.rawValue, type: .vertical, items: [
            .info(.engines, TestConstants.checkNumberInt.rawValue),
            .info(.fuelAmountTons, TestConstants.checkFuel.rawValue),
            .info(.burnTimeSec, TestConstants.noData.rawValue)
        ])

        let sections = [mockView.sections[3], mockView.sections[4]]
        let actualSections = [firstStageSection, secondStageSection]

        compareSection(sections, actualSections)
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

// MARK: - functions

private extension RocketPresenterTests {
    func makeStubRocket(burnTimeSec: Int?) -> Rocket {
        let rocket = Rocket(
            flickrImages: [URL(string: TestConstants.url.rawValue)!],
            name: TestConstants.rocketName.rawValue,
            height: .init(meters: 20, feet: 20),
            diameter: .init(meters: 20, feet: 20),
            mass: .init(kg: 20, lb: 20),
            payloadWeights: [.init(kg: 20, lb: 20)],
            firstFlight: Date(timeIntervalSince1970: 0),
            country: TestConstants.country.rawValue,
            costPerLaunch: 1000000,
            firstStage: .init(engines: 20, fuelAmountTons: 20, burnTimeSec: burnTimeSec),
            secondStage: .init(engines: 20, fuelAmountTons: 20, burnTimeSec: burnTimeSec),
            id: TestConstants.rocketId.rawValue
        )
        return rocket
    }

    // this is needed because of the UUID in the model
    func compareSection(_ section1: [Section], _ section2: [Section]) {

        for (section1, section2) in zip(section1, section2) {
            for (element1, element2) in zip( section1.items, section2.items) {
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
                    XCTFail(TestConstants.unexpectedResult.rawValue)
                }
            }
        }
    }
}
