//
//  NetworkManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getRockets(completionHandler: @escaping (Result<[Rocket], Error>) -> Void)
    func getLaunches(for rocketID: String, completionHandler: @escaping (Result<Launch, Error>) -> Void)
}

enum API {
    static let rockets = "https://api.spacexdata.com/v4/rockets"
    static let launches = "https://api.spacexdata.com/v4/launches/query/"
}

enum NetworkError: Error {
    case decodingError
    case serverError
}

final class NetworkManager: NetworkManagerProtocol {

    private let session: URLSession

    private let rocketsDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()

    private let launchesDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getRockets(completionHandler: @escaping (Result<[Rocket], Error>) -> Void) {

        guard let url = URL(string: API.rockets) else { return }

        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                completionHandler(.failure(NetworkError.serverError))
                return
            }

            if let data = data, let rocket = try? self.rocketsDecoder.decode([Rocket].self, from: data) {
                completionHandler(.success(rocket))
            } else {
                completionHandler(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }

    func getLaunches(for rocketID: String, completionHandler: @escaping (Result<Launch, Error>) -> Void) {

        guard let url = URL(string: API.launches) else { return }

        let body = LaunchRequest(query: .init(rocket: rocketID, upcoming: false), options: .init(limit: 200, sort: "-date_local"))
        let bodyData = try? JSONEncoder().encode(body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                completionHandler(.failure(NetworkError.serverError))
                return
            }

            if let data = data, let launches = try? self.launchesDecoder.decode(Launch.self, from: data) {
                completionHandler(.success(launches))
            } else {
                completionHandler(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}
