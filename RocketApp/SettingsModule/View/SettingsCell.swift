//
//  SettingsCell.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 12.01.2023.
//

import UIKit

final class SettingsCell: UITableViewCell {

    private var unitsSelector = UISegmentedControl()
    var label = UILabel()
    var onChangeUnitsSelector: ((Int) -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
        createSwitcherConstraints()
        createLabelConstraints()
    }

    @objc func tapUnitsSelector(sender: UISegmentedControl) {
        onChangeUnitsSelector?(sender.selectedSegmentIndex)
    }

    // MARK: - Configure UI
    private func configureCell() {

        unitsSelector.addTarget(self, action: #selector(tapUnitsSelector), for: .valueChanged)
        contentView.backgroundColor = .black
        contentView.addSubview(unitsSelector)
        contentView.addSubview(label)
    }

    func configureElements(with settings: Settings, selectedIndex: Int) {

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = settings.parameterName.rawValue
        label.textColor = .white

        unitsSelector = UISegmentedControl(items: [settings.units[0].rawValue, settings.units[1].rawValue])
        unitsSelector.tintColor = .white
        unitsSelector.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        unitsSelector.translatesAutoresizingMaskIntoConstraints = false
        unitsSelector.selectedSegmentIndex = selectedIndex
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
