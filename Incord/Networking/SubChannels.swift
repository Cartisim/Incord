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
    var subchannels = [SubChannel]()
    func getSubChannels(channelID: Int, completion: @escaping (Result<[SubChannel], Error>) -> ()) {
        guard let url = URL(string: "\( CHANNEL_URL)/\(channelID)/sub_channel") else { return }
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
