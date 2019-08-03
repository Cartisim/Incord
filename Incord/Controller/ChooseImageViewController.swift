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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidDisappear() {
        channelImage.image = NSImage(named: "NSBonjour")
    }
    
    func setUpView() {
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
    }
    
    lazy var errorViewController: NSViewController = {
               return self.storyboard?.instantiateController(withIdentifier: "ErrorVC") as! NSViewController
           }()

    @IBAction func dismissClicked(_ sender: NSButton) {
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
                            NotificationCenter.default.post(name: NEW_CHANNEL, object: nil)
                            self.dismiss(self)
                        } else {
                            print("no image")
                            self.view.window?.contentViewController?.presentAsSheet(self.errorViewController)
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
