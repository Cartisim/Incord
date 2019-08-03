//
//  Users.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class Users: NSObject {
    
    static let shared = Users()
    var users = [CreateAccount]()
    
    func currentUser(id: UUID, completion: @escaping (Result<CreateAccount, Error>) -> ()) {
            guard let url = URL(string: "\(CREATE_URL)/\(id)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    let currentUser = try JSONDecoder().decode(CreateAccount.self, from: data!)
                    let user = CreateAccount(username: currentUser.username, email: currentUser.email, avatar: currentUser.avatar)
                    self.users.append(user)
                    completion(.success(currentUser))
                } catch let err {
                    completion(.failure(err))
                }
                }.resume()
    }
    
    
    func allUsers(completion: @escaping (Result<[CreateAccount], Error>) -> ()) {
        
        guard let url = URL(string: "\(CREATE_URL)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let users = try JSONDecoder().decode([CreateAccount].self, from: data!)
                completion(.success(users))
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
    
    func updateUser(username: String, email: String, password: String, avatar: String, completion: @escaping (Result<CreateAccount, Error>) -> ()) {
        print("called")
        let lowerCaseEmail = email.lowercased()
        let body = [
            "username": username,
            "email": lowerCaseEmail,
            "password": password,
            "avatar": avatar
        ]
        guard let url = URL(string: "\(CREATE_URL)/\(UserData.shared.createAccountID)") else { return }
        var request = URLRequest(url: url)
        print(request)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let updateUser = try JSONDecoder().decode(CreateAccount.self, from: data!)
                completion(.success(updateUser))
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
}
