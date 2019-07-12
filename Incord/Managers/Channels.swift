//
//  Channel.swift
//  Incord
//
//  Created by Cole M on 7/12/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class Channels {
    
    static let shared = Channels()
    
    func addChannel(channel: String, completion: @escaping (Result<Channel, Error>) -> ()) {
        let body = [
            "channel": channel
        ]
        guard let url = URL(string: CHANNEL_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authentication")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let channel = try JSONDecoder().decode(Channel.self, from: data!)
                completion(.success(channel))
            } catch let err {
                completion(.failure(err))
            }
        }
    }
    
    func addChannelImage(image: Data, completion: @escaping (Result<ChannelImage, Error>) -> ()) {
        let addImage = ChannelImage(image: image)
        guard let url = URL(string: CHANNEL_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authentication")
        guard let uploadData = try? JSONEncoder().encode(addImage) else { return }
        
        URLSession.shared.uploadTask(with: request, from: uploadData) { (data, reaponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let image = try JSONDecoder().decode(ChannelImage.self, from: data!)
                completion(.success(image))
            } catch let err {
                completion(.failure(err))
            }
        }
    }
}
