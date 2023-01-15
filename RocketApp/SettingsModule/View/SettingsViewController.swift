//
//  SettingsViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    private enum Constants: String {
        case headerLabel = "Настройки"
        case closeButton = "Закрыть"
    }

    private var headerLabel = UILabel()
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createHeaderLabelConstrains()
        createTableViewConstraints()
        createCloseButtonConstraints()
    }

    @objc
    private func closeButtonPressed() {
        dismiss(animated: true)
    }
    @objc
    private func setSettings(sender: UISegmentedControl) {
        dataManager.setSettings(for: sender.tag, selectedIndex: sender.selectedSegmentIndex)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataManager.settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else { return UITableViewCell()}

        cell.configureParameterName(with: dataManager.settings[indexPath.row])
        cell.configureUnits(with: dataManager.settings[indexPath.row])
        cell.configureCell()

        cell.unitsSelector.tag = indexPath.row
        cell.unitsSelector.addTarget(self, action: #selector(setSettings), for: .valueChanged)
        cell.unitsSelector.selectedSegmentIndex = dataManager.getSettings(for: indexPath.row)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}

// MARK: - Configure UI

extension SettingsViewController {
    private func configureUI() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.text = Constants.headerLabel.rawValue
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle(Constants.closeButton.rawValue, for: .normal)
        closeButton.setTitleColor(.lightGray, for: .highlighted)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)

        view.backgroundColor = .black
        view.addSubview(tableView)
        view.addSubview(headerLabel)
        view.addSubview(closeButton)
    }
}

// MARK: - Create Constraints

extension SettingsViewController {
    private func createHeaderLabelConstrains() {
        headerLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
    }
    private func createTableViewConstraints() {
        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    private func createCloseButtonConstraints() {
        closeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
    }
}
