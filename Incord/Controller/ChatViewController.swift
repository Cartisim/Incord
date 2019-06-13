//
//  ChatViewController.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ChatViewController: NSViewController {
    
    @IBOutlet weak var chatTextField: NSTextField!
    @IBOutlet weak var customButtonView: NSView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       setUpViewController()
    }
    
    func setUpViewController() {
        chatTextField.wantsLayer = true
        chatTextField.layer?.cornerRadius = 8
        customButtonView.wantsLayer = true
        customButtonView.layer?.cornerRadius = 8
    }
    
    @IBAction func AddFileClicked(_ sender: NSButton) {
    }
    
}
