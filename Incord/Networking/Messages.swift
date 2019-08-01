//
//  Messages.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class Messages {
    
    static let shared = Messages()
    
    func getMessages(subChannelID: Int, completion: @escaping (Result<[Message], Error>) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/sub_channel/\(subChannelID)/messages") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let message = try JSONDecoder().decode([Message].self, from: data!)
                completion(.success(message))
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
    
    func getMessage(messageID: Int, completion: @escaping (Result<Message, Error>) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/message/\(messageID)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do{
                let message = try JSONDecoder().decode(Message.self, from: data!)
                completion(.success(message))
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
}
