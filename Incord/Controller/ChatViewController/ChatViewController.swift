//
//  ChatViewController.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ChatViewController: NSViewController, URLSessionWebSocketDelegate {
    
    @IBOutlet weak var chatTextField: NSTextField!
    @IBOutlet weak var customButtonView: NSView!
    @IBOutlet weak var chatTableView: NSTableView!
    @IBOutlet weak var profileImageButton: NSButton!
    @IBOutlet weak var addMessageButton: NSButton!
    
    var clickBackground: BackgroundView!
    var dateStringValue: String!
    var leftVC: MasterViewController?
    static let shared = ChatViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange), name: USER_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newMessage), name: NEW_MESSAGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: RELOAD, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: LOGGED_IN, object: nil)
        NotificationCenter.default.post(name: LOGGED_IN, object: nil)
        let deleteMessageMenu = NSMenu()
        deleteMessageMenu.addItem(withTitle: "Delete Message", action: #selector(deleteMessage), keyEquivalent: "")
        chatTableView.menu = deleteMessageMenu
        setUpView()
    }
    
    func setUpView() {
        chatTextField.wantsLayer = true
        chatTextField.layer?.cornerRadius = 8
        customButtonView.wantsLayer = true
        customButtonView.layer?.cornerRadius = 8
    }
    
    lazy var profileViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ProfileVC") as! NSViewController
    }()
    
    lazy var friendsViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "FriendsVC") as! NSViewController
    }()
    
    lazy var pleaseLoginViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "PleaseLoginVC") as! NSViewController
    }()
    
    lazy var mismatchViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "MismatchVC") as! NSViewController
    }()
    
    lazy var errorViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
    }()
    
    lazy var deleteViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "DeleteVC") as! NSViewController
    }()
    
    
    @IBAction func profileButtonClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn {
            self.view.window?.contentViewController?.presentAsSheet(profileViewController)
        } else {
            self.view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
        
    }
    @IBAction func profileImageClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn {
            self.view.window?.contentViewController?.presentAsSheet(profileViewController)
        } else {
            self.view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
    }
    
    @IBAction func friendsButtonClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn {
            self.view.window?.contentViewController?.presentAsSheet(friendsViewController)
        } else {
            self.view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
    }
    
    @IBAction func friendsImageClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn {
            self.view.window?.contentViewController?.presentAsSheet(friendsViewController)
        } else {
            self.view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
    }
    
    
    @IBAction func chatTextFieldEntered(_ sender: NSTextField) {
        //        addMessageButton.performClick(nil)
    }
    
    
    @IBAction func AddFileClicked(_ sender: NSButton) {
        
        if UserData.shared.isLoggedIn && chatTextField.stringValue.isEmpty == false {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            dateStringValue = formatter.string(from: currentDate)
            
            let uuid = UUID(uuidString: UserData.shared.createAccountID)!
            Users.shared.currentUser(id: uuid) { (res) in
                switch res {
                case .success(let currentUser):
                    DispatchQueue.main.async {
                        MessagesSocket.shared.addMessage(id: UserData.shared.messageID, avatar: currentUser.avatar, username: currentUser.username, Date: self.dateStringValue, message: self.chatTextField.stringValue, subChannelID: UserData.shared.subChannelID, createAccountID: uuid) { (res) in
                            switch res {
                            case .success(let messages):
                                print(messages)
                                DispatchQueue.main.async {
                                    self.chatTextField.stringValue = ""
                                    print(UserData.shared.createAccountID)
                                    print(UserData.shared.username)
                                }
                            case .failure(let error):
                                print(error)
                                self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                            }
                        }
                    }
                case .failure(let err):
                    print(err)
                    DispatchQueue.main.async {
                        self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                    }
                }
            }
            
            
        } else if UserData.shared.isLoggedIn && chatTextField.stringValue.isEmpty {
            self.view.window?.contentViewController?.presentAsSheet(mismatchViewController)
        } else {
            print("login")
            self.view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
    }
}

