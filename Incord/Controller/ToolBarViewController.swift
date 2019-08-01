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
      setUpView()
    }
    
    func setUpView() {
         NotificationCenter.default.addObserver(self, selector: #selector(channelDidChange), name: CHANNEL_DID_CHANGE, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(subChannelDidChange), name: SUB_CHANNEL_DID_CHANGE, object: nil)
    }
    
    @IBAction func logoutClicked(_ sender: NSButton) {
        Authentication.shared.logout()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    
    @objc func channelDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
            self.channelLabel.stringValue = "#\(UserData.shared.channel)"
            self.subChannelLabel.stringValue = "#SubChannel"
    }
    }
    @objc func subChannelDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
            self.subChannelLabel.stringValue = "#\(UserData.shared.subChannel)"
        }
    }
}
