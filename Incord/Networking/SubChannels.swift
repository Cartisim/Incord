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
   
    func addSubChannel(title: String, completion: @escaping (Result<SubChannel, Error>) -> ()) {
        let body = SubChannel(title: title)
        guard let url = URL(string: SUB_CHANNEL_URL) else { return }
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
        }
    }
    
    //TODO:- Add Revtrieval methods
    func getSubChannels() {
        
    }
    
    func getSubChannel() {
        
    }
    
    //TODO:- Add Update methods
    func updateSubChannel() {
        
    }
    
    //TODO:- Add Delete Methods
    func deleteSubChannel() {
        
    }
}
