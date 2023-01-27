//
//  LaunchesViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 18.01.2023.
//

import UIKit

final class LaunchesViewController: UIViewController {

    private let networkManager: NetworkManagerProtocol
    private let activityIndicator = UIActivityIndicatorView()
    private var collectionView: UICollectionView!
    private var launches: Launch?
    var selectedRocketID: String?
    var selectedRocketName: String?

    init(network: NetworkManagerProtocol) {
        self.networkManager = network
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getLaunches()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }

    private func getLaunches() {
        guard let selectedRocket = selectedRocketID else { return }

        networkManager.getLaunches(for: selectedRocket) { result in
            switch result {
            case .success(let launches):
                self.launches = launches
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure(let failure):
                let alert = UIAlertController(title: "Error", message: failure.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension LaunchesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launches?.docs.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LaunchesCell.identifier,
            for: indexPath
        ) as? LaunchesCell else { return UICollectionViewCell() }

        if let launch = launches?.docs[indexPath.row] {
            if let image = UIImage(named: (launch.success ?? false) ? "rocket_true": "rocket_false") {
                DispatchQueue.main.async {
                    cell.configureValues(
                        for: launch.name,
                        date: launch.dateUtc,
                        image: image
                    )
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LaunchesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 311, height: 100)
    }
}

// MARK: - Configure UI

private extension LaunchesViewController {
    func configureUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(white: 0, alpha: 0)
        navigationItem.title = selectedRocketName

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LaunchesCell.self, forCellWithReuseIdentifier: LaunchesCell.identifier)

        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.color = .white

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
}
