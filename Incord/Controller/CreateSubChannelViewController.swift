//
//  CreateSubChannelViewController.swift
//  Incord
//
//  Created by Cole M on 7/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class CreateSubChannelViewController: NSViewController {
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var subChannelTextField: NSTextField!
    @IBOutlet weak var subChannelButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidDisappear() {
        subChannelTextField.stringValue = ""
    }
    
    func setUpView() {
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
    }
    
    lazy var pleaseLoginViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "PleaseLoginVC") as! NSViewController
    }()
    
    lazy var mismatchViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "MismatchVC") as! NSViewController
    }()
    
    lazy var errorViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
    }()
    
    @IBAction func closeSheetClicked(_ sender: NSButton) {
       dismiss(self)
        
    }
    @IBAction func subChannelTextFieldEntered(_ sender: NSTextField) {
//        subChannelButton.performClick(nil)
    }
    
    @IBAction func createSubChannelClicked(_ sender: NSButton) {
       if UserData.shared.isLoggedIn && subChannelTextField.stringValue.isEmpty == false {
            SubChannelSocket.shared.addSubChannel(id: UserData.shared.subChannelID, title: subChannelTextField.stringValue, channelID: UserData.shared.channelID, completion: { (res) in
                switch res {
                case .success(let subChannel):
                    DispatchQueue.main.async {
                        UserData.shared.subChannelID = subChannel.id!
                        UserData.shared.subChannel = subChannel.title
                        self.dismiss(self)
                    }
                case .failure(let err):
                    print(err)
                    self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                }
            })
       } else if subChannelTextField.stringValue.isEmpty {
        view.window?.contentViewController?.presentAsSheet(mismatchViewController)
       } else {
        view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
    }
}
