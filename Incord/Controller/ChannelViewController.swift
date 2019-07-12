//
//  ChannelViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ChannelViewController: NSViewController {

    @IBOutlet weak var channelLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutClicked(_ sender: NSButton) {
        Authentication.shared.logout()
        print("logoutClicked")
      
    }
    
   
}
