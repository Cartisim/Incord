//
//  ChannelImage.swift
//  Incord
//
//  Created by Cole M on 7/12/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

struct ChannelImage: Codable {
    var id: Int?
    var image: Data
    
    init(image: Data) {
        self.image = image
    }
}
