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
}

final class NetworkManager {
    
    private let decoder = JSONDecoder()
    
    private let formatterFirstFlight: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let formatterLaunchDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    //MARK: - getRockets
    func getRockets(completionHandler: @escaping (Result<[Rocket], Error>) -> Void) {
        
        guard let url = URL(string: API.rockets) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            self.decoder.dateDecodingStrategy = .formatted(self.formatterFirstFlight)
            
            if let data = data, let rocket = try? self.decoder.decode([Rocket].self, from: data) {
                completionHandler(.success(rocket))
            } else {
                completionHandler(.failure(NetworkError.invalidState))
            }
        }
        task.resume()
    }
    
    //MARK: - getLaunches
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
            
            self.decoder.dateDecodingStrategy = .formatted(self.formatterLaunchDate)
           
            if let data = data, let launches = try? self.decoder.decode(Launch.self, from: data) {
                completionHandler(.success(launches))
            } else {
                completionHandler(.failure(NetworkError.invalidState))
            }
        }
        task.resume()
    }
}
