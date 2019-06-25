//
//  AvatarViewController.swift
//  Incord
//
//  Created by Cole M on 6/21/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class AvatarViewController: NSViewController {

    @IBOutlet weak var collectionView:
    NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension AvatarViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let selectedAvatar = collectionView.selectionIndexPaths.first {
            Authentication.shared.avatarName = "avatar\(selectedAvatar.item + 1)"
            view.window?.cancelOperation(nil)
        }
    }

}

extension AvatarViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AvatarCell"), for: indexPath)
        guard let avatarCell = cell as? AvatarCell else { return NSCollectionViewItem() }
        avatarCell.cellConfiguration(index: indexPath.item)
        return avatarCell
    }

}
