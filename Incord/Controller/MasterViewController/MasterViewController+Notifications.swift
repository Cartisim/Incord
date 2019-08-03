//
//  MasterViewController+Notifications.swift
//  Incord
//
//  Created by Cole M on 8/3/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

extension MasterViewController {
    
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
    
    @objc func clearChannels() {
        ChannelSocket.shared.channels.removeAll()
        channelCollectionView.reloadData()
        SubChannelSocket.shared.subchannels.removeAll()
        subChannelTableView.reloadData()
    }
    
    
}
