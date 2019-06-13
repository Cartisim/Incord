//
//  MasterViewController.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {

    @IBOutlet weak var channelCollectionView: NSScrollView!
    @IBOutlet weak var subChannelTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    func setUpView() {
        channelCollectionView.wantsLayer = true
        channelCollectionView.layer?.backgroundColor = .clear
    }
}
