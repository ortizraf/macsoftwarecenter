//
//  LabelCollectionViewCategory.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class LabelCollectionViewCategory: NSCollectionViewItem {
    
    @IBOutlet weak var category_label_name: NSTextField!
    @IBOutlet weak var category_imageview_image: NSImageView!
    

    var categoryItem: Category?
    
    var buildCategory: Category? {
        
        didSet{
            category_label_name.stringValue = (buildCategory?.name)!
            
            //btn_category_imageview_image.target = self
            //btn_category_imageview_image.action = #selector(LabelCollectionViewCategory.categorySelected)

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
}
