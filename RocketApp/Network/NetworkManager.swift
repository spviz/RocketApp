//
//  NetworkManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidState
}

final class NetworkManager {
    
    func getRockets(from urlString: String, complitionHandler: @escaping (Result<[RocketElement], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            complitionHandler(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
//      decoder.dateDecodingStrategy = .deferredToDate
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let rocket = try? decoder.decode([RocketElement].self, from: data) {
                complitionHandler(.success(rocket))
            } else {
                complitionHandler(.failure(NetworkError.invalidState))
            }
        }
        task.resume()
    }
    
    func getLaunches(from urlString: String, complitionHandler: @escaping (Result<LaunchGetStruct, Error>) -> Void) {
        
        guard let url = URL(string: API.launches) else {
            complitionHandler(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let body = LaunchPostStruct(query: .init(rocket: "5e9d0d95eda69955f709d1eb", upcoming: false))
        
        let bodyData = try? JSONEncoder().encode(body)
        
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let jsonString = String(data: data!, encoding: .utf8) {
                               print(jsonString)
                           }
//            if let data = data, let launches = try? decoder.decode(LaunchGetStruct.self, from: data) {
//                complitionHandler(.success(launches))
//            } else {
//                complitionHandler(.failure(NetworkError.invalidState))
//            }
        }
        task.resume()
    }
    
    
    
    //    func requestLaunchesInfo() {
    //        guard let url = URL(string: API.launches) else { return }
    //        let request = URLRequest(url: url)
    //
    //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //            if let data = data, let launch = try? JSONDecoder().decode([LaunchElement].self, from: data) {
    //                for i in 0...launch.count - 1 {
    //                    if launch[i].rocket == "5e9d0d95eda69955f709d1eb" {
    //                        print("name: \(launch[i].name)")
    //
    //                    }
    //                }
    //            } else {
    //                print("error")
    //            }
    //        }
    //        task.resume()
    //    }
    //
    //    func postRequest() {
    //
    //        guard let url = URL(string: "https://api.spacexdata.com/v4/launches/query") else { return }
    //        var request = URLRequest(url: url)
    //
    //        let body = Request(options: Request.Options(populate: ["Payloads"]))
    //
    //        let bodyData = try? JSONEncoder().encode(body)
    //
    //        request.httpMethod = "POST"
    //        request.httpBody = bodyData
    //
    //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //            if let jsonString = String(data: data!, encoding: .utf8) {
    //                   print(jsonString)
    //               }
    //        }
    //        task.resume()
    //    }
    //
}
