//
//  Messages.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class Message: Codable {
    
    var id: Int?
    var avatar: String
    var username: String
    var date: String
    var message: String
    var subChannelID: Int
    
    init(avatar: String, username: String, date: String, message: String, subChannelID: Int) {
        self.avatar = avatar
        self.username = username
        self.date = date
        self.message = message
        self.subChannelID = subChannelID
    }
}
