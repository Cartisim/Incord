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
    
    var clickBackground: BackgroundView!
    var channelIdent: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
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
    
    @IBAction func createSubChannelClicked(_ sender: NSButton) {
        SubChannels.shared.addSubChannel(title: subChannelTextField.stringValue, channelID: UserData.shared.channelID, completion: { (res) in
            switch res {
            case .success(let subChannel):
                DispatchQueue.main.async {
                UserData.shared.subChannelID = subChannel.id!
                NotificationCenter.default.post(name: RELOAD_TABLEVIEW, object: nil)
                self.dismiss(self)
                }
            case .failure(let err):
                print(err)
            }
        })
    }
}
