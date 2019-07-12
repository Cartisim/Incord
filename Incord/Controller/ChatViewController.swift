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
        if UserData.shared.isLoggedIn != true {
           profileImageButton.image = NSImage(named: self.avatarString)
        }
    }
    override func viewWillAppear() {
        setUpViewController()

            Users.shared.currentUser { (res) in
                switch res {
                case .success(let user):
 NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    print(user)
                case .failure(let err):
                    self.profileImageButton.image = NSImage(named: self.avatarString)
                    print(err)
                }
            }
            
        }
    
    
    func setUpViewController() {
        chatTextField.wantsLayer = true
        chatTextField.layer?.cornerRadius = 8
        customButtonView.wantsLayer = true
        customButtonView.layer?.cornerRadius = 8
          NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    lazy var profileViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ProfileVC") as! NSViewController
    }()
    
    lazy var friendsViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "FriendsVC") as! NSViewController
    }()
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
        if UserData.shared.isLoggedIn {
            self.profileImageButton.image = NSImage(named: UserData.shared.avatarName)
        } else {
            self.profileImageButton.image = NSImage(named: "avatar1")
        }
        }
    }
    
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
