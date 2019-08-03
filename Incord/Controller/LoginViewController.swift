//
//  LoginViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    
    var account = [CreateAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear() {
        setUpView()
    }
    
    
    func setUpView() {
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
        if UserData.shared.isLoggedIn != true {
            emailTextField.stringValue = ""
            passwordTextField.stringValue  = ""
            statusLabel.stringValue = "Not Logged in"
        } else {
            emailTextField.stringValue = UserData.shared.userEmail
            passwordTextField.stringValue  = ""
            statusLabel.stringValue = "Logged In"
        }
    }
    
    lazy var errorViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
    }()
    
    lazy var loggedInViewController: NSViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "LoggedInVC") as! NSViewController
    }()
    
    @IBAction func closhSheetClicked(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func loginClicked(_ sender: NSButton) {
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)
        
        if UserData.shared.isLoggedIn == false {
            Authentication.shared.login(email: emailTextField.stringValue, password: passwordTextField.stringValue, completion: { (res) in
                switch res {
                case .success(let user):
                    print(user.createAccountID)
                    DispatchQueue.main.async {
                        Users.shared.currentUser(id: user.createAccountID) { (res) in
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
                    }
                case .failure(let error):
                    print("There was an error parsing user JSON \(error)")
                    DispatchQueue.main.async {
                        self.progressIndicator.stopAnimation(self)
                        self.progressIndicator.isHidden = true
                        self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
                    }
                }
            })
        } else {
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.isHidden = true
            print("already logged in")
            view.window?.contentViewController?.presentAsSheet(loggedInViewController)
        }
    }
    @IBAction func loginOnEnterClicked(_ sender: NSTextField) {
        //        loginButton.performClick(nil)
    }
    
}
