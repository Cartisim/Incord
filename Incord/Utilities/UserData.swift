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
    
    var avatarName: String {
        get {
            return defaults.value(forKey: AVATAR_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: AVATAR_KEY)
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
    var id: String {
        get {
            return defaults.value(forKey: ID_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: ID_KEY)
        }
    }
    
    var channelID: Int {
        get {
            return defaults.value(forKey: CHANNEL_ID_KEY) as! Int
        }
        set {
            defaults.set(newValue, forKey:  CHANNEL_ID_KEY)
        }
    }
    var channel: String {
        get {
            return defaults.value(forKey: CHANNEL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey:  CHANNEL_KEY)
        }
    }
    var subChannel: String {
        get {
            return defaults.value(forKey: SUB_CHANNEL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey:  SUB_CHANNEL_KEY)
        }
    }
    var subChannelID: Int {
        get {
            return defaults.value(forKey: SUB_CHANNEL_ID_KEY) as! Int
        }
        set {
            defaults.set(newValue, forKey:  SUB_CHANNEL_ID_KEY)
        }
    }
    var date: String {
        get {
            return defaults.value(forKey: DATE_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey:  DATE_KEY)
        }
    }
    var message: String {
        get {
            return defaults.value(forKey: MESSAGE_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey:  MESSAGE_KEY)
        }
    }
    var username: String {
        get {
              return defaults.value(forKey: USERNAME_KEY) as! String
        }
        set {
             defaults.set(newValue, forKey:  USERNAME_KEY)
        }
    }
}
