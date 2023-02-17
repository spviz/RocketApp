//
//  BundleExtension.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 15.02.2023.
//

import Foundation

extension Bundle {
    func getJSON(filename: String) -> Data {
        guard let url = url(forResource: filename, withExtension: "json"), let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(filename) from app bundle.")
        }
        return data
    }
}
