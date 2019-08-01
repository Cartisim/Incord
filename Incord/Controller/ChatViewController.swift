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
        // Do view setup here.
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newMessage), name: NEW_MESSAGE, object: nil)
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        let deleteMessageMenu = NSMenu()
        deleteMessageMenu.addItem(withTitle: "Delete Message", action: #selector(deleteMessage), keyEquivalent: "")
        chatTableView.menu = deleteMessageMenu
    }
    override func viewWillAppear() {
        setUpViewController()
    }
    
    func setUpViewController() {
        chatTextField.wantsLayer = true
        chatTextField.layer?.cornerRadius = 8
        customButtonView.wantsLayer = true
        customButtonView.layer?.cornerRadius = 8
    }
    
    @objc func newMessage() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            self.chatTableView.scrollRowToVisible(MessagesSocket.shared.messages.count - 1)
        }
    }
    
    @objc func deleteMessage() {
        Message(id: UserData.shared.messageID, avatar: UserData.shared.avatarName, username: UserData.shared.username, date: UserData.shared.date, message: UserData.shared.message, subChannelID: UserData.shared.subChannelID).deleteMessage(id: UserData.shared.messageID) { (res) in
            switch res {
            case .success:
                DispatchQueue.main.async {
                    MessagesSocket.shared.messages.removeAll()
                    MasterViewController.shared.getMessages()
                }
            case .failure:
                print("failure")
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
            if UserData.shared.isLoggedIn {
                Users.shared.currentUser { (res) in
                    switch res {
                    case .success(let currentUser):
                        DispatchQueue.main.async {
                            UserData.shared.avatarName = currentUser.avatar
                            UserData.shared.userEmail = currentUser.email
                            UserData.shared.id = currentUser.id!.uuidString
                            UserData.shared.username = currentUser.username
                            self.profileImageButton.image = NSImage(named: UserData.shared.avatarName)
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
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
        addMessageButton.performClick(nil)
    }
    
    
    @IBAction func AddFileClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn && chatTextField.stringValue.isEmpty == false {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            
            dateStringValue = formatter.string(from: currentDate)
            MessagesSocket.shared.addMessage(id: UserData.shared.messageID, avatar: UserData.shared.avatarName, username: UserData.shared.username, Date: dateStringValue, message: chatTextField.stringValue, subChannelID: UserData.shared.subChannelID) { (res) in
                switch res {
                case .success(let messages):
                    print(messages)
                    DispatchQueue.main.async {
                        self.chatTextField.stringValue = ""
                        MasterViewController.shared.getMessages()
                    }
                case .failure(let error):
                    print(error)
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

extension ChatViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        print("chat selected")
    }
}

extension ChatViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessagesSocket.shared.messages.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "messageCell"), owner: nil) as? ChatTableCell
        let message = MessagesSocket.shared.messages[row]
        cell?.avatarImage.image = NSImage(named: message.avatar)
        cell?.dateLabel.stringValue = message.date
        cell?.usernameLabel.stringValue = message.username
        cell?.messageField.stringValue = message.message
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 150.0
    }
}
