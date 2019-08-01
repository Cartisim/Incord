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
    var images = [ChannelImage]()
    
    func addChannelImage(image: Data, completion: @escaping (Result<ChannelImage, Error>) -> ()) {
        Channels.shared.getChannels { (res) in
            switch res {
            case .success(let channels):
                channels.forEach({ (channel) in
                    DispatchQueue.main.async {
                        UserData.shared.channelID = channel.id!
                        UserData.shared.imageString = channel.imageString
                        UserData.shared.channel = channel.channel
                        
                        let channel = Channel(id: channel.id!, imageString: channel.imageString, channel: channel.channel)
                        ChannelSocket.shared.channels.append(channel)
                        let addImage = ChannelImage(image: image)
                        guard let url = URL(string: "\(CHANNEL_URL)/image/\(UserData.shared.channelID)/channelImage") else { return }
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
                })
            case .failure(let err):
                print("There was an error \(err)")
            }
        }
    }
    
    func getChannels(completion: @escaping (Result<[Channel], Error>) -> ()) {
        guard let url = URL(string: "\(CHANNEL_URL)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let channels = try JSONDecoder().decode([Channel].self, from: data!)
                channels.forEach { (channel) in
                    UserData.shared.channelID = channel.id!
                }
                completion(.success(channels))
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
    
    func getChannel(channel: Int, completion: @escaping (Result<Channel, Error>) -> ()) {
        guard let url = URL(string: "\(CHANNEL_URL)/\(channel)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
