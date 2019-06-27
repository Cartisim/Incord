//
//  Users.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Users {
    
    static let shared = Users()
    var users = [CreateAccount]()
    
    
    func currentUser(completion: @escaping CompletionHandler) {
        if  UserData.shared.isLoggedIn {
            Alamofire.request("\(CREATE_URL)/\(UserData.shared.createAccountID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    Authentication.shared.setUserInfo(data: data)
                    completion(true)
                } else {
                    completion(false)
                    print("another error")
                    debugPrint(response.result.error as Any)
                }
            }
        } else {
            print("Not Logged In")
        }
    }
    
    
    func updateUser(username: String, email: String, password: String, avatar: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "username": username,
            "email": lowerCaseEmail,
            "password": password,
            "avatar": avatar
        ]
        
        let headers = ["Authorization": "Bearer \(UserData.shared.token)", "Content-Type": "application/json; charset=utf-8"]
        Alamofire.request("\(CREATE_URL)/\(UserData.shared.createAccountID)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                print(data)
                Authentication.shared.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                print(response.result.error as Any)
            }
        }
    }
    
    func allUsers(completion: @escaping CompletionHandler) {
        Alamofire.request("\(CREATE_URL)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let userName = item["username"].stringValue
                            let emailAddress = item["email"].stringValue
                            let avatarName = item["avatar"].stringValue
                            let user = CreateAccount(username: userName, email: emailAddress, avatar: avatarName)
                            self.users.append(user)
                        }
                        completion(true)
                    }
                } catch {
                    fatalError()
                }
            } else {
                completion(false)
                print("Could not get all Users")
            }
        }
    }
    
}
