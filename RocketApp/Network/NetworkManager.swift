//
//  NetworkManager.swift
//  RocketApp
//
//  Created by Podgainy Sergei on 07.01.2023.
//

import Foundation

class NetworkManager {
    
    func requestRocketInfo() {
        guard let url = URL(string: "https://api.spacexdata.com/v4/rockets") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let rocket = try? JSONDecoder().decode([RocketElement].self, from: data) {
                print("Название: \(rocket[0].name)")
                print("Первый запуск: \(rocket[0].firstFlight)")
                print("Страна: \(rocket[0].country)")
                print("id ракеты: \(rocket[0].id)")
            }
        }
        task.resume()
    }
    func requestLaunchesInfo() {
        guard let url = URL(string: "https://api.spacexdata.com/v4/launches/") else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let launch = try? JSONDecoder().decode([LaunchElement].self, from: data) {
                for i in 0...launch.count - 1 {
                    if launch[i].rocket == "5e9d0d95eda69955f709d1eb" {
                        print("name: \(launch[i].name)")
                        print("rocket: \(launch[i].rocket ?? "")")
                        print("success: \(launch[i].success ?? true)")
                        print("dateLocal: \(launch[i].dateLocal ?? "")")
                    }
                }
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
   
    
}
