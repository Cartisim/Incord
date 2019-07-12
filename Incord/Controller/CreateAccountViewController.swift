//
//  CreateAccountViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
import KeychainSwift

class CreateAccountViewController: NSViewController {
    
    
    @IBOutlet weak var userNameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var reEnterPasswordTextField: NSSecureTextField!
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
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
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
        self.progressIndicator.startAnimation(self)
        self.progressIndicator.isHidden = false
        if UserData.shared.isLoggedIn != true {
            if passwordTextField.stringValue == reEnterPasswordTextField.stringValue {
                
                Authentication.shared.createUser(username: userNameTextField.stringValue, email: emailTextField.stringValue, password: passwordTextField.stringValue, avatar: UserData.shared.avatarName, completion: { (res) in
                    switch res {
                    case .success(let user):
                            print(user)
                            Authentication.shared.login(email: self.emailTextField.stringValue, password: self.passwordTextField.stringValue, completion: { (res) in
                                switch res {
                                case .success(let login):
                                    DispatchQueue.main.async {
                                     NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                     self.progressIndicator.stopAnimation(self)
                                     self.progressIndicator.isHidden = true
                                     self.dismiss(self)
                                    print(login)
                                    }
                                case .failure(let err):
                                    print(err)
                                }
                            })
                    case .failure(let err):
                        print(err)
                        DispatchQueue.main.async {
                            self.progressIndicator.stopAnimation(self)
                            self.progressIndicator.isHidden = true
                        }
                    }
                })
            } else {
                print("passwords must match")
                self.progressIndicator.stopAnimation(self)
                self.progressIndicator.isHidden = true
            }
        } else {
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.isHidden = true
            print("Please log out to create user")
            dismiss(self)
        }
    }

    @IBAction func createAccountOnEnterClicked(_ sender: NSTextField) {
        //        reEnterPasswordTextField.performClick(nil)
    }
}

extension CreateAccountViewController: NSPopoverDelegate {
    
    func popoverDidClose(_ notification: Notification) {
        if UserData.shared.avatarName != "" {
            avatarImageView.image = NSImage(named:  UserData.shared.avatarName)
            avatarString = UserData.shared.avatarName
        }
    }
}
