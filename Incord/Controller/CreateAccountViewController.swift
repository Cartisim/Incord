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
        avatarImageView.image = NSImage(named: avatarString)
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
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
                        DispatchQueue.main.async {
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
                        }
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
    
    @IBAction func closeSheetClicked(_ sender: NSButton) {
          dismiss(self)
    }
    
    
    @IBAction func createAccountOnEnterClicked(_ sender: NSTextField) {
//                createAccountButton.performClick(nil)
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
