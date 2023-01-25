//
//  RocketViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

protocol RocketViewControllerDelegate: AnyObject {
    func reloadCollectionView()
}

final class RocketViewController: UIViewController, RocketViewControllerDelegate {

    private let rocket: Rocket
    private let networkManager: NetworkManagerProtocol
    private let dataManager: DataManagerProtocol
    private let dateFormatter = DateFormatter()

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemType>!
    private var sections: [Section]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
    }

    init(rocket: Rocket, networkManager: NetworkManagerProtocol, dataManager: DataManagerProtocol) {
        self.rocket = rocket
        self.networkManager = networkManager
        self.dataManager = dataManager
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

// MARK: - Configure Data
extension RocketViewController {
    func fetchData(for item: Parameters) -> String {

        dateFormatter.dateFormat = "d MMMM, yyyy"

        switch item {
        case .height:
            guard let rocketHeightMeters = rocket.height.meters, let rocketHeightFeet = rocket.height.feet  else {
                return "Нет данных"
            }
            switch dataManager.getSelectedIndex(for: 0) {
            case .metric: return String(rocketHeightMeters)
            case .imperial: return String(rocketHeightFeet)
            }
        case .diameter:
            guard let rocketDiameterMeters = rocket.diameter.meters, let rocketDiameterFeet = rocket.diameter.feet  else {
                return "Нет данных"
            }
            switch dataManager.getSelectedIndex(for: 1) {
            case .metric: return String(rocketDiameterMeters)
            case .imperial: return String(rocketDiameterFeet)
            }
        case .mass:
            switch dataManager.getSelectedIndex(for: 2) {
            case .metric: return String(rocket.mass.kg)
            case .imperial: return String(rocket.mass.lb)
            }
        case .payloadWeights:
            switch dataManager.getSelectedIndex(for: 3) {
            case .metric: return String(rocket.mass.kg)
            case .imperial: return String(rocket.mass.lb)
            }
        case .firstFlight:
            return dateFormatter.string(from: rocket.firstFlight)
        case .costPerLaunch:
            return String(rocket.costPerLaunch)
        case .enginesFirstStage:
            return String(rocket.firstStage.engines)
        case .fuelAmountTonsFirstStage:
            return String(rocket.firstStage.fuelAmountTons)
        case .burnTimeSecFirstStage:
            guard let burnTime = rocket.firstStage.burnTimeSec else { return "Нет данных" }
            return String(burnTime)
        case .enginesSecondStage:
            return String(rocket.secondStage.engines)
        case .fuelAmountTonsSecondStage:
            return String(rocket.secondStage.fuelAmountTons)
        case .burnTimeSecSecondStage:
            guard let burnTime = rocket.secondStage.burnTimeSec else { return "Нет данных" }
            return String(burnTime)

        default: return "Нет данных"
        }
    }

    func setupData() {

        let headSection = Section(title: nil, type: .header, items: [
            .header(rocket.flickrImages[Int.random(in: 0...1)], rocket.name)])

        let horizontalSection = Section(title: nil, type: .horizontal, items: [
            .info(.height, fetchData(for: .height), UUID()),
            .info(.diameter, fetchData(for: .diameter), UUID()),
            .info(.mass, fetchData(for: .mass), UUID()),
            .info(.payloadWeights, fetchData(for: .payloadWeights), UUID())])

        let infoSection = Section(title: nil, type: .vertical, items: [
            .info(.firstFlight, fetchData(for: .firstFlight), UUID()),
            .info(.country, rocket.country, UUID()),
            .info(.costPerLaunch, fetchData(for: .costPerLaunch), UUID())])

        let firstStageSection = Section(title: "ПЕРВАЯ СТУПЕНЬ", type: .vertical, items: [
            .info(.engines, fetchData(for: .enginesFirstStage), UUID()),
            .info(.fuelAmountTons, fetchData(for: .fuelAmountTonsFirstStage), UUID()),
            .info(.burnTimeSec, fetchData(for: .burnTimeSecFirstStage), UUID())])

        let secondStageSection = Section(title: "ВТОРАЯ СТУПЕНЬ", type: .vertical, items: [
            .info(.engines, fetchData(for: .enginesSecondStage), UUID()),
            .info(.fuelAmountTons, fetchData(for: .fuelAmountTonsSecondStage), UUID()),
            .info(.burnTimeSec, fetchData(for: .burnTimeSecSecondStage), UUID())])

        let buttonSection = Section(title: nil, type: .button, items: [.button])

        sections = [headSection, horizontalSection, infoSection, firstStageSection, secondStageSection, buttonSection]
    }
}

// MARK: - Configure CollectionView
extension RocketViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)

        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
        collectionView.register(HorizontalCell.self, forCellWithReuseIdentifier: HorizontalCell.identifier)
        collectionView.register(VerticalCell.self, forCellWithReuseIdentifier: VerticalCell.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)

        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)

        setupDataSource()
        createSnapshot()
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch self.sections![indexPath.section].type {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell else { return nil }
                cell.configure(item: itemIdentifier)
                cell.delegate = self
                return cell
            case .horizontal:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCell.identifier, for: indexPath) as? HorizontalCell else { return nil }
                cell.configure(with: itemIdentifier)
                return cell
            case .vertical:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.identifier, for: indexPath) as? VerticalCell else { return nil }
                cell.configure(for: itemIdentifier)
                return cell
            case .button:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell else { return nil }
                cell.delegate = self
                return cell
            }
        })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader else { return nil }
            guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self.dataSource.snapshot().sectionIdentifier(containingItem: item) else { return nil }
            if let title = section.title {
                sectionHeader.configureHeader(with: title)
            }
            return sectionHeader
        }
    }

    func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        guard let sections = sections else { return }
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot)
    }
}

// MARK: - Create Layouts
extension RocketViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch self.sections[sectionIndex].type {
            case .header:
                return self.createHeaderLayout()
            case .horizontal:
                return self.createHorizontalLayout()
            case .vertical:
                return self.createVerticalLayout()
            case .button:
                return self.createButtonLayout()
            }
        }
        return layout
    }

    func createHeaderLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(view.frame.width), heightDimension: .estimated(500))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func createHorizontalLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(96), heightDimension: .estimated(96))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 32, bottom: 20, trailing: 0)
        return section
    }

    func createVerticalLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 32, bottom: 40, trailing: 32)
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }

    func createButtonLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 32, bottom: 100, trailing: 32)
        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(24))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
                                                                              elementKind: UICollectionView.elementKindSectionHeader,
                                                                              alignment: .top)
        return layoutSectionHeader
    }

}

// MARK: - Novigation Methods

extension RocketViewController: HeaderCellDelegate {
    func presentSettings() {
        let settingsViewController = SettingsViewController(dataManager: dataManager)
        settingsViewController.delegate = self
        present(settingsViewController, animated: true)
    }
}
extension RocketViewController: ButtonCellDelegate {
    func pushLaunches() {
        let launchesViewController = LaunchesViewController(network: networkManager)
        launchesViewController.selectedRocketID = rocket.id
        launchesViewController.selectedRocketName = rocket.name
        self.navigationController?.pushViewController(launchesViewController, animated: true)
    }
}
