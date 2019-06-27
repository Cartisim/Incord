//
//  FriendsViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class FriendsViewController: NSViewController {
    
    @IBOutlet weak var friendsTableView: NSTableView!
    
    var clickBackground: BackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
        loadData()
    }
    override func viewWillAppear() {
        getUsers()
    }
    
    func getUsers() {
        Users.shared.allUsers { (success) in
            if success {
                print("users got")
                self.friendsTableView.reloadData()
            } else {
                print("couldn't get all users")
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
        return Users.shared.users.count
    }
    
    
     func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "friendsCell"), owner: nil) as? FriendsTableCell
        cell?.avatarImage.image = NSImage(named: Users.shared.users[row].avatar )
        cell?.usernameLabel.stringValue = Users.shared.users[row].username
        return cell
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80.0
    }
}
