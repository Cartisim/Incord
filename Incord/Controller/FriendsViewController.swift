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
    
    var clickBackground: BackgroundView!
    var users = [CreateAccount]()
    var user: CreateAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
    }
    override func viewWillAppear() {
        getUsers()
    }
    
    func getUsers() {
        Users.shared.allUsers { (res) in
            switch res {
            case .success(let users):
                users.forEach({ (user) in
                    print(user.avatar, user.email, user.id as Any, user.username)
                    DispatchQueue.main.async {
                        self.users = users
                        self.friendsTableView.reloadData()
                    }
                })
            case .failure(let err):
                print("There was an \(err)")
            }
        }
    }
    
    func setUpView() {
        clickBackground = BackgroundView()
        clickBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickBackground, positioned: .above, relativeTo: friendsTableView)
        let topCn = NSLayoutConstraint(item: clickBackground!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 380)
        let leftCn = NSLayoutConstraint(item: clickBackground!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightCn = NSLayoutConstraint(item: clickBackground!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottomCn = NSLayoutConstraint(item: clickBackground!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([topCn, leftCn, rightCn, bottomCn])
        let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(closeModalClick(_:)))
        clickBackground.addGestureRecognizer(closeBackgroundClick)
        clickBackground.wantsLayer = true
        clickBackground.layer?.backgroundColor = NSColor.cyan.cgColor
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        print("clicked")
        dismiss(self)
    }
    
    func loadData() {
        friendsTableView.reloadData()
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
