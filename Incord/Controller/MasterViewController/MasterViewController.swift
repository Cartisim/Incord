//
//  MasterViewController.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {
    
    @IBOutlet weak var channelCollectionView: NSCollectionView!
    @IBOutlet weak var subChannelTableView: NSTableView!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var createAccountButton: NSButton!
    
    var rightVC: ChatViewController?
    static let shared = MasterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(newChannel), name: NEW_CHANNEL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newSubChannel), name: NEW_SUB_CHANNEL, object: nil)
    }

    func setUpView() {
        channelCollectionView.wantsLayer = true
        channelCollectionView.layer?.backgroundColor = .clear
        channelCollectionView.allowsEmptySelection = false
        subChannelTableView.doubleAction = #selector(doubleClickCell)
        subChannelTableView.dataSource = self
        subChannelTableView.delegate = self
        let deleteChannelMenu = NSMenu()
         deleteChannelMenu.addItem(withTitle: "Delete Image", action: #selector(deleteImage), keyEquivalent: "")
        channelCollectionView.menu = deleteChannelMenu
        let deleteSubChannelMenu = NSMenu()
        deleteSubChannelMenu.addItem(withTitle: "Delete SubChannel", action: #selector(deleteSubChannel), keyEquivalent: "")
        subChannelTableView.menu = deleteSubChannelMenu
        if UserData.shared.isLoggedIn {
                   getChannels()
               }
    }
    
    func getChannels() {
        Channels.shared.getChannels { (res) in
            switch res {
            case .success(let channels):
                channels.forEach({ (channel) in
                    DispatchQueue.main.async {
                        UserData.shared.channelID = channel.id!
                        UserData.shared.imageString = channel.imageString
                        UserData.shared.channel = channel.channel
                        
                        let channel = Channel(id: channel.id!, imageString: channel.imageString, channel: channel.channel)
                        ChannelSocket.shared.channels.append(channel)
                        self.channelCollectionView.reloadData()
                    }
                })
            case .failure(let err):
                print("There was an error \(err)")
            }
        }
    }
    
    func getSubChannels() {
        SubChannels.shared.getSubChannels(channelID: UserData.shared.channelID ) { (res) in
            switch res {
            case .success(let subchannels):
                subchannels.forEach({ (subchannel) in
                    DispatchQueue.main.async {
                        let subchannel = SubChannel(id: subchannel.id, title: subchannel.title, channelID: subchannel.channelID)
                        SubChannelSocket.shared.subchannels.append(subchannel)
                        self.subChannelTableView.reloadData()
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMessages() {
        Messages.shared.getMessages(subChannelID: UserData.shared.subChannelID) { (res) in
            switch res {
            case .success(let chats):
                chats.forEach({ (messages) in
                    DispatchQueue.main.async {
                        UserData.shared.avatarName = messages.avatar
                        UserData.shared.date = messages.date
                        UserData.shared.message = messages.message
                        UserData.shared.subChannelID = messages.subChannelID
                        UserData.shared.username = messages.username
                        UserData.shared.messageID = messages.id!
    
                        let messageData = Message(id: messages.id!, avatar: messages.avatar, username: messages.username, date: messages.date, message: messages.message, subChannelID: messages.subChannelID, createAccountID: messages.createAccountID)
                        MessagesSocket.shared.messages.append(messageData)
                        NotificationCenter.default.post(name: NEW_MESSAGE, object: nil)
                    }
                })
            case .failure(let err):
                print("fail- \(err)")
            }
        }
    }
    
    func clearChatView() {
        MessagesSocket.shared.messages.removeAll()
        //        self.rightVC?.chatTableView.reloadData()
        NotificationCenter.default.post(name: RELOAD, object: nil)
    }
    
    func clearChannels() {
          ChannelSocket.shared.channels.removeAll()
          channelCollectionView.reloadData()
          clearSubChannels()
      }
      
      func clearSubChannels() {
          SubChannelSocket.shared.subchannels.removeAll()
          subChannelTableView.reloadData()
      }
    
    //SheetViewController
    lazy var createAccountViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "CreateAccount") as! NSViewController
    }()
    
    lazy var loginViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "Login") as! NSViewController
    }()
    
    lazy var channelViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "CreateChannel") as! NSViewController
    }()
    
    lazy var subChannelViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "SubChannel") as! NSViewController
    }()
    
    lazy var pleaseLoginViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "PleaseLoginVC") as! NSViewController
    }()
    
    lazy var errorViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
    }()
    
    @IBAction func loginClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(loginViewController)
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(createAccountViewController)
    }
    
    @IBAction func createChannelClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(channelViewController)
    }
    
    @IBAction func createSubChannelClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(subChannelViewController)
    }
}

