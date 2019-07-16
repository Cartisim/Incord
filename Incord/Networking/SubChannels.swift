//
//  SubChannels.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class SubChannels {
    static let shared = SubChannels()
   
    func addSubChannel(title: String, channelID: Int, completion: @escaping (Result<SubChannel, Error>) -> ()) {
        let body = SubChannel(title: title, channelID: channelID)
        guard let url = URL(string: "\(BASE_URL)/sub_channel") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let title = try JSONDecoder().decode(SubChannel.self, from: data!)
                completion(.success(title))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    func getSubChannels(channelID: Int, completion: @escaping (Result<[SubChannel], Error>) -> ()) {
        guard let url = URL(string: "\( CHANNEL_URL)/\(channelID + 1)/sub_channel") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let channels = try JSONDecoder().decode([SubChannel].self, from: data!)
                completion(.success(channels))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    func getSubChannel() {
        
    }

    //TODO:- Add Delete Methods
    func deleteSubChannel() {
        
    }
}
