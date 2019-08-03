//
//  MasterViewController+CollectionView.swift
//  Incord
//
//  Created by Cole M on 8/3/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

extension MasterViewController: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        clearSubChannel()
        if UserData.shared.isLoggedIn {
            if let indexPath = self.channelCollectionView.selectionIndexPaths.first?.item {
                Channels.shared.getChannel(channel: indexPath + 1) { (res) in
                    switch res {
                    case .success(let channel):
                        DispatchQueue.main.async {
                            UserData.shared.channel = channel.channel
                            UserData.shared.imageString = channel.imageString
                            UserData.shared.channelID = channel.id!
                            NotificationCenter.default.post(name: CHANNEL_DID_CHANGE, object: nil)
                            self.getSubChannels()
                        }
                    case .failure(let err):
                        print("There was an error selecting channel \(err)")
                        DispatchQueue.main.async {
                            self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                        }
                    }
                }
            }
        } else {
            view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController.self)
        }
    }
}

extension MasterViewController: NSCollectionViewDataSource  {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChannelSocket.shared.channels.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChannelCell"), for: indexPath)
        
        guard let channelCell = cell as? ChannelCell else { return cell }
        
        let url = URL(string: "\(CHANNEL_URL)/image/\(String(describing: ChannelSocket.shared.channels[indexPath.item].id!))/channelImage")!
        channelCell.channelLabel.stringValue = ChannelSocket.shared.channels[indexPath.item].channel
        channelCell.channelImage.load(url: url)
        return channelCell
    }
    
}
