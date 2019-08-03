//
//  Messages.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class Message: Codable {
    
    var id: Int?
    var avatar: String
    var username: String
    var date: String
    var message: String
    var subChannelID: Int
    var createAccountID: UUID?
    
    init(id: Int?, avatar: String, username: String, date: String, message: String, subChannelID: Int, createAccountID: UUID?) {
        self.id = id 
        self.avatar = avatar
        self.username = username
        self.date = date
        self.message = message
        self.subChannelID = subChannelID
        self.createAccountID = createAccountID
    }
    
    func deleteMessage(id: Int, completion: @escaping (PassFailResult) -> Void) {
        guard let url = URL(string: "\(BASE_URL)/message/\(id)") else {return}
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, _) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                print(httpResponse.statusCode)
                completion(.success)
            } else {
                completion(.failure)
            }
            }.resume()
    }
}
