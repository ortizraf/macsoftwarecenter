//
//  ProductController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class ProductController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var titleTextView: NSTextField!
    @IBOutlet weak var buttonView: NSButton!
    @IBOutlet weak var spinnerView: NSProgressIndicator!
    
    static func instantiate() -> ProductController {
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let productViewController = mainStoryboard.instantiateController(withIdentifier: "productViewController") as! ProductController
        return productViewController
    }

    var taskName = String()
    var searchWord = String()
    var categoryId = Int()
    var organizationId = Int()
    var applications: [App]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dbApp = AppDB()
        if(taskName=="search"){
            titleTextView.stringValue = "Search by "+searchWord
            self.applications = dbApp.getAppsByLikeName(name: "%"+searchWord+"%" as AnyObject)
        } else if (taskName=="category" && categoryId>0){
            self.applications = dbApp.getAppsByCategory(categoryId: categoryId as AnyObject)
            
            let category: Category?
            let dbCategory = CategoryDB()
            category = dbCategory.getCategoryById(categoryId: categoryId)
            titleTextView.stringValue = (category?.name)!
        } else if (taskName=="organization" && organizationId>0){
            self.applications = dbApp.getAppsByOrganization(organizationId: organizationId as AnyObject)
            
            let organization: Organization?
            let dbOrganization = OrganizationDB()
            organization = dbOrganization.getOrganizationById(organizationId: organizationId)
            titleTextView.stringValue = (organization?.name)!
        } else {
            self.applications = dbApp.getAllApps()
        }
                
    }
    
    func clickCategoriesButton(){
        self.buttonView.target = self
        self.buttonView.action = #selector(ProductController.actionToCategoriesController)
    }
    
    @IBAction func clickActionToCategoriesController(sender: AnyObject) {
        print("click button Categories")
        
        actionToCategoriesController()
    }
    
    func actionToCategoriesController(){
        showProgressIndicator()
        
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let categoriesViewController = mainStoryboard.instantiateController(withIdentifier: "categoriesViewController") as! NSViewController
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.insertChildViewController(categoriesViewController, at: 0)
        self.view.addSubview(categoriesViewController.view)
        self.view.frame = categoriesViewController.view.frame
        
    }
    
    func showProgressIndicator(){
        spinnerView.isHidden = false
        spinnerView.startAnimation(spinnerView)
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return applications?.count ?? 0
        
    }
    

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "LabelCollectionViewItem", for: indexPath) as! LabelCollectionViewItem
        
        item.buildProduct = applications?[indexPath.item]
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("app selected")
        
        for indexPath in indexPaths {
            print(indexPath.description)
            
            let item = collectionView.makeItem(withIdentifier: "LabelCollectionViewItem", for: indexPath) as! LabelCollectionViewItem
            item.buildProduct = applications?[indexPath.item]
            
            getProductSelected(item)
            
        }
    }
    
    
    func getProductSelected(_ item: LabelCollectionViewItem) {
        
        actionToProductDetailController(productSelected: item.buildProduct)
        
    }
    
    func actionToProductDetailController(productSelected: App?) {
        showProgressIndicator()
        
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let productDetailViewController = mainStoryboard.instantiateController(withIdentifier: "productDetailViewController") as! ProductDetailController
        if((productSelected != nil)){
            productDetailViewController.taskName = "product"
            productDetailViewController.productId = (productSelected?.id)!
        }
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.insertChildViewController(productDetailViewController, at: 0)
        self.view.addSubview(productDetailViewController.view)
        self.view.frame = productDetailViewController.view.frame
                
    }
    
}
