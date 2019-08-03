//
//  MasterViewController+TableView.swift
//  Incord
//
//  Created by Cole M on 8/3/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
    
    extension MasterViewController: NSTableViewDelegate {
        
    }

    extension MasterViewController: NSTableViewDataSource {
        
        @objc func doubleClickCell(sender: Any) {
            clearChatView()
            if let indexPath = subChannelTableView?.selectedRow, subChannelTableView!.selectedRow >= 0 {
                let subChannel = SubChannelSocket.shared.subchannels[indexPath]
                UserData.shared.subChannel = subChannel.title
                NotificationCenter.default.post(name: SUB_CHANNEL_DID_CHANGE, object: nil)
                UserData.shared.subChannelID = subChannel.id!
                getMessages()
            }
        }
        
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
