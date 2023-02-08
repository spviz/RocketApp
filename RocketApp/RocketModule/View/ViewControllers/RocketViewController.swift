//
//  RocketViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import UIKit

protocol RocketViewProtocol: AnyObject {
    func present(sections: [Section])
}

final class RocketViewController: UIViewController {

    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    private let presenter: RocketPresenterProtocol
    private var sections = [Section]()

    var presentSettingsClosure: (() -> Void)?
    var pushLaunchesClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCollectionView()
    }

    init(presenter: RocketPresenterProtocol) {
        self.presenter = presenter
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionView()
    }

    func reloadCollectionView() {
        presenter.getData()
    }
}

// MARK: - RocketViewProtocol

extension RocketViewController: RocketViewProtocol {
    func present(sections: [Section]) {
        self.sections = sections
        applySnapshot()
    }
}

// MARK: - Configure CollectionView

private extension RocketViewController {
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
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
        return collectionView
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, ItemType> {
        let dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in

                switch itemIdentifier {

                case let .header(url, name):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell
                    cell?.configure(with: url, name: name)
                    cell?.onPresentSettings = {
                        self.presentSettingsClosure?()
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
                    cell?.onPushLaunches = {
                        self.pushLaunchesClosure?()
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
