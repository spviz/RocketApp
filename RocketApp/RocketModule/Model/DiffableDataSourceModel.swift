//
//  DiffableDataSourceModel.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 21.01.2023.
//

import Foundation

struct Section: Hashable {
    let title: String?
    let type: SectionType
    let items: [ItemType]

    init(title: String? = nil, type: SectionType, items: [ItemType]) {
        self.title = title
        self.type = type
        self.items = items
    }

    enum SectionType {
        case header
        case horizontal
        case vertical
        case button
    }
}

enum ItemType: Hashable {
    case header(URL, String)
    case info(ParameterItemName, String, UUID = UUID())
    case button
}
