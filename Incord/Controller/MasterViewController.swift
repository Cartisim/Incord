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
        print("loaded \(UserData.shared.channelID)")
    }
    override func viewWillAppear() {
        getChannels()
    }
    
    func setUpView() {
        channelCollectionView.wantsLayer = true
        channelCollectionView.layer?.backgroundColor = .clear
        subChannelTableView.doubleAction = #selector(doubleClickCell)
        subChannelTableView.dataSource = self
        subChannelTableView.delegate = self
       
        NotificationCenter.default.addObserver(self, selector: #selector(newChannel), name: NEW_CHANNEL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newSubChannel), name: NEW_SUB_CHANNEL, object: nil)
        let deleteChannelMenu = NSMenu()
        deleteChannelMenu.addItem(withTitle: "Delete Channel", action: #selector(deleteChannel), keyEquivalent: "")
        channelCollectionView.menu = deleteChannelMenu
        let deleteSubChannelMenu = NSMenu()
        deleteSubChannelMenu.addItem(withTitle: "Delete SubChannel", action: #selector(deleteSubChannel), keyEquivalent: "")
        subChannelTableView.menu = deleteSubChannelMenu
    }
    
    @objc func newChannel(_ notif: Notification) {
        DispatchQueue.main.async {
            ChannelSocket.shared.channels.removeAll()
            self.getChannels()
            self.channelCollectionView.reloadData()
        }
    }
    
    @objc func newSubChannel(_ notif: Notification) {
        DispatchQueue.main.async {
            SubChannelSocket.shared.subchannels.removeAll()
            self.getSubChannels()
            self.subChannelTableView.reloadData()
        }
    }
    
    @objc func deleteChannel() {
        ChannelSocket.shared.channels.removeAll()
        Channel(id: UserData.shared.channelID, imageString: UserData.shared.imageString, channel: UserData.shared.channel).deleteChannel(id: UserData.shared.channelID) { (res) in
            DispatchQueue.main.async {
                switch res {
                case .success:
                    ChannelSocket.shared.channels.removeAll()
                    self.getChannels()
                    self.channelCollectionView.reloadData()
                case .failure:
                    print("failure")
                }
            }
        }
    }
    
    @objc func deleteSubChannel() {
        SubChannelSocket.shared.subchannels.removeAll()
        SubChannel(id: UserData.shared.subChannelID, title: UserData.shared.subChannel, channelID: UserData.shared.channelID).deleteSubChannel(id: UserData.shared.subChannelID) { (res) in
            switch res {
            case .success:
                NotificationCenter.default.post(name: NEW_SUB_CHANNEL, object: nil)
            case .failure:
                print("failure")
            }
        }
        
    }
    
    @objc func doubleClickCell(sender: Any) {
        clearChatView()
        if let indexPath = subChannelTableView?.selectedRow {
            let subChannel = SubChannelSocket.shared.subchannels[indexPath]
            UserData.shared.subChannel = subChannel.title
            NotificationCenter.default.post(name: SUB_CHANNEL_DID_CHANGE, object: nil)
            UserData.shared.subChannelID = subChannel.id!
            getMessages()
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
                        
                        let messageData = Message(id: messages.id!, avatar: messages.avatar, username: messages.username, date: messages.date, message: messages.message, subChannelID: messages.subChannelID)
                        MessagesSocket.shared.messages.append(messageData)
                        NotificationCenter.default.post(name: NEW_MESSAGE, object: nil)
                    }
                })
            case .failure(let err):
                print("fail- \(err)")
            }
        }
    }
    
    func clearChannels() {
        ChannelSocket.shared.channels.removeAll()
        channelCollectionView.reloadData()
    }
    
    func clearSubChannel() {
        clearChatView()
        SubChannelSocket.shared.subchannels.removeAll()
        subChannelTableView.reloadData()
    }
    
    func clearChatView() {
        MessagesSocket.shared.messages.removeAll()
        self.rightVC?.chatTableView.reloadData()
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
    
    @IBAction func loginClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(loginViewController.self)
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(createAccountViewController.self)
    }
    
    @IBAction func createChannelClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(channelViewController)
    }
    
    @IBAction func createSubChannelClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(subChannelViewController)
    }
}

extension MasterViewController: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        clearSubChannel()
        if let indexPath = self.channelCollectionView.selectionIndexPaths.first?.item {
            Channels.shared.getChannel(channel: indexPath + 1) { (res) in
                switch res {
                case .success(let channel):
                    DispatchQueue.main.async {
                        UserData.shared.channel = channel.channel
                        UserData.shared.imageString = channel.imageString
                        UserData.shared.channelID = channel.id!
                        NotificationCenter.default.post(name: CHANNEL_DID_CHANGE, object: nil)
                        self.getSubChannels()
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
}


extension MasterViewController: NSCollectionViewDataSource  {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChannelSocket.shared.channels.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChannelCell"), for: indexPath)
        
        guard let channelCell = cell as? ChannelCell else { return cell }
        
        let url = URL(string: "\(CHANNEL_URL)/image/\(String(describing: ChannelSocket.shared.channels[indexPath.item].id!))/channelImage")!
        channelCell.channelLabel.stringValue = ChannelSocket.shared.channels[indexPath.item].channel
        channelCell.channelImage.load(url: url)
        return channelCell
    }
    
}

extension MasterViewController: NSTableViewDelegate {
    
}

extension MasterViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return SubChannelSocket.shared.subchannels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "subChannel"), owner: self) as! NSTableCellView?
        cell?.textField?.stringValue = "#\( SubChannelSocket.shared.subchannels[row].title)"
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
}

