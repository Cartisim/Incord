//
//  CustomButtonView.swift
//  Incord
//
//  Created by Cole M on 6/13/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class CustomButtonView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
      let buttonColor = NSColor(named: NSColor.Name("ButtonColor"))
        buttonColor?.setFill()
        dirtyRect.fill()
    }
    
}
