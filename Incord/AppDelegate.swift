//
//  AppDelegate.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        SocketConnection.shared.connectToSocket()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        SocketConnection.shared.closeConnection()
        ChannelSocket.shared.closeChannelConnection()
        SubChannelSocket.shared.closeSubChannelConnection()
        MessagesSocket.shared.closeMessageConnection()
    }
    
}

