//
//  WindowController.swift
//  MMac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSToolbarDelegate {
    
    @IBOutlet weak var toolbarView: NSToolbar!
    @IBOutlet weak var spinnerView: NSProgressIndicator!
    @IBOutlet var segmentedControl : NSSegmentedControl?


    
    var viewController: ViewController {
        get {
            return self.window!.contentViewController! as! ViewController
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        print("Window")
        
        setToolbarView()
        
    }
    
    func showProgressIndicator(){
        spinnerView.isHidden = false
        spinnerView.startAnimation(spinnerView)
    }
    
    func hideProgressIndicator(){
        spinnerView.isHidden = true
    }


    
    func setToolbarView(){
        
        for toolbarItemView in self.toolbarView.items {
            print(toolbarItemView.itemIdentifier)
            
            //toolbarItemView.label = "xx"
            toolbarItemView.isEnabled = true
            toolbarItemView.target = self
            if(toolbarItemView.itemIdentifier=="NSToolbarCategories"){
                toolbarItemView.action = Selector("actionToCategoriesController")
            } else if (toolbarItemView.itemIdentifier=="NSToolbarFeatured"){
                toolbarItemView.action = Selector("actionToProductController")
            } else if (toolbarItemView.itemIdentifier=="NSSearchFieldCustom"){
                //toolbarItemView.action = Selector("fieldTextDidChange:")
            }

        }
        
    }
    
    func actionToCategoriesController(){
        print("action categories")
        
        showProgressIndicator()
        
        self.viewController.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let getViewController = mainStoryboard.instantiateController(withIdentifier: "categoriesViewController") as! NSViewController
        
        for view in self.viewController.view.subviews {
            view.removeFromSuperview()
        }
        
        self.viewController.insertChildViewController(getViewController, at: 0)
        self.viewController.view.addSubview(getViewController.view)
        self.viewController.view.frame = getViewController.view.frame
        
        hideProgressIndicator()
        
    }
    
    func actionToProductController(){
        print("action product")
        
        showProgressIndicator()
        
        self.viewController.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let getViewController = mainStoryboard.instantiateController(withIdentifier: "productViewController") as! NSViewController
        
        for view in self.viewController.view.subviews {
            view.removeFromSuperview()
        }
        
        self.viewController.insertChildViewController(getViewController, at: 0)
        self.viewController.view.addSubview(getViewController.view)
        self.viewController.view.frame = getViewController.view.frame
        
        hideProgressIndicator()
        
    }
    
    func actionToSearchProductController(searchWord: String?){
        print("action search product")
        
        showProgressIndicator()
        
        self.viewController.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let getViewController = mainStoryboard.instantiateController(withIdentifier: "productViewController") as! ProductController
        getViewController.taskName = "search"
        getViewController.searchWord = searchWord!
        
        for view in self.viewController.view.subviews {
            view.removeFromSuperview()
        }
        
        self.viewController.insertChildViewController(getViewController, at: 0)
        self.viewController.view.addSubview(getViewController.view)
        self.viewController.view.frame = getViewController.view.frame
        
        hideProgressIndicator()
        
    }
    
    
    @IBAction func getSearch(sender: NSSearchField?){
        print("Button pressed search 👍 ")
        if (!(sender?.stringValue.isEmpty)!) {
            print("Searched: \(sender?.stringValue)")
            var searchWord = sender?.stringValue
            if((searchWord?.characters.count)!>3){
                actionToSearchProductController(searchWord: searchWord)
            }
        } else {
            print("empty")
            actionToProductController()
        }
        
    }
    
    @IBAction func selectSegmentsControl(sender: NSSegmentedControl) {
        print("Button segments")
        
        switch sender.selectedSegment {
        case 0:
            print("before")
            modifySegmentsControl(active: false, segmentIndex: 0)
            modifySegmentsControl(active: true, segmentIndex: 1)
        case 1:
            print("after")
            modifySegmentsControl(active: false, segmentIndex: 1)
            modifySegmentsControl(active: true, segmentIndex: 0)
        default:
            break
        }
    }
    
    func modifySegmentsControl(active: Bool ,segmentIndex: Int){
        segmentedControl?.setEnabled(active, forSegment: segmentIndex)
    }
    
    
    @IBAction func btnTouchBarFeatured(sender: AnyObject){
        print("Touchbar Button featured pressed 👍 ")
        actionToProductController()
    }
    
    @IBAction func btnTouchBarCategories(sender: AnyObject){
        print("Touchbar Button categories pressed 👍 ")
        actionToCategoriesController()
    }

}
