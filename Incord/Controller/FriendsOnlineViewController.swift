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
    
    var users = [CreateAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        onlineTableView.dataSource = self
        onlineTableView.delegate = self
        onlineTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(getUsers), name: GET_ALL_USERS, object: nil)
        NotificationCenter.default.post(name: GET_ALL_USERS, object: nil)
    }
    
      lazy var errorViewController: NSViewController = {
               return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
           }()
    
    @objc func getUsers() {
        Users.shared.allUsers { (res) in
            switch res {
            case .success(let users):
                users.forEach({ (user) in
                    DispatchQueue.main.async {
                        self.users = users
                        self.onlineTableView.reloadData()
                    }
                })
            case .failure(let err):
                print(err)
                 self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
            }
        }
    }
}

extension FriendsOnlineViewController: NSTableViewDelegate {
    
}

extension FriendsOnlineViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "onlineCell"), owner: nil) as? OnlineFriendsTableCell
        let user = users[row]
            cell?.avatarImage.image = NSImage(named: user.avatar)
        cell?.usernameLabel.stringValue = user.username
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
}
