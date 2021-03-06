//
//  ProfileViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ProfileViewController: NSViewController {
    
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var reEnterPasswordTextField: NSSecureTextField!
    @IBOutlet weak var avatarImage: NSImageView!
    @IBOutlet weak var updateAccountButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    let avatarPopover = NSPopover()
    var avatarString = "avatar1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear() {
        getCurrentUser()
    }
    
    func setUpView() {
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
        avatarPopover.delegate = self
    }
    
    func getCurrentUser() {
        if UserData.shared.isLoggedIn {
            let uuid = UUID(uuidString: UserData.shared.createAccountID)
            Users.shared.currentUser(id: uuid!) { (res) in
                switch res {
                case .success(let user):
                    print(user)
                    DispatchQueue.main.async {
                        self.usernameTextField.stringValue = user.username
                        self.emailTextField.stringValue = user.email
                        self.avatarImage.image = NSImage(named: user.avatar)
                    }
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            avatarImage.image = NSImage(named: avatarString)
            usernameTextField.stringValue = ""
            emailTextField.stringValue = ""
            print("not logged")
        }
    }
    
    lazy var mismatchViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "MismatchVC") as! NSViewController
    }()
    
    lazy var passswordViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "PasswordVC") as! NSViewController
    }()
    
    lazy var errorViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
    }()
    
    @IBAction func closeSheetClicked(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func updateAccountOnEnterClicked(_ sender: NSTextField) {
        //        updateAccountButton.performClick(nil)
    }
    
    @IBAction func updateAccountClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn && reEnterPasswordTextField.stringValue.isEmpty == false, passwordTextField.stringValue.isEmpty == false, usernameTextField.stringValue.isEmpty == false, emailTextField.stringValue.isEmpty == false {
            self.progressIndicator.startAnimation(self)
            self.progressIndicator.isHidden = false
            if passwordTextField.stringValue == reEnterPasswordTextField.stringValue {
                Users.shared.updateUser(username: usernameTextField.stringValue, email: emailTextField.stringValue, password: passwordTextField.stringValue, avatar: UserData.shared.avatarName) { (res) in
                    switch res {
                    case .success(let updatedProfile):
                        print("success \(updatedProfile)")
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: USER_DATA_CHANGED, object: nil)
                            NotificationCenter.default.post(name: GET_ALL_USERS, object: nil)
                            self.progressIndicator.stopAnimation(self)
                            self.progressIndicator.isHidden = true
                            self.dismiss(self)
                        }
                    case .failure(let err):
                        print(err)
                        DispatchQueue.main.async {
                            self.progressIndicator.stopAnimation(self)
                            self.progressIndicator.isHidden = true
                            self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                        }
                    }
                }
            } else {
                print("passwords must match")
                progressIndicator.stopAnimation(self)
                progressIndicator.isHidden = true
                view.window?.contentViewController?.presentAsSheet(passswordViewController)
            }
        } else {
            print("please login")
            view.window?.contentViewController?.presentAsSheet(mismatchViewController)
        }
    }
    
    @IBAction func changeImageClicked(_ sender: NSButton) {
        avatarPopover.contentViewController = AvatarViewController(nibName: "Avatars", bundle: nil)
        avatarPopover.show(relativeTo: avatarImage.bounds, of: avatarImage, preferredEdge: .minX)
        avatarPopover.behavior = .transient
    }
}

extension ProfileViewController: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        if UserData.shared.avatarName != "" {
            avatarImage.image = NSImage(named: UserData.shared.avatarName)
            avatarString = UserData.shared.avatarName
        }
    }
}
