//
//  MasterViewController.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa


class MasterViewController: NSViewController {

    @IBOutlet weak var channelCollectionView: NSScrollView!
    @IBOutlet weak var subChannelTableView: NSTableView!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var createAccountButton: NSButton!
    
    //Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
        
    }
    func setUpView() {
        channelCollectionView.wantsLayer = true
        channelCollectionView.layer?.backgroundColor = .clear
    }
    
    
    //SheetViewController
    lazy var createAccountViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "CreateAccount") as! NSViewController
    }()
    
    lazy var loginViewController: NSViewController = {
            return self.storyboard!.instantiateController(withIdentifier: "Login") as! NSViewController
    }()
    
    lazy var channelViewController: NSViewController = {
    return self.storyboard?.instantiateController(withIdentifier: "CreateChannel") as! NSViewController
    }()
    
    @IBAction func loginClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(loginViewController.self)
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(createAccountViewController.self)
    }
    
    @IBAction func createChannelClicked(_ sender: NSButton) {
        view.window?.contentViewController?.presentAsSheet(channelViewController)
    }
    
    
}
