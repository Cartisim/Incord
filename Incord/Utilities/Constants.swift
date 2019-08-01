//
//  Constants.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

enum PassFailResult {
    case failure
    case success
}

//Notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let CHANNEL_DID_CHANGE = Notification.Name("noftifyChannelChaned")
let SUB_CHANNEL_DID_CHANGE = Notification.Name("notifySubChannel")
let NEW_MESSAGE = Notification.Name("newMessage")
let NEW_CHANNEL = Notification.Name("newChannel")
let NEW_SUB_CHANNEL = Notification.Name("newSubChannel")
let CLEAR_CHANNELS = Notification.Name("clearChannels")

//URLS
let BASE_URL = "http://localhost:8080/api"
let WEBSOCKET_URL = "ws://localhost:8080/api"
let CREATE_URL = "\(BASE_URL)/create_account"
let LOGIN_URL = "\(CREATE_URL)/login"
let CHANNEL_URL = "\(BASE_URL)/channel"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
let ACCOUNT_ID_KEY = "createAccountID"

