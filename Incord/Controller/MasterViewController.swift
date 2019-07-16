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
    var channels = [Channel]()
    var channel: Channel?
    var images = [ChannelImage]()
    var subchannels = [SubChannel]()
    var subchannel: SubChannel?
    var messages = [Message]()
    var rightVC: ChatViewController?
    static let shared = MasterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subChannelTableView.dataSource = self
        subChannelTableView.delegate = self
    }
    
    override func viewWillAppear() {
        getAllChannels()
        setUpView()
    }
    
    func setUpView() {
        channelCollectionView.wantsLayer = true
        channelCollectionView.layer?.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: RELOAD_COLLECTION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: RELOAD_TABLEVIEW, object: nil)
        subChannelTableView.doubleAction = #selector(doubleClickCell)
    }
    
    @objc func reloadCollection(_ notif: Notification) {
        DispatchQueue.main.async {
            print("reloaded")
            self.getAllChannels()
            self.channelCollectionView.reloadData()
        }
    }
    
    @objc func reloadTableView(_ notif: Notification) {
        DispatchQueue.main.async {
            print("reloaded")
            self.getAllSubChannels()
            self.channelCollectionView.reloadData()
        }
    }
    
    @objc func doubleClickCell(sender: Any) {
        if let indexPath = subChannelTableView?.selectedRow {
            let subChannel = subchannels[indexPath]
            UserData.shared.subChannel = subChannel.title
            NotificationCenter.default.post(name: SUB_CHANNEL_DID_CHANGE, object: nil)
            UserData.shared.subChannelID = subChannel.id!
            Messages.shared.getMessages(subChannelID: UserData.shared.subChannelID) { (res) in
                switch res {
                case .success(let chats):
                    chats.forEach({ (messages) in
                        DispatchQueue.main.async {
                            self.rightVC?.messages = chats
                             self.rightVC?.chatTableView.reloadData()
                            if  messages.username.isEmpty {
                                print("remove")
                                self.rightVC?.messages.removeAll()
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
                        self.channels = channels
                        self.channelCollectionView.reloadData()
                    }
                })
            case .failure(let err):
                print("There was an error \(err)")
            }
        }
    }
    
    func getAllSubChannels() {
        let index = channelCollectionView.selectionIndexes.first
        SubChannels.shared.getSubChannels(channelID: index!) { (res) in
            switch res {
            case .success(let subchannels):
                subchannels.forEach({ (subchannel) in
                    DispatchQueue.main.async {
                        self.subchannels = subchannels
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
            Channels.shared.getChannel(channel: itemIndex) { (res) in
                switch res {
                case .success(let channel):
                    print(channel)
                    DispatchQueue.main.async {
                        self.channel?.channel = channel.channel
                        UserData.shared.channel = self.channels[itemIndex].channel
                        UserData.shared.channelID = self.channels[itemIndex].id!
                        print("channel name \( UserData.shared.channelID)")
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
        return channels.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChannelCell"), for: indexPath)
        guard let channelCell = cell as? ChannelCell else { return NSCollectionViewItem() }
        
        let url = URL(string: "\(CHANNEL_URL)/image/\(String(describing: channels[indexPath.item].id!))/channelImage")! 
        print(url)
        print(channels[indexPath.item].channel)
        channelCell.channelLabel.stringValue = channels[indexPath.item].channel
        channelCell.channelImage.load(url: url)
        return channelCell
    }
    
}

extension MasterViewController: NSTableViewDelegate {
    
}

extension MasterViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return subchannels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "subChannel"), owner: self) as! NSTableCellView?
        cell?.textField?.stringValue = "#\(subchannels[row].title)"
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
