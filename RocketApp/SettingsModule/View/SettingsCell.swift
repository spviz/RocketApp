//
//  SettingsCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import UIKit

final class SettingsCell: UITableViewCell {

    private let unitsSelector = UISegmentedControl()
    private let label = UILabel()
    var onChangeUnitsSelector: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapUnitsSelector(sender: UISegmentedControl) {
        onChangeUnitsSelector?(sender.selectedSegmentIndex)
    }
}

// MARK: - Configure UI

extension SettingsCell {
    private func configureCell() {

        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        unitsSelector.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        unitsSelector.addTarget(self, action: #selector(tapUnitsSelector), for: .valueChanged)
        unitsSelector.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = .black
        contentView.addSubview(unitsSelector)
        contentView.addSubview(label)

        createConstraints()
    }

    func configureElements(with settings: Settings, selectedIndex: Int) {

        label.text = settings.parameterName.rawValue
        unitsSelector.insertSegment(withTitle: settings.units[0].rawValue, at: 0, animated: false)
        unitsSelector.insertSegment(withTitle: settings.units[1].rawValue, at: 1, animated: false)
        unitsSelector.selectedSegmentIndex = selectedIndex
    }

}

// MARK: - Create Constraints

extension SettingsCell {
    private func createConstraints() {

        unitsSelector.widthAnchor.constraint(equalToConstant: 115).isActive = true
        unitsSelector.heightAnchor.constraint(equalToConstant: 40).isActive = true
        unitsSelector.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -28).isActive = true
        unitsSelector.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: unitsSelector.leftAnchor, constant: 20).isActive = true
    }
}
