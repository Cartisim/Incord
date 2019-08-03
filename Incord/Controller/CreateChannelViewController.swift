//
//  CreateChannelViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa


class CreateChannelViewController: NSViewController {
    
    @IBOutlet weak var createChannelTextField: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var channelButton: NSButton!
    
    var channels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidDisappear() {
        createChannelTextField.stringValue = ""
    }
    func setUpView() {
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
    }

    @IBAction func closeSheetClicked(_ sender: NSButton) {
        dismiss(self)
    }
    
    lazy var imageViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ChooseImage") as! NSViewController
    }()
    
    lazy var pleaseLoginViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "PleaseLoginVC") as! NSViewController
     }()
    
    lazy var mismatchViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "MismatchVC") as! NSViewController
    }()
    
    lazy var errorViewController: NSViewController = {
             return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
         }()
    
    @IBAction func createChannelOnEnterClicked(_ sender: NSTextField) {
//                channelButton.performClick(nil)
    }
    
    @IBAction func createChannelClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn && createChannelTextField.stringValue.isEmpty == false {
            print(createChannelTextField.stringValue.isEmpty)
            ChannelSocket.shared.addChannel(id: UserData.shared.channelID, image: "", channelName: createChannelTextField.stringValue, completion: { (res) in
                switch res {
                case .success(let channel):
                    DispatchQueue.main.async {
                        UserData.shared.channel = channel.channel
                        UserData.shared.channelID = channel.id! + 1
                        UserData.shared.imageString = channel.imageString
                        self.view.window?.contentViewController?.presentAsSheet(self.imageViewController)
                    }
                    print(channel)
                case .failure(let err):
                    DispatchQueue.main.async {
                        print(err)
                         self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                    }
                }
            })
        } else if createChannelTextField.stringValue.isEmpty {
            view.window?.contentViewController?.presentAsSheet(mismatchViewController)
        } else {
            print("please login")
            view.window?.contentViewController?.presentAsSheet(pleaseLoginViewController)
        }
    }
}
