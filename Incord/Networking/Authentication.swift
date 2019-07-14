//
//  Authentication.swift
//  Incord
//
//  Created by Cole M on 6/25/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class Authentication {
    
    static let shared = Authentication()
    
    func login(email: String, password: String, completion: @escaping (Result<AuthToken, Error>) -> ()) {
        
        let lowerCaseEmail = email.lowercased()
        guard let credentialData = "\(lowerCaseEmail):\(password)".data(using: String.Encoding.utf8)?.base64EncodedString() else { return }
        guard let url = URL(string: LOGIN_URL) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("Basic \(credentialData)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let user = try JSONDecoder().decode(AuthToken.self, from: data!)
                completion(.success(user))
                UserData.shared.token = user.token
                UserData.shared.id = user.id!.uuidString
                UserData.shared.createAccountID = user.createAccountID.uuidString
                UserData.shared.userEmail = email
                UserData.shared.isLoggedIn = true
            } catch let err {
                completion(.failure(err))
            }
            }.resume()
    }
    
    
    func createUser(username: String, email: String, password: String, avatar: String, completion: @escaping (Result<CreateAccount, Error>) -> ()) {
        
        let lowerCaseEmail = email.lowercased()
        let body = [
            "username": username,
            "email": lowerCaseEmail,
            "password": password,
            "avatar": avatar
        ]
        guard let url = URL(string: CREATE_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let user = try JSONDecoder().decode(CreateAccount.self, from: data!)
                completion(.success(user))
                UserData.shared.id = user.id!.uuidString
                UserData.shared.avatarName = user.avatar
                UserData.shared.userEmail = user.email
                UserData.shared.username = user.username
            } catch let error {
                completion(.failure(error))
            }
            }.resume()
    }
    
    func logout() {
        if  UserData.shared.isLoggedIn {
            UserData.shared.keychain.delete(UserData.shared.token)
            UserData.shared.isLoggedIn = false
            print("user logged out")
        } else {
            print("please login")
            //TODO:- NSAlert Modal
        }
    }
}
