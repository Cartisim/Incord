//
//  ChatViewController+Notifications.swift
//  Incord
//
//  Created by Cole M on 8/3/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

extension ChatViewController {
    
    @objc func reload() {
        chatTableView.reloadData()
    }
    
    @objc func deleteMessage() {
        
        if let indexPath = chatTableView?.selectedRow {
              if MessagesSocket.shared.messages[indexPath].createAccountID?.uuidString != UserData.shared.createAccountID {
                    print("break it")
                 self.view.window?.contentViewController?.presentAsSheet(self.deleteViewController)
              } else {
                 print("thats true")
                 Messages.shared.getMessage(messageID: UserData.shared.messageID) { (res) in
                     switch res {
                     case .success(let messages):
                         print(messages.createAccountID as Any)
                         print(UserData.shared.createAccountID)
                         DispatchQueue.main.async {
                             let uuid = UUID(uuidString: UserData.shared.createAccountID)
                             if  messages.createAccountID?.uuidString == UserData.shared.createAccountID {
                                 Message(id: UserData.shared.messageID, avatar: UserData.shared.avatarName, username: UserData.shared.username, date: UserData.shared.date, message: UserData.shared.message, subChannelID: UserData.shared.subChannelID, createAccountID: uuid).deleteMessage(id: UserData.shared.messageID) { (res) in
                                     switch res {
                                     case .success:
                                         DispatchQueue.main.async {
                                             MessagesSocket.shared.messages.removeAll()
                                             MasterViewController.shared.getMessages()
                                             self.chatTableView.reloadData()
                                         }
                                     case .failure:
                                         print("failure")
                                         DispatchQueue.main.async {
                                             self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                                         }
                                     }
                                 }
                             } else {
                                 print("No go")
                               
                             }
                         }
                     case .failure(let err):
                         print(err)
                         
                     }
                 }
              }
            }
        
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        let uuid = UUID(uuidString: UserData.shared.createAccountID)!
        Users.shared.currentUser(id: uuid) { (res) in
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
                DispatchQueue.main.async {
                    self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                }
            }
        }
    }
    
    @objc func newMessage() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            self.chatTableView.scrollRowToVisible(MessagesSocket.shared.messages.count - 1)
        }
    }
    
    @objc func userLoggedIn() {
        if UserData.shared.isLoggedIn {
            NotificationCenter.default.post(name: USER_DATA_CHANGED, object: nil)
            profileImageButton.image = NSImage(named: UserData.shared.avatarName)
        } else {
            profileImageButton.image = NSImage(named: "avatar1")
        }
    }
}
