//
//  CollectionViewitem.swift
//  Mac Application Store
//
//  Created by Rafael Ortiz on 31/12/16.
//  Copyright © 2016 Nextneo. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    // 1
    var imageFile: ImageFile? {
        didSet {
            guard viewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
    }
}
