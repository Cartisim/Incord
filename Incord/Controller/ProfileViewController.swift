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
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var reEnterPasswordTextField: NSTextField!
    @IBOutlet weak var avatarImage: NSImageView!
    @IBOutlet weak var updateAccountButton: NSButton!
    
    var clickBackground: BackgroundView!
    let avatarPopover = NSPopover()
    var avatarString = "avatar1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setUpView()
    }
    
    
    func setUpView() {
        avatarPopover.delegate = self
        clickBackground = BackgroundView()
        clickBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickBackground, positioned: .above, relativeTo: view)
        let topCn = NSLayoutConstraint(item: clickBackground!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 380)
        let leftCn = NSLayoutConstraint(item: clickBackground!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightCn = NSLayoutConstraint(item: clickBackground!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottomCn = NSLayoutConstraint(item: clickBackground!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([topCn, leftCn, rightCn, bottomCn])
        let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(closeModalClick(_:)))
        clickBackground.addGestureRecognizer(closeBackgroundClick)
        clickBackground.wantsLayer = true
        clickBackground.layer?.backgroundColor = NSColor.cyan.cgColor
        avatarImage.image = NSImage(named: avatarString)
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        dismiss(self)
    }
    
    @IBAction func updateAccountOnEnterClicked(_ sender: NSTextField) {
        updateAccountButton.performClick(nil)
    }
    
    @IBAction func updateAccountClicked(_ sender: NSButton) {
    }
    
    @IBAction func changeImageClicked(_ sender: NSButton) {
        avatarPopover.contentViewController = AvatarViewController(nibName: "Avatars", bundle: nil)
        avatarPopover.show(relativeTo: avatarImage.bounds, of: avatarImage, preferredEdge: .minX)
        avatarPopover.behavior = .transient
    }
}

extension ProfileViewController: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        if Authentication.shared.avatarName != "" {
            avatarImage.image = NSImage(named: Authentication.shared.avatarName)
            avatarString = Authentication.shared.avatarName
        }
    }
}