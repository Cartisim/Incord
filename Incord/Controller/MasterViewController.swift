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
    
    //Variables
    
    var rightVC: ChatViewController?
    static let shared = MasterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subChannelTableView.dataSource = self
        subChannelTableView.delegate = self
    }
    override func viewWillAppear() {
        if UserData.shared.isLoggedIn {
            getAllChannels()
        }
        setUpView()
    }
    
    func setUpView() {
        channelCollectionView.wantsLayer = true
        channelCollectionView.layer?.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: RELOAD_COLLECTION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: RELOAD_TABLEVIEW, object: nil)
        subChannelTableView.doubleAction = #selector(doubleClickCell)
    }
    
    //Reload Method From Sheet View
    @objc func reloadCollection(_ notif: Notification) {
        DispatchQueue.main.async {
            self.getAllChannels()
            self.channelCollectionView.reloadData()
        }
    }
    
    //Reload Method from SHeet View
    @objc func reloadTableView(_ notif: Notification) {
        DispatchQueue.main.async {
            self.getAllSubChannels()
            self.subChannelTableView.reloadData()
        }
    }
    
    @objc func doubleClickCell(sender: Any) {
        MessagesSocket.shared.messages.removeAll()
        self.rightVC?.chatTableView.reloadData()
        if let indexPath = subChannelTableView?.selectedRow {
            let subChannel = SubChannelSocket.shared.subchannels[indexPath]
            UserData.shared.subChannel = subChannel.title
            NotificationCenter.default.post(name: SUB_CHANNEL_DID_CHANGE, object: nil)
            UserData.shared.subChannelID = subChannel.id!
            Messages.shared.getMessages(subChannelID: UserData.shared.subChannelID) { (res) in
                switch res {
                case .success(let chats):
                    chats.forEach({ (messages) in
                        DispatchQueue.main.async {
                            let avatarName = messages.avatar
                            let dateLabel = messages.date
                            let messageLabel = messages.message
                            let subchannelInt = messages.subChannelID
                            let usernameLabel = messages.username
                            let messageData = Message(avatar: avatarName, username: usernameLabel, date: dateLabel, message: messageLabel, subChannelID: subchannelInt)
                            MessagesSocket.shared.messages.append(messageData)
                            self.rightVC?.chatTableView.reloadData()
                            self.rightVC?.chatTableView.scrollRowToVisible(MessagesSocket.shared.messages.count - 1)
                            if  messages.username.isEmpty {
                                MessagesSocket.shared.messages.removeAll()
                                self.rightVC?.chatTableView.reloadData()
                            }
                        }
                    })
                case .failure(let err):
                    print("fail- \(err)")
                }
            }
        }
    }
    
    func getAllChannels() {
        Channels.shared.getChannels { (res) in
            switch res {
            case .success(let channels):
                channels.forEach({ (channel) in
                    DispatchQueue.main.async {
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
    
    func getAllSubChannels() {
        
        SubChannels.shared.getSubChannels(channelID: UserData.shared.channelID ) { (res) in
            switch res {
            case .success(let subchannels):
                subchannels.forEach({ (subchannel) in
                    DispatchQueue.main.async {
                        SubChannelSocket.shared.subchannels = subchannels
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
        //           SocketConnection.shared.closeConnection()
        view.window?.contentViewController?.presentAsSheet(channelViewController)
    }
    
    @IBAction func createSubChannelClicked(_ sender: NSButton) {
        view.window?.contentViewController?
            .presentAsSheet(subChannelViewController)
    }
}



extension MasterViewController: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        if let itemIndex = self.channelCollectionView.selectionIndexPaths.first?.item {
            Channels.shared.getChannel(channel: itemIndex + 1) { (res) in
                switch res {
                case .success(let channel):
                    DispatchQueue.main.async {
                        UserData.shared.channel = channel.channel
                        UserData.shared.channelID = channel.id!
                        NotificationCenter.default.post(name: CHANNEL_DID_CHANGE, object: nil)
                        self.getAllSubChannels()
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
        guard let channelCell = cell as? ChannelCell else { return NSCollectionViewItem() }
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
        return SubChannelSocket.shared.subchannels.count - 1
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

extension NSImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = NSImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

