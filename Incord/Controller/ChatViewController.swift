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
    }
    override func viewWillAppear() {
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        setUpViewController()
    }
    
    func setUpViewController() {
        chatTextField.wantsLayer = true
        chatTextField.layer?.cornerRadius = 8
        customButtonView.wantsLayer = true
        customButtonView.layer?.cornerRadius = 8
    }
    
    @objc func newMessage() {
        MessagesSocket.shared.messages.removeAll()
        //TODO:-Impelement Message ID, it is currentlty nil
        Messages.shared.getMessage(messageID: MessagesSocket.shared.messages.last!.id!) { (res) in
            switch res {
            case .success(let message):
                print(message)
                UserData.shared.avatarName = message.avatar
                UserData.shared.date = message.date
                UserData.shared.message = message.message
                UserData.shared.subChannelID = message.subChannelID
                UserData.shared.messageID = message.id!
                UserData.shared.username = message.username
                let message = Message(avatar: message.avatar, username: message.username, date: message.date, message: message.message, subChannelID: message.subChannelID)
                MessagesSocket.shared.messages.append(message)
                
                self.chatTableView.reloadData()
                self.chatTableView.scrollRowToVisible(MessagesSocket.shared.messages.count - 1)
            case .failure(let error):
                print(error)
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
        if UserData.shared.isLoggedIn {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            
            dateStringValue = formatter.string(from: currentDate)
            MessagesSocket.shared.addMessage(avatar: UserData.shared.avatarName, username: UserData.shared.username, Date: dateStringValue, message: chatTextField.stringValue, subChannelID: UserData.shared.subChannelID) { (res) in
                switch res {
                case .success(let messages):
                    DispatchQueue.main.async {
                        UserData.shared.avatarName = messages.avatar
                        UserData.shared.date = messages.date
                        UserData.shared.message = messages.message
                        UserData.shared.username = messages.username
                        UserData.shared.subChannelID = messages.subChannelID
                        
                        self.chatTextField.stringValue = ""
                        self.chatTableView.scrollRowToVisible(MessagesSocket.shared.messages.count - 1)
                        NotificationCenter.default.post(name: NEW_MESSAGE, object: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("log in")
        }
    }
}

extension ChatViewController: NSTableViewDelegate {
    
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
