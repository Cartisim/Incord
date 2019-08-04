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
    var imageString: String
    var channel: String
    
    init(id: Int, imageString: String, channel: String) {
        self.id = id
        self.imageString = imageString
        self.channel = channel
    }

}
