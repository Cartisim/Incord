//
//  ChooseImageViewController.swift
//  Incord
//
//  Created by Cole M on 7/12/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class ChooseImageViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var channelImage: NSImageView!
    
    var clickBackground: BackgroundView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    override func viewWillAppear() {
          setUpView()
          print("data \(UserData.shared.channelID)")
    }
    override func viewDidDisappear() {
        channelImage.image = NSImage(named: "NSBonjour")
    }
    
    func setUpView() {
        clickBackground = BackgroundView()
        clickBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickBackground, positioned: .above, relativeTo: view)
        let topCn = NSLayoutConstraint(item: clickBackground!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 240)
        let leftCn = NSLayoutConstraint(item: clickBackground!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightCn = NSLayoutConstraint(item: clickBackground!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottomCn = NSLayoutConstraint(item: clickBackground!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([topCn, leftCn, rightCn, bottomCn])
        let closeBackgroundClick = NSClickGestureRecognizer(target: self, action: #selector(closeModalClick(_:)))
        clickBackground.addGestureRecognizer(closeBackgroundClick)
        clickBackground.wantsLayer = true
        clickBackground.layer?.backgroundColor = NSColor.cyan.cgColor
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
    }
    
    @objc func closeModalClick(_ recognizer: NSClickGestureRecognizer) {
        dismiss(self)
    }
    
    @IBAction func addImageClicked(_ sender: NSButton) {
        if UserData.shared.isLoggedIn {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = true
        openPanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let imageURL = openPanel.urls.first {
                    if let image = NSImage(contentsOf: imageURL) {
                        self.channelImage.image = image
                        if self.channelImage.image != nil {
                            let channelIMG = self.jpegDataFrom(image: self.channelImage.image!)
                            Channels.shared.addChannelImage(image: channelIMG, completion: { (res) in
                                switch res {
                                case .success(let img):
                                    print(img)
                                case .failure(let err):
                                    print(err)
                                }
                            })
                               NotificationCenter.default.post(name: RELOAD_COLLECTION, object: nil)
                           
                            self.dismiss(self)
                        } else {
                            print("no image")
                        }
                    }
                }
            }
        }
    }
}
    func jpegDataFrom(image:NSImage) -> Data {
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
    }
}
