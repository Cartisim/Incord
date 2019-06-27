//
//  Authentication.swift
//  Incord
//
//  Created by Cole M on 6/25/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainSwift


class Authentication {
    
    static let shared = Authentication()
    let user = [CreateAccount]()
    
    func login(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        let credentialData = "\(email):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)", "Content-Type": "application/json; charset=utf-8"]
        
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    UserData.shared.userEmail = json["user"].stringValue
                    UserData.shared.token = json["token"].stringValue
                    UserData.shared.id = json["id"].stringValue
                    UserData.shared.createAccountID = json["createAccountID"].stringValue
                    UserData.shared.isLoggedIn = true
                    print(json)
                    completion(true)
                } catch {
                    fatalError()
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func createUser(username: String, email: String, password: String, avatar: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "username": username,
            "email": lowerCaseEmail,
            "password": password,
            "avatar": avatar
        ]
        
        let headers = ["Authorization": "Bearer \(UserData.shared.token)", "Content-Type": "application/json; charset=utf-8"]
        Alamofire.request(CREATE_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                do {
                    let json = try JSON(data:data)
                    UserData.shared.token = json["token"].stringValue
                } catch {
                    fatalError()
                }
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func currentUser(completion: @escaping CompletionHandler) {
        if  UserData.shared.isLoggedIn {
            Alamofire.request("\(CREATE_URL)/\(UserData.shared.createAccountID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    self.setUserInfo(data: data)
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
    
    func allUsers(completion: @escaping CompletionHandler) {
        Alamofire.request("\(CREATE_URL)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                print("Could not get all Users")
            }
        }
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
    
    func setUserInfo(data: Data) {
        do {
            let json = try JSON(data: data)
            UserData.shared.id = json["id"].stringValue
            UserData.shared.avatarName = json["avatar"].stringValue
            UserData.shared.userEmail = json["email"].stringValue
            UserData.shared.username = json["username"].stringValue
            print(json)
        } catch {
            fatalError()
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
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                print(response.result.error as Any)
            }
        }
    }
}



