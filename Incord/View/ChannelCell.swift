//
//  ChannelCell.swift
//  Incord
//
//  Created by Cole M on 7/12/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ChannelCell: NSCollectionViewItem {

    var channels = [Channel]()
    
    
    @IBOutlet weak var channelLabel: NSTextField!
    @IBOutlet weak var channelImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
