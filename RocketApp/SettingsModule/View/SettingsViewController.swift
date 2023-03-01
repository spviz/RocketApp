//
//  SettingsViewController.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func present(settings: [Settings])
}

final class SettingsViewController: UIViewController {

    private enum Constants: String {
        case headerLabel = "Настройки"
        case closeButton = "Закрыть"
    }

    private let headerLabel = UILabel()
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let presenter: SettingsPresenterProtocol
    private var settings = [Settings]()

    var onChangeSettings: (() -> Void)?

    init(presenter: SettingsPresenterProtocol) {
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

    @objc private func closeButtonPressed() {
        dismiss(animated: true)
        onChangeSettings?()
    }
}

// MARK: - SettingsViewProtocol

extension SettingsViewController: SettingsViewProtocol {
    func present(settings: [Settings]) {
        self.settings = settings
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.identifier,
            for: indexPath
        ) as? SettingsCell else { return UITableViewCell()}

        cell.configureElements(with: settings[indexPath.row])
        let setting = self.settings[indexPath.row]
        cell.onChangeUnits = { [weak self] index in
            self?.presenter.setSettings(setting: setting.settingType, selectedUnit: SelectedUnit(rawValue: index) ?? .metric)
        }
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

private extension SettingsViewController {
    func configureUI() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.settingsBackgroundColor
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

        view.backgroundColor = Colors.settingsBackgroundColor
        view.addSubview(tableView)
        view.addSubview(headerLabel)
        view.addSubview(closeButton)
    }

    func createConstraints() {
        headerLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true

        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        closeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
    }
}
