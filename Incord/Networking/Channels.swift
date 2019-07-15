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
    
    func addChannel(image: String, channel: String, completion: @escaping (Result<Channel, Error>) -> ()) {
        let body = Channel(imageString: image, channel: channel)
        guard let url = URL(string: CHANNEL_URL) else { return }
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
                let channel = try JSONDecoder().decode(Channel.self, from: data!)
                completion(.success(channel))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    func addChannelImage(image: Data, completion: @escaping (Result<ChannelImage, Error>) -> ()) {
        let addImage = ChannelImage(image: image)
        guard let url = URL(string: "\(CHANNEL_URL)/image/\(UserData.shared.channelID)/channelImage") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
        guard let uploadData = try? JSONEncoder().encode(addImage) else { return }
        
        URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
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
        }.resume()
    }
  
    func getChannels(completion: @escaping (Result<[Channel], Error>) -> ()) {
         guard let url = URL(string: "\(CHANNEL_URL)") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let channels = try JSONDecoder().decode([Channel].self, from: data!)
                completion(.success(channels))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
    
    func getChannel(channel: Int, completion: @escaping (Result<Channel, Error>) -> ()) {
            guard let url = URL(string: "\(CHANNEL_URL)/\(channel + 1)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            print(url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    let currentChannel = try JSONDecoder().decode(Channel.self, from: data!)
                    completion(.success(currentChannel))
                } catch let err {
                    completion(.failure(err))
                }
                }.resume()
    }
    
     
}
