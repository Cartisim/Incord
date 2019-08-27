//
//  NSImage.swift
//  Incord
//
//  Created by Cole M on 8/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

extension NSImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = NSImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
