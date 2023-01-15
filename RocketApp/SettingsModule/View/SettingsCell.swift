//
//  SettingsCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import UIKit

final class SettingsCell: UITableViewCell {

    static let identifier = "SettingsCell"

    var unitsSelector = UISegmentedControl()
    private var label = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        createSwitcherConstraints()
        createLabelConstraints()
    }

    // MARK: - Configure UI
    public func configureParameterName(with settings: Settings) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = settings.parameterName.rawValue
        label.textColor = .white
    }

    public func configureUnits(with settings: Settings) {
        unitsSelector = UISegmentedControl(items: [settings.units[0].rawValue, settings.units[1].rawValue])
        unitsSelector.tintColor = .white
        unitsSelector.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        unitsSelector.translatesAutoresizingMaskIntoConstraints = false
    }
    public func configureCell() {
        contentView.backgroundColor = .black
        contentView.addSubview(unitsSelector)
        contentView.addSubview(label)
    }

    // MARK: - Create Constraints

    private func createSwitcherConstraints() {
        unitsSelector.widthAnchor.constraint(equalToConstant: 115).isActive = true
        unitsSelector.heightAnchor.constraint(equalToConstant: 40).isActive = true
        unitsSelector.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -28).isActive = true
        unitsSelector.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    private func createLabelConstraints() {
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: unitsSelector.leftAnchor, constant: 20).isActive = true
    }
}
