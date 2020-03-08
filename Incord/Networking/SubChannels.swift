//
//  SubChannels.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class SubChannels: NSObject {
    
    static let shared = SubChannels()
    var subchannels = [SubChannel]()
    
    func getSubChannels(channelID: Int, completion: @escaping (Result<[SubChannel], Error>) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/channel/\(channelID)/sub_channel") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
       
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                 print("tokenr",UserData.shared.token)
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
}
