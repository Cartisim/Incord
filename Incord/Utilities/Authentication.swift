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

enum AuthResult {
    case success
    case failure
}
class Authentication {
    
    var keychain = KeychainSwift()
    let defaults = UserDefaults.standard
    
    var token: String {
        get {
            return keychain.get(TOKEN_KEY) ?? ""
        }
        set {
            keychain.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    //    var authToken: String {
    //        get {
    //            return defaults.value(forKey: TOKEN_KEY) as! String
    //        }
    //        set {
    //            defaults.set(newValue, forKey: TOKEN_KEY)
    //        }
    //    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
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
                    self.userEmail = json["user"].stringValue
                    self.token = json["token"].stringValue
                    self.isLoggedIn = true
                    print(json["token"].stringValue)
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

        let headers = ["Authorization": "Bearer \(self.token)", "Content-Type": "application/json; charset=utf-8"]
        Alamofire.request(CREATE_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                do {
                    let json = try JSON(data:data)
                    self.token = json["token"].stringValue
                    print(self.token)
                } catch {
                    fatalError()
                }
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    //TODO-: Implement a current User function
    func currentUser() {
        let body: [String: Any] = [
            "id": id
        ]
        
        Alamofire.request("\(CREATE_URL)\(id)", method: .get, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data:data)
                    self.id = json["_id"].stringValue
                    print(self.id)
                } catch {
                    fatalError()
                }
            } else {
                
            }
        }
    }
    func logout() {
        keychain.delete(Authentication.shared.token)
    }
    
    func setUserInfo(data: Data) {
        do {
            let json = try JSON(data: data)
            id = json["_id"].stringValue
            avatarName = json["avatarName"].stringValue
            email = json["email"].stringValue
            username = json["name"].stringValue
            print(json)
        } catch {
            fatalError()
        }
    }
    
    static let shared = Authentication()
    
    //Computed properties Getters/Setters
    fileprivate var _avatar = ""
    fileprivate var _id = ""
    fileprivate var _email = ""
    fileprivate var _username = ""
    
    var avatarName: String {
        get {
            print("1\(_avatar)")
            return _avatar
        }
        set {
            print("2\(_avatar)")
            //avatarName is called when newValue is set
            _avatar = newValue
            print("3\(newValue)")
        }
    }
    
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var email: String {
        get {
            return _email
        }
        set {
            _email = newValue
        }
    }
    
    var username: String {
        get {
            return _username
        }
        set {
            _username = newValue
        }
    }
    
    
}
