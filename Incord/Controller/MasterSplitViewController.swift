//
//  MasterSplitViewController.swift
//  Incord
//
//  Created by Cole M on 7/16/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class MasterSplitViewController: NSSplitViewController {

    @IBOutlet weak var leftItem: NSSplitViewItem!
    @IBOutlet weak var rightItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        detailViews()
    }
    
    func detailViews() {
        if let leftVC = leftItem.viewController as? MasterViewController {
            if let rightVC = rightItem.viewController.children[1].children[0] as? ChatViewController {
                rightVC.getMessages()
                leftVC.rightVC = rightVC
                
            }
        }
    }
}
