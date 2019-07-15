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
    
    let channel = [Channel]()
    static let shared = ToolBarViewController()
    
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
    }
    
    
    @objc func channelDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
            self.channelLabel.stringValue = "#\(UserData.shared.channel)"
    }
    }
    @objc func subChannelDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
            self.subChannelLabel.stringValue = "#\(UserData.shared.subChannel)"
        }
    }
}
