//
//  ChannelViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ToolBarViewController: NSViewController {

    @IBOutlet weak var channelLabel: NSTextField!
    @IBOutlet weak var subChannelLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutClicked(_ sender: NSButton) {
        Authentication.shared.logout()
        print("logoutClicked")
//        Users.shared.currentUser { (res) in
//            switch res {
//            case .success(let user):
//
//                print(user)
//            case .failure(let err):
//                print(err)
//            }
//        }
       NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
   
}
