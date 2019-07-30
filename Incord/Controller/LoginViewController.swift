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
    
    var clickBackground: BackgroundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
    }
    
    
    func setUpView() {
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
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
    }
    var account = [CreateAccount]()
    
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
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
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
        //        passwordTextField.performClick(nil)
    }
    
}
