//
//  UserData.swift
//  Incord
//
//  Created by Cole M on 6/26/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation
import KeychainSwift

class UserData {
    
    //Computed properties Getters/Setters
    var keychain = KeychainSwift()
    let defaults = UserDefaults.standard
    static let shared = UserData()
    
    fileprivate var _imageString = ""
    fileprivate var _channel = ""
    fileprivate var _channelID: Int = 0
    fileprivate var _subChannel = ""
    fileprivate var _subChannelID: Int = 0
    fileprivate var _date = ""
    fileprivate var _username = ""
    fileprivate var _messageID = 0
    fileprivate var _message = ""
    fileprivate var _avatar = ""
    fileprivate var _id = ""
    
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
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    var createAccountID: String {
        get {
            return defaults.value(forKey: ACCOUNT_ID_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: ACCOUNT_ID_KEY)
        }
    }
    
    var avatarName: String {
        get {
            return _avatar
        }
        set {
           _avatar = newValue
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
    
    var channelID: Int {
        get {
            return _channelID
        }
        set {
            _channelID = newValue
        }
    }
    
    var channel: String {
        get {
            return _channel
        }
        set {
            _channel = newValue
        }
    }
    
    var imageString: String {
        get {
            return _imageString
        }
        set {
            _imageString = newValue
        }
    }
    
    var subChannel: String {
        get {
            return _subChannel
        }
        set {
            _subChannel = newValue
        }
    }
    
    var subChannelID: Int {
        get {
            return _subChannelID
        }
        set {
            _subChannelID = newValue
        }
    }
    
    var date: String {
        get {
            return _date
        }
        set {
            _date = newValue
        }
    }

    var message: String {
        get {
            return _message
        }
        set {
            _message = newValue
        }
    }

    var messageID: Int {
        get {
            return _messageID
        }
        set {
            _messageID = newValue
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

