//
//  CreateUser.swift
//  Incord
//
//  Created by Cole M on 6/25/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class CreateAccount: Codable {
    var id: UUID?
    var username: String
    var email: String
    var avatar: String
    
    init(username: String, email: String, avatar: String) {
        self.username = username
        self.email = email
        self.avatar = avatar
    }
}
