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
    @IBOutlet var logoutButton: NSButton!
    
    var users = [CreateAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(channelDidChange), name: CHANNEL_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(subChannelDidChange), name: SUB_CHANNEL_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelsCleared), name: CLEAR_CHANNELS, object: nil)
        setTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(setTitle), name: SET_TITLE_TO_LOGOUT, object: nil)
    }
    
    @objc func setTitle() {
        if !UserData.shared.isLoggedIn {
            logoutButton.title = ""
        } else{
            logoutButton.title = "Logout"
        }
    }
    
    @IBAction func logoutClicked(_ sender: NSButton) {
        if  UserData.shared.isLoggedIn {
            UserData.shared.isLoggedIn = false
            UserData.shared.avatarName = ""
            UserData.shared.username = ""
            UserData.shared.userEmail = ""
            UserData.shared.id = ""
            UserData.shared.subChannel = ""
            UserData.shared.channel = "Your Channel"
            NotificationCenter.default.post(name: CLEAR_CHANNELS, object: nil)
            NotificationCenter.default.post(name: CHANNEL_DID_CHANGE, object: nil)
            NotificationCenter.default.post(name: LOGGED_IN, object: nil)
            MasterViewController.shared.clearChatView()
            users.removeAll()
            setTitle()
        } else {
            print("please login")
            view.window?.contentViewController?.presentAsSheet(errorViewController)
        }
    }
    
    lazy var errorViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
    }()
    
    @objc func channelsCleared(_ notif: Notification) {
        DispatchQueue.main.async {
            ChannelSocket.shared.channels.removeAll()
            self.channelLabel.stringValue = "#Your Channel"
            self.subChannelLabel.stringValue = "#SubChannel"
        }
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
