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

    lazy var errorViewController: NSViewController = {
          return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
      }()
    
    lazy var mismatchViewController: NSViewController = {
       return self.storyboard!.instantiateController(withIdentifier: "MismatchVC") as! NSViewController
    }()
    
    lazy var logOutViewController: NSViewController = {
       return self.storyboard!.instantiateController(withIdentifier: "LogOutVC") as! NSViewController
    }()
    
    @IBAction func chooseAvatarClicked(_ sender: NSButton) {
        avatarPopover.contentViewController = AvatarViewController(nibName: "Avatars", bundle: nil)
        avatarPopover.show(relativeTo: avatarImageView.bounds, of: avatarImageView, preferredEdge: .minX)
        avatarPopover.behavior = .transient
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton) {
        self.progressIndicator.startAnimation(self)
        self.progressIndicator.isHidden = false
        if UserData.shared.isLoggedIn != true {
            if passwordTextField.stringValue == reEnterPasswordTextField.stringValue, userNameTextField.stringValue.isEmpty == false, emailTextField.stringValue.isEmpty == false {
                
                Authentication.shared.createUser(username: userNameTextField.stringValue, email: emailTextField.stringValue, password: passwordTextField.stringValue, avatar: UserData.shared.avatarName, completion: { (res) in
                    switch res {
                    case .success(let user):
                        print(user)
                        DispatchQueue.main.async {
                            Authentication.shared.login(email: self.emailTextField.stringValue, password: self.passwordTextField.stringValue, completion: { (res) in
                                switch res {
                                case .success(let login):
                                    DispatchQueue.main.async {
                                            Users.shared.currentUser(id: login.createAccountID) { (res) in
                                                             switch res {
                                                             case .success(let user):
                                                                 print(user.email)
                                                                 DispatchQueue.main.async {
                                                                     UserData.shared.avatarName = user.avatar
                                                                     UserData.shared.userEmail = user.email
                                                                     UserData.shared.id = user.id!.uuidString
                                                                     UserData.shared.username = user.username
                                                                     self.progressIndicator.stopAnimation(self)
                                                                     self.progressIndicator.isHidden = true
                                                                     NotificationCenter.default.post(name: NEW_CHANNEL, object: nil)
                                                                     NotificationCenter.default.post(name: USER_DATA_CHANGED, object: nil)
                                                                    NotificationCenter.default.post(name: GET_ALL_USERS, object: nil)
                                                                     self.dismiss(self)
                                                                 }
                                                             case .failure(let err):
                                                                 print(err)
                                                             }
                                                         }
                                        print(login)
                                    }
                                case .failure(let err):
                                    print(err)
                                    DispatchQueue.main.async {
                                    self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                                        self.progressIndicator.stopAnimation(self)
                                        self.progressIndicator.isHidden = true
                                    }
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
                 self.view.window?.contentViewController?.presentAsSheet(self.mismatchViewController)
            }
        } else {
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.isHidden = true
            view.window?.contentViewController?.presentAsSheet(logOutViewController)
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
