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
        setUpView()
    }
    
    
    func setUpView() {
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
    }
    
    override func viewWillAppear() {
        if UserData.shared.isLoggedIn != true {
            emailTextField.stringValue = ""
            passwordTextField.stringValue  = ""
            statusLabel.stringValue = "Not Logged in"
            Authentication.shared.logout()
            print("not logged in")
        } else {
            emailTextField.stringValue = UserData.shared.userEmail
            passwordTextField.stringValue  = ""
            statusLabel.stringValue = "Logged In"
        }
    }
    
  
    @IBAction func closhSheetClicked(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func loginClicked(_ sender: NSButton) {
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)
        
        if UserData.shared.isLoggedIn != true {
            Authentication.shared.login(email: emailTextField.stringValue, password: passwordTextField.stringValue, completion: { (res) in
                switch res {
                case .success(let user):
                    print(user)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        NotificationCenter.default.post(name: NEW_CHANNEL, object: nil)
                        self.progressIndicator.stopAnimation(self)
                        self.progressIndicator.isHidden = true
                        self.dismiss(self)
                    }
                case .failure(let error):
                    print("There was an error parsing user JSON \(error)")
                    DispatchQueue.main.async {
                        self.progressIndicator.stopAnimation(self)
                        self.progressIndicator.isHidden = true
                    }
                }
            })
        } else {
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.isHidden = true
            print("already logged in")
            dismiss(self)
        }
    }
    @IBAction func loginOnEnterClicked(_ sender: NSTextField) {
//        loginButton.performClick(nil)
    }
    
}
