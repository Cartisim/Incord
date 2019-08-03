//
//  FriendsViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class FriendsViewController: NSViewController {
    
    @IBOutlet weak var friendsTableView: NSTableView!
    
    var users = [CreateAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewWillAppear() {
        getUsers()
    }
    
    lazy var errorViewController: NSViewController = {
             return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
         }()
    
    func getUsers() {
        users.removeAll()
        Users.shared.allUsers { (res) in
            switch res {
            case .success(let users):
                users.forEach({ (user) in
                    DispatchQueue.main.async {
                        let user = CreateAccount(username: user.username, email:user.email, avatar: user.avatar)
                        self.users.append(user)
                        self.friendsTableView.reloadData()
                    }
                })
            case .failure(let err):
                print("There was an \(err)")
                 self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
            }
        }
    }
    
    func setUpView() {
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    
    @IBAction func closeSheetClicked(_ sender: NSButton) {
        dismiss(self)
    }
}

extension FriendsViewController: NSTableViewDelegate {
    
}

extension FriendsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return users.count
    }
    
    
     func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "friendsCell"), owner: nil) as? FriendsTableCell
        let user = users[row]
        cell?.avatarImage.image = NSImage(named: user.avatar )
        cell?.usernameLabel.stringValue = user.username
        return cell
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80.0
    }
}
