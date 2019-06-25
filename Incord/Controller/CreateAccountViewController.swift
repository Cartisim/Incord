//
//  CreateAccountViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import KeychainSwift

class CreateAccountViewController: NSViewController {
    
    
    @IBOutlet weak var userNameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var reEnterPasswordTextField: NSTextField!
    @IBOutlet weak var avatarImageView: NSImageView!
    @IBOutlet weak var createAccountButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var clickBackground: BackgroundView!
    let avatarPopover = NSPopover()
    var avatarString = "avatar1"
    
    static let shared = CreateAccountViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
        avatarPopover.delegate = self
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
    }
    
    func setUpView() {
        clickBackground = BackgroundView()
        clickBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickBackground, positioned: .above, relativeTo: view)
        let topCn = NSLayoutConstraint(item: clickBackground!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 330)
        let leftCn = NSLayoutConstraint(item: clickBackground!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightCn = NSLayoutConstraint(item: clickBackground!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottomCn = NSLayoutConstraint(item: clickBackground!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([topCn, leftCn, rightCn, bottomCn])
        let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(closeModalClick(_:)))
        
        clickBackground.addGestureRecognizer(closeBackgroundClick)
        clickBackground.wantsLayer = true
        clickBackground.layer?.backgroundColor = NSColor.cyan.cgColor
        avatarImageView.image = NSImage(named: avatarString)
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        dismiss(self)
    }
    @IBAction func chooseAvatarClicked(_ sender: NSButton) {
        
        
        avatarPopover.contentViewController = AvatarViewController(nibName: "Avatars", bundle: nil)
        avatarPopover.show(relativeTo: avatarImageView.bounds, of: avatarImageView, preferredEdge: .minX)
        avatarPopover.behavior = .transient
        
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton) {
            Authentication.shared.createUser(username: userNameTextField.stringValue, email: emailTextField.stringValue, password: passwordTextField.stringValue, avatar: Authentication.shared.avatarName, completion: { (success) in
                if success {
                    print(Authentication.shared.keychain.get(Authentication.shared.token) ?? "Empty")
                          self.dismiss(self)
                } else {
                    print("failed to authenticate")
                }
            })
    }
    
    
    
    @IBAction func createAccountOnEnterClicked(_ sender: NSTextField) {
//        reEnterPasswordTextField.performClick(nil)
    }
}

extension CreateAccountViewController: NSPopoverDelegate {
    
    func popoverDidClose(_ notification: Notification) {
        if Authentication.shared.avatarName != "" {
            avatarImageView.image = NSImage(named: Authentication.shared.avatarName)
            avatarString = Authentication.shared.avatarName
        }
    }
}
