//
//  CategoriesController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class CategoriesController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
       
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var buttonFeaturedView: NSButton!
    @IBOutlet weak var spinnerView: NSProgressIndicator!
    
    static func instantiate() -> CategoriesController {
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let categoriesViewController = mainStoryboard.instantiateController(withIdentifier: "categoriesViewController") as! CategoriesController
        
        return categoriesViewController
    }

    
    var categories: [Category]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbCategory = CategoryDB()
        self.categories = dbCategory.getAllCategory()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func clickFeaturedButton(){
        self.buttonFeaturedView.target = self
        self.buttonFeaturedView.action = #selector(CategoriesController.clickActionToFeaturedController)
    }
    
    @IBAction func clickActionToFeaturedController(sender: AnyObject) {
        print("click button Featured")
        
        actionToFeaturedController(categorySelected: nil)
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelCollectionViewCategory") , for: indexPath) as! LabelCollectionViewCategory
        
        item.buildCategory = categories?[indexPath.item]
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("category selected")
        
        for indexPath in indexPaths {
            print(indexPath.description)
            
            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelCollectionViewCategory") , for: indexPath) as! LabelCollectionViewCategory
            item.buildCategory = categories?[indexPath.item]

            getCategorySelected(item)
            
        }
        
    }
    
    func getCategorySelected(_ item: LabelCollectionViewCategory) {
        
        actionToFeaturedController(categorySelected: item.buildCategory)

    }
    
    func actionToFeaturedController(categorySelected: Category?) {
        showProgressIndicator()
                
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let productViewController = mainStoryboard.instantiateController(withIdentifier: "productViewController") as! ProductController
        if(categorySelected != nil){
            productViewController.taskName = "category"
            productViewController.categoryId = (categorySelected?.id)!
        }
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.insertChild(productViewController, at: 0)
        self.view.addSubview(productViewController.view)
        self.view.frame = productViewController.view.frame
        
    }
    
    func showProgressIndicator(){
        spinnerView.isHidden = false
        spinnerView.startAnimation(spinnerView)
    }
    
}
