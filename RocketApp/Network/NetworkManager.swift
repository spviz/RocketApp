//
//  NetworkManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

private enum API {
    static let rockets = "https://api.spacexdata.com/v4/rockets"
    static let launches = "https://api.spacexdata.com/v4/launches/query/"
}

private enum NetworkError: Error {
    case invalidURL
    case invalidState
    case serverError
}

final class NetworkManager {
    
    private let getRocketsDecoder : JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    private let getLaunchesDecoder : JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    func getRockets(completionHandler: @escaping (Result<[Rocket], Error>) -> Void) {
        
        guard let url = URL(string: API.rockets) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completionHandler(.failure(NetworkError.serverError))
            }
                        
            if let data = data, let rocket = try? self.getRocketsDecoder.decode([Rocket].self, from: data) {
                completionHandler(.success(rocket))
            } else {
                completionHandler(.failure(NetworkError.invalidState))
            }
        }
        task.resume()
    }

    func getLaunches(for rocketID: String, completionHandler: @escaping (Result<Launch, Error>) -> Void) {
        
        guard let url = URL(string: API.launches) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        
        let body = LaunchRequest(query: .init(rocket: rocketID, upcoming: false))
        let bodyData = try? JSONEncoder().encode(body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completionHandler(.failure(NetworkError.serverError))
            }
                       
            if let data = data, let launches = try? self.getLaunchesDecoder.decode(Launch.self, from: data) {
                completionHandler(.success(launches))
            } else {
                completionHandler(.failure(NetworkError.invalidState))
            }
        }
        task.resume()
    }
}
