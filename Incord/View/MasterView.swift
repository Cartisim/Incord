//
//  MasterView.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class MasterView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let masterViewColor = NSColor(named: NSColor.Name("masterColor"))
        masterViewColor?.setFill()
        dirtyRect.fill()
    }
    
}
