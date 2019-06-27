//
//  FriendsOnlineViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class FriendsOnlineViewController: NSViewController {
    
    @IBOutlet weak var onlineTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        onlineTableView.dataSource = self
        onlineTableView.delegate = self
        loadData()
    }
    
    override func viewWillAppear() {
        getUsers()
    }
    
    func getUsers() {
        Users.shared.allUsers { (success) in
            if success {
                print("users got")
                self.onlineTableView.reloadData()
            } else {
                print("couldn't get all users")
            }
        }
    }
    
    func loadData() {
        onlineTableView.reloadData()
    }
}

extension FriendsOnlineViewController: NSTableViewDelegate {
    
}

extension FriendsOnlineViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if UserData.shared.isLoggedIn {
            return Users.shared.users.count
        } else {
        return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "onlineCell"), owner: nil) as? OnlineFriendsTableCell
            cell?.avatarImage.image = NSImage(named: Users.shared.users[row].avatar)
        cell?.usernameLabel.stringValue = Users.shared.users[row].username
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
}
