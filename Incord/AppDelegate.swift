//
//  AppDelegate.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
import KeychainSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        guard UserData.shared.token == nil else { return true }
        print(UserData.shared.token)
        
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
//        WebSockets.shared.socketConnected()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
//        WebSockets.shared.socketDisconnect()
    }


}

