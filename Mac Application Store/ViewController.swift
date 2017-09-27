//
//  ViewController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionToHomeController()

    }
    
    func actionToHomeController(){
        print("init HomeController")
    
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let productViewController = mainStoryboard.instantiateController(withIdentifier: "homeViewController") as! HomeController
    
        self.insertChildViewController(productViewController, at: 0)
        self.view.addSubview(productViewController.view)
        self.view.frame = productViewController.view.frame
    
    }
    
}
