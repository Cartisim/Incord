//
//  Constants.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

struct Constants {
}

//Notifications
let USER_INFO_MODAL = "userInfoModal"
let PRESENTING_MODAL_NOTIFICATION = Notification.Name("presentingModal")
let CLOSING_MODAL_NOTIFIFCATION = Notification.Name("closingModal")
let DATA_CHANGED = Notification.Name("loadData")
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let CHANNEL_DID_CHANGE = Notification.Name("noftifyChannelChaned")
let SUB_CHANNEL_DID_CHANGE = Notification.Name("notifySubChannel")
let RELOAD_COLLECTION = Notification.Name("reloadCollection")
let RELOAD_TABLEVIEW = Notification.Name("reloadTableView")
let NEW_MESSAGE = Notification.Name("newMessage")

//URLS
let BASE_URL = "http://localhost:8080/api"
let CREATE_URL = "\(BASE_URL)/create_account"
let LOGIN_URL = "\(CREATE_URL)/login"
let CHANNEL_URL = "\(BASE_URL)/channel"
let MESSAGE_URL = "\(BASE_URL)/message"
let SOCKET_URL = "ws://localhost:8080/api"

// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization":"Bearer \(UserData.shared.token)",
    "Content-Type": "application/json; charset=utf-8"
]

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
let ACCOUNT_ID_KEY = "createAccountID"
let ID_KEY = "id"
let AVATAR_KEY = "avatar"
let CHANNEL_ID_KEY = "channelID"
let CHANNEL_KEY = "channel"
let SUB_CHANNEL_KEY = "subChannel"
let SUB_CHANNEL_ID_KEY = "subChannelId"
let MESSAGE_KEY = "message"
let DATE_KEY = "date"
let USERNAME_KEY = "username"
