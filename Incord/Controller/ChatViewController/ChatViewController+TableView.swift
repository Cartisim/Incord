//
//  ChatViewController+TableView.swift
//  Incord
//
//  Created by Cole M on 8/3/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

extension ChatViewController: NSTableViewDelegate {
      
}

extension ChatViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessagesSocket.shared.messages.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "messageCell"), owner: nil) as? ChatTableCell
        let message = MessagesSocket.shared.messages[row]
        cell?.avatarImage.image = NSImage(named: message.avatar)
        cell?.dateLabel.stringValue = message.date
        cell?.usernameLabel.stringValue = message.username
        cell?.messageField.stringValue = message.message
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 150.0
    }
}
