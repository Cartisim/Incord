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

//URLS
let BASE_URL = "http://localhost:8080/api"
let CREATE_URL = "\(BASE_URL)/create_account"
let LOGIN_URL = "\(CREATE_URL)/login"


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
