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
    var password: String
    var avartar: String
    
    init(username: String, email: String, password: String, avatar: String) {
        self.username = username
        self.email = email
        self.password = password
        self.avartar = avatar
    }
}
