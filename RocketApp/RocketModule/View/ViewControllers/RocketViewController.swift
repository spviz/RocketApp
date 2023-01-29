//
//  RocketViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

final class RocketViewController: UIViewController {

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

    private lazy var collectionView = UICollectionView()
    private lazy var dataSource = setupDataSource()
    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
        applySnapshot()
    }

    init(rocket: Rocket, dataManager: DataManagerProtocol) {
        self.rocket = rocket
        self.dataManager = dataManager
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadCollectionView() {
        setupData()
        applySnapshot()
    }
}

// MARK: - Configure Data

private extension RocketViewController {
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

// MARK: - Configure CollectionView

private extension RocketViewController {
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
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
    }

    func setupDataSource() -> UICollectionViewDiffableDataSource<Section, ItemType> {
        let dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in

            switch itemIdentifier {

            case let .header(url, name):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell
                cell?.configure(with: url, name: name)
                cell?.onPresentSettings = {
                    self.presentSettings()
                }
                return cell

            case let .info(name, value, _):
                if self.sections[indexPath.section].type == .horizontal {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCell.identifier, for: indexPath) as? HorizontalCell
                    cell?.configure(with: name.rawValue, value: value)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.identifier, for: indexPath) as? VerticalCell
                    cell?.configure(with: name.rawValue, value: value)
                    return cell
                }

            case .button:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell
                cell?.onPushLaunches = { [weak self] in
                    self?.pushLaunches()
                }
                return cell
            }
        })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.identifier,
                for: indexPath
            ) as? SectionHeader else { return nil }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if let title = section.title {
                sectionHeader.configure(with: title)
            }
            return sectionHeader
        }
        return dataSource
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot)
    }
}

// MARK: - Create Layouts

private extension RocketViewController {
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

// MARK: - Navigation Methods

extension RocketViewController {
    func presentSettings() {
        let settingsViewController = SettingsViewController(dataManager: dataManager)
        settingsViewController.reloadData = { [weak self] in
            self?.reloadCollectionView()
        }
        present(settingsViewController, animated: true)
    }

    func pushLaunches() {
        let launchesViewController = LaunchesViewController(network: NetworkManager())
        launchesViewController.selectedRocketID = rocket.id
        launchesViewController.selectedRocketName = rocket.name
        self.navigationController?.pushViewController(launchesViewController, animated: true)
    }
}
