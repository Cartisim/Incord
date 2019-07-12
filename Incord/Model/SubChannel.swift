//
//  SubChannel.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class SubChannel: Codable {
    
    var id: Int?
    var title: String
    
    init(title: String) {
        self.title = title
    }
}
