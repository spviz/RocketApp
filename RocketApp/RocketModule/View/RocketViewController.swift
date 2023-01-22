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

    private var rocket: Rocket
    private var networkManager: NetworkManagerProtocol
    private var dataManager: DataManagerProtocol

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var sections = [Section(type: .parameters, items: [.init(parameterName: .height),
                                                                .init(parameterName: .diameter),
                                                                .init(parameterName: .mass),
                                                                .init(parameterName: .payloadWeights)]),
                            Section(type: .rocketInfo, items: [.init(rocketInfoName: .firstFlight),
                                                                .init(rocketInfoName: .country),
                                                                .init(rocketInfoName: .costPerLaunch)]),
                            Section(type: .firstStageInfo, items: [.init(firstStageInfoName: .engines),
                                                                    .init(firstStageInfoName: .fuelAmountTons),
                                                                    .init(firstStageInfoName: .burnTimeSEC)]),
                            Section(type: .secondStageInfo, items: [.init(secondStageInfoName: .engines),
                                                                     .init(secondStageInfoName: .fuelAmountTons),
                                                                     .init(secondStageInfoName: .burnTimeSEC)])
    ]

    private let rocketImage = UIImageView()
    private let characteristicsView = UIView()
    private let settingsButton = UIButton()
    private let launchesButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        createDataSource()
        reloadData()
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

// MARK: - Configure CollectionView
extension RocketViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(settingsButton)

        collectionView.register(ParametersCell.self, forCellWithReuseIdentifier: ParametersCell.identifier)
        collectionView.register(RocketInfoCell.self, forCellWithReuseIdentifier: RocketInfoCell.identifier)
    }
    func createCompositionalLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]

            switch section.type {
            case .parameters:
                return self.createCharacteristicsSection()
            default:
                return self.createRocketInfoSection()
            }
        }

        return layout
    }

    func createCharacteristicsSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(114), heightDimension: .absolute(114))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets.init(top: 6, leading: 6, bottom: 6, trailing: 6)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 32, bottom: 0, trailing: 0)
        return section
    }

    func createRocketInfoSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 0, bottom: 0, trailing: 8)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 40, leading: 32, bottom: 0, trailing: 32)
        return section
    }

    func createDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

            switch self.sections[indexPath.section].type {
            case .parameters:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParametersCell.identifier, for: indexPath) as? ParametersCell
                cell?.configureElements(parameter: item, rocket: self.rocket, selectedUnit: self.dataManager.getSelectedIndex(for: indexPath.row))
                return cell

            case .rocketInfo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RocketInfoCell.identifier, for: indexPath) as? RocketInfoCell
                cell?.configureElements(item: item, rocket: self.rocket, sectionType: .rocketInfo)
                return cell

            case.firstStageInfo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RocketInfoCell.identifier, for: indexPath) as? RocketInfoCell
                cell?.configureElements(item: item, rocket: self.rocket, sectionType: .firstStageInfo)
                return cell
            case.secondStageInfo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RocketInfoCell.identifier, for: indexPath) as? RocketInfoCell
                cell?.configureElements(item: item, rocket: self.rocket, sectionType: .secondStageInfo)
                return cell
            }
        })
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }
}

// MARK: - Configure UI

private extension RocketViewController {
    func configureUI() {
        settingsButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        settingsButton.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
        settingsButton.center = view.center

        launchesButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        launchesButton.setTitle("Посмотреть запуски", for: .normal)
        launchesButton.backgroundColor = .lightGray
        launchesButton.layer.cornerRadius = 10
        launchesButton.addTarget(self, action: #selector(pushLaunches), for: .touchUpInside)

        view.backgroundColor = .lightGray

        createConstraints()
    }
}
// MARK: - Novigation Methods

private extension RocketViewController {
    @objc func presentSettings() {
        let settingsViewController = SettingsViewController(dataManager: DataManager())
        settingsViewController.delegate = self
        present(settingsViewController, animated: true)
    }

    @objc func pushLaunches() {
        let launchesViewController = LaunchesViewController(network: networkManager)
        launchesViewController.selectedRocketID = rocket.id
        launchesViewController.selectedRocketName = rocket.name
        self.navigationController?.pushViewController(launchesViewController, animated: true)
    }
}

// MARK: - Create Constraints
private extension RocketViewController {
    func createConstraints() {

    }
}
