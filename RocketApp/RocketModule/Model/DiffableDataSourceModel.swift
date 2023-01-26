//
//  DiffableDataSourceModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import Foundation

struct Section: Hashable {
    var title: String?
    let type: SectionType
    let items: [ItemType]

    enum SectionType {
        case header
        case horizontal
        case vertical
        case button
    }
}

enum ItemType: Hashable {
    case header(URL, String)
    case info(ParametersName, String, UUID = UUID())
    case button
}
