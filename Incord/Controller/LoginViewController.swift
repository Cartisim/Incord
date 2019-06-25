//
//  LoginViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa
import Alamofire
import KeychainSwift

class LoginViewController: NSViewController {

    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var clickBackground: BackgroundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
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
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        dismiss(self)
    }
    
    @IBAction func loginClicked(_ sender: NSButton) {
            Authentication.shared.login(email: emailTextField.stringValue, password: passwordTextField.stringValue) { (success) in
                if success {
                    print(Authentication.shared.token)
                    self.dismiss(self)
                } else {
                    print("fail")
                }
            }
    }
    @IBAction func loginOnEnterClicked(_ sender: NSTextField) {
//        passwordTextField.performClick(nil)
    }
    
}