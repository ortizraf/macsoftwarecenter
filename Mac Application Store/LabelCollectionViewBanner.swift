//
//  LabelCollectionViewBanner.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class LabelCollectionViewBanner: NSCollectionViewItem {
    
    @IBOutlet weak var banner_label_name: NSTextField!
    @IBOutlet weak var banner_imageview_image: NSImageView!
    
    var appItem: Banner?
    
    var buildBanner: Banner? {
        
        didSet{
            
            if((buildBanner?.url_image?.contains("http"))! && (buildBanner?.url_image?.contains("png"))!){
                let url = URL(string: (buildBanner?.url_image)!)
                let image = NSImage(byReferencing: url!)
                image.cacheMode = NSImageCacheMode.always
                banner_imageview_image.image=image
            } else {
                let image = buildBanner?.url_image
                banner_imageview_image.image = NSImage(named: image!)
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
