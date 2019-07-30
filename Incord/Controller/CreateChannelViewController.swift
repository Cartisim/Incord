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
    
   
    var clickBackground: BackgroundView!
    var channels = [Channel]()
    var channel: Channel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
    }
    
    override func viewDidDisappear() {
          createChannelTextField.stringValue = ""
    }
    func setUpView() {
        clickBackground = BackgroundView()
        clickBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickBackground, positioned: .above, relativeTo: view)
        let topCn = NSLayoutConstraint(item: clickBackground!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 240)
        let leftCn = NSLayoutConstraint(item: clickBackground!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightCn = NSLayoutConstraint(item: clickBackground!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottomCn = NSLayoutConstraint(item: clickBackground!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([topCn, leftCn, rightCn, bottomCn])
        let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(closeModalClick(_:)))
        clickBackground.addGestureRecognizer(closeBackgroundClick)
        clickBackground.wantsLayer = true
        clickBackground.layer?.backgroundColor = NSColor.cyan.cgColor
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        dismiss(self)
    }
    
    lazy var imageViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ChooseImage") as! NSViewController
    }()
    
    
    @IBAction func createChannelOnEnterClicked(_ sender: NSTextField) {
        //        createChannelTextField.performClick(nil)
    }
    
    @IBAction func createChannelClicked(_ sender: NSButton) {
        if UserData.shared
            .isLoggedIn {
            ChannelSocket.shared.addChannel(image: channel?.imageString ?? "", channel: createChannelTextField.stringValue, completion: { (res) in
            switch res {
            case .success(let channel):
                DispatchQueue.main.async {
                            print(channel)
                    self.view.window?.contentViewController?.presentAsSheet(self.imageViewController)
                }
            case .failure(let err):
                DispatchQueue.main.async {
                      print("res")
                    print(err)
                }
            }
        })
    }
    }
}
