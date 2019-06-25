//
//  ChannelViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ChannelViewController: NSViewController {

    @IBOutlet weak var channelLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
           print(Authentication().id)
    }
    
    @IBAction func logoutClicked(_ sender: NSButton) {
        Authentication.shared.logout()
        print(Authentication().currentUser())
    }
}
