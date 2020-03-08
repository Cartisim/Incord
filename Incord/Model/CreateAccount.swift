//
//  CreateUser.swift
//  Incord
//
//  Created by Cole M on 6/25/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class CreateAccount: Codable {
    
    var id: UUID?
    var username: String
    var email: String
    var avatar: String
    
    init(username: String, email: String, avatar: String) {
        self.username = username
        self.email = email
        self.avatar = avatar
    }
    
    func deleteUser(id: Int, completion: @escaping (PassFailResult) -> Void) {
           guard let url = URL(string: "\(BASE_URL)/\(id)") else {return}
           print(url)
           var request = URLRequest(url: url)
           request.httpMethod = "DELETE"
           request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
           
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
