//
//  LaunchesViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 18.01.2023.
//

import UIKit

protocol LaunchesViewProtocol: AnyObject {
    func present(launchesInfo: LaunchesInfo)
    func present(alert: Error)
}

final class LaunchesViewController: UIViewController {

    private lazy var collectionView = UICollectionView()
    private let activityIndicator = UIActivityIndicatorView()
    private let noLaunchesLabel = UILabel()
    private var rocketName = String()
    private var launchesArray = [LaunchItem]()
    private let presenter: LaunchesPresenterProtocol

    init(presenter: LaunchesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createConstraints()
        presenter.getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
}

// MARK: - LaunchesViewProtocol

extension LaunchesViewController: LaunchesViewProtocol {
    func present(launchesInfo: LaunchesInfo) {
        launchesArray = launchesInfo.launches

        DispatchQueue.main.async {
            self.navigationItem.title = launchesInfo.rocketName
            self.noLaunchesLabel.text = "There are no launches for \(launchesInfo.rocketName) yet..."
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.noLaunchesLabel.isHidden = !self.launchesArray.isEmpty
        }
    }

    func present(alert: Error) {
        let alert = UIAlertController(title: "Error", message: alert.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource

extension LaunchesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launchesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LaunchesCell.identifier,
            for: indexPath
        ) as? LaunchesCell else { return UICollectionViewCell() }

        guard let image = UIImage(named: launchesArray[indexPath.row].imageName) else { return UICollectionViewCell()}
        cell.configureValues(
            name: launchesArray[indexPath.row].name,
            date: launchesArray[indexPath.row].date,
            image: image
        )
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

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LaunchesCell.self, forCellWithReuseIdentifier: LaunchesCell.identifier)

        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.color = .white

        noLaunchesLabel.layer.backgroundColor = CGColor(gray: 0.1, alpha: 1)
        noLaunchesLabel.numberOfLines = 0
        noLaunchesLabel.font = .systemFont(ofSize: 20)
        noLaunchesLabel.textColor = .white
        noLaunchesLabel.translatesAutoresizingMaskIntoConstraints = false
        noLaunchesLabel.layer.cornerRadius = 20
        noLaunchesLabel.textAlignment = .center
        noLaunchesLabel.isHidden = true

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(noLaunchesLabel)
    }

    func createConstraints() {
        noLaunchesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        noLaunchesLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        noLaunchesLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noLaunchesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
