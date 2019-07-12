//
//  Channel.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class Channel: Codable {
    
    var id: Int?
    var image: String
    var channel: String
    
    init(image: String, channel: String, id: Int?) {
        self.image = image
        self.channel = channel
        self.id = id
    }
}
