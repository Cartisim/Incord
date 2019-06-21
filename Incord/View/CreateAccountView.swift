//
//  CreateAccountView.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class CreateAccountView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let buttonColor = NSColor(named: NSColor.Name("accountColor"))
        buttonColor?.setFill()
        dirtyRect.fill()
        // Drawing code here.
    }
}
