//
//  HomeController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//


import Cocoa

class HomeController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var banners: [Banner]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.banners = getListBanner()
        
    }
    
    func getListBanner() -> Array<Banner> {
        
        var banners : Array<Banner> = []
        
        let banner1 = Banner()
        banner1.name = "Featured"
        banner1.url_image = "featuredbanner"
        banners.append(banner1)
        
        let banner2 = Banner()
        banner2.id = 1
        banner2.name = "Google"
        banner2.url_image = "google"
        banner2.type = "organization"
        banners.append(banner2)
        
        let banner3 = Banner()
        banner3.id = 3
        banner3.name = "Microsoft"
        banner3.url_image = "microsoft"
        banner3.type = "organization"
        banners.append(banner3)

        return banners

    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return banners?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelCollectionViewBanner") , for: indexPath) as! LabelCollectionViewBanner
        
        item.buildBanner = banners?[indexPath.item]
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print("banner selected")
        
        for indexPath in indexPaths {
            
            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelCollectionViewBanner") , for: indexPath) as! LabelCollectionViewBanner
            item.buildBanner = banners?[indexPath.item]
            
            getBannerSelected(item)
                        
        }
    }
    
    func getBannerSelected(_ item: LabelCollectionViewBanner) {
        
        actionToFeaturedController(bannerSelected: item.buildBanner)
        
    }
    
    func actionToFeaturedController(bannerSelected: Banner?) {
        
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let productViewController = mainStoryboard.instantiateController(withIdentifier: "productViewController") as! ProductController
        if(bannerSelected != nil){
            productViewController.taskName = (bannerSelected!.type)
            if (bannerSelected?.type=="organization"){
                productViewController.organizationId = (bannerSelected?.id)!
            } else if (bannerSelected?.type=="category"){
                productViewController.categoryId = (bannerSelected?.id)!
            }
        }
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.insertChild(productViewController, at: 0)
        self.view.addSubview(productViewController.view)
        self.view.frame = productViewController.view.frame
        
    }
    
    @IBAction func clickActionToFeaturedController(sender: AnyObject) {
        print("click button Featured")
        actionToFeaturedController(categorySelected: nil)
    }
    
    func actionToFeaturedController(categorySelected: Category?) {
        
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

    
    @IBAction func clickActionToCategoriesController(sender: AnyObject) {
        print("click button Categories")
        actionToCategoriesController()
    }
    
    func actionToCategoriesController(){
        
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let categoriesViewController = mainStoryboard.instantiateController(withIdentifier: "categoriesViewController") as! NSViewController
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.insertChild(categoriesViewController, at: 0)
        self.view.addSubview(categoriesViewController.view)
        self.view.frame = categoriesViewController.view.frame
        
    }


}
