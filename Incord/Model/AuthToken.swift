//
//  AuthToken.swift
//  Incord
//
//  Created by Cole M on 6/25/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class AuthToken: Codable {
    
    var id: UUID?
    var token: String
    var createAccountID: UUID
    
    init(token: String, createAccountID: UUID){
        self.token = token
        self.createAccountID = createAccountID
    }
}
