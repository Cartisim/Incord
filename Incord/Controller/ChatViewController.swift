//
//  ChatViewController.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ChatViewController: NSViewController {
    
    @IBOutlet weak var chatTextField: NSTextField!
    @IBOutlet weak var customButtonView: NSView!
    @IBOutlet weak var chatTableView: NSTableView!
    @IBOutlet weak var profileImageButton: NSButton!
    
    var clickBackground: BackgroundView!
    var avatarString = "avatar1"
    static let shared = ChatViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpViewController()
    }
    
    func setUpViewController() {
        chatTextField.wantsLayer = true
        chatTextField.layer?.cornerRadius = 8
        customButtonView.wantsLayer = true
        customButtonView.layer?.cornerRadius = 8
        
        if UserData.shared.isLoggedIn == false {
        profileImageButton.image = NSImage(named: avatarString)
        } else {
            profileImageButton.image = NSImage(named: UserData.shared.avatarName)
        }
    }
    
    lazy var profileViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ProfileVC") as! NSViewController
    }()
    
    lazy var friendsViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "FriendsVC") as! NSViewController
    }()
    
    @IBAction func profileButtonClicked(_ sender: NSButton) {
        self.view.window?.contentViewController?.presentAsSheet(profileViewController)
        
    }
    @IBAction func profileImageClicked(_ sender: NSButton) {
        self.view.window?.contentViewController?.presentAsSheet(profileViewController)
    }
    
    @IBAction func friendsButtonClicked(_ sender: NSButton) {
        self.view.window?.contentViewController?.presentAsSheet(friendsViewController)
    }
    
    @IBAction func friendsImageClicked(_ sender: NSButton) {
        self.view.window?.contentViewController?.presentAsSheet(friendsViewController)
    }
    
    @IBAction func AddFileClicked(_ sender: NSButton) {
    }
    
}
