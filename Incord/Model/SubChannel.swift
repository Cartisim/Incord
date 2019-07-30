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
    var channelID: Int
    
    init(id: Int?, title: String, channelID: Int) {
        self.id = id
        self.title = title
        self.channelID = channelID
    }
}
