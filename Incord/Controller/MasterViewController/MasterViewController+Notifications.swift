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
            self.clearSubChannels()
            self.getSubChannels()
        }
    }
    
    @objc func clearController(_ notif: Notification) {
        DispatchQueue.main.async {
   self.clearChannels()
      self.clearSubChannels()
        }
    }
    
    func deleteChannel() {
        Channel(id: UserData.shared.channelID, imageString: UserData.shared.imageString, channel: UserData.shared.channel).deleteChannel(id: UserData.shared.channelID) { (res) in
            switch res {
            case .success:
                print("success")
                DispatchQueue.main.async {
                    self.getChannels()
                    self.clearChannels()
                    NotificationCenter.default.post(name: CHANNEL_DID_CHANGE, object: nil)
                    NotificationCenter.default.post(name: CLEAR_CHANNELS, object: nil)
                }
            case .failure:
                print("failured")
            
        }
    }
    }
    
    @objc func deleteChannelImage() {
       
        if UserData.shared.imgData.isEmpty {
             print("delete channel")
            deleteChannel()
        } else {
             print(UserData.shared.imgData)
            ChannelImage(image: UserData.shared.imgData).deleteImage(id: UserData.shared.channelID) { (res) in
                           switch res {
                           case .success:
                               print("success")
                               DispatchQueue.main.async {
                                   self.getChannels()
                                   self.clearChannels()
                                   NotificationCenter.default.post(name: CHANNEL_DID_CHANGE, object: nil)
                                   NotificationCenter.default.post(name: CLEAR_CHANNELS, object: nil)
                                   
                                   self.deleteChannel()
                                   
                               }
                           case .failure:
                               print("failure")
                           }
                       }
        }
    }
    
    
    @objc func deleteSubChannel() {
        SubChannel(id: UserData.shared.subChannelID, title: UserData.shared.subChannel, channelID: UserData.shared.channelID).deleteSubChannel(id: UserData.shared.subChannelID) { (res) in
            switch res {
            case .success:
                SubChannelSocket.shared.subchannels.removeAll()
                NotificationCenter.default.post(name: NEW_SUB_CHANNEL, object: nil)
            case .failure:
                print("failure")
            }
        }
    }
    
}
