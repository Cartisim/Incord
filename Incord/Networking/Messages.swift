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
    
    func addMessage(avatar: String, username: String, Date: String, message: String, subChannelID: Int, completion: @escaping (Result<Message, Error>) -> ()) {
        let body = Message(avatar: avatar, username: username, date: Date, message: message, subChannelID: subChannelID)
        guard let url = URL(string: MESSAGE_URL) else { return }
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
                let message = try JSONDecoder().decode(Message.self, from: data!)
                completion(.success(message))
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
    
    //TODO:- Add Revtrieval methods
    func getMessages(subChannelID: Int, completion: @escaping (Result<[Message], Error>) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/sub_channel/\(subChannelID)/messages") else { return }
        print(url)
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
    
    //TODO:- Add Update methods
    func updateMessage() {
        
    }
    
    //TODO:- Add Delete Methods
    func deleteMessage() {
        
    }
}
