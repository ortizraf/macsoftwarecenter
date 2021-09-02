//
//  ProductDetailController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class ProductDetailController: NSViewController {
    
    var application : App = App()

    
    @IBOutlet weak var application_label_name: NSTextField!
    @IBOutlet weak var application_imageview_image: NSImageView!
    @IBOutlet weak var application_label_description: NSTextField!
    @IBOutlet weak var application_button_category: NSButton!
    @IBOutlet weak var application_label_last_update: NSTextField!
    @IBOutlet weak var application_label_version: NSTextField!
    @IBOutlet weak var application_button_organization: NSButton!

    @IBOutlet weak var application_button_website_link: NSButton!
    
    @IBOutlet weak var application_website_view: NSView!

    @IBOutlet weak var application_link: NSButton!
    @IBOutlet weak var application_option: NSPopUpButton!

    var taskName = String()
    var productId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        trackingAreaButton()

        
        let dbApp = AppDB()
        if (taskName=="product" && productId>0){
            
            self.application = dbApp.getAppById(id: productId as AnyObject)
            
            application_label_name.stringValue = (application.name)!
            
            if((application.url_image?.contains("http"))! && (application.url_image?.contains(".png"))!){
                let url = URL(string: (application.url_image)!)
                let image = NSImage(byReferencing: url!)
                image.cacheMode = NSImage.CacheMode.always
                application_imageview_image.image=image
            } else {
                application_imageview_image.image = NSImage(named: (application.url_image)!)
            }
            
            if(!(application.description?.isEmpty)!){
                application_label_description.stringValue = (application.description)!
            }
            
            application_button_category.title = (application.category?.name)!
                        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            application_label_last_update.stringValue = dateFormatter.string(from:application.last_update!)
            
            
            if(application.version != nil && !(application.version?.isEmpty)!){
                application_label_version.stringValue = (application.version)!
            } else {
                application_label_version.stringValue = "Last version"
            }
            
            application_button_organization.isHidden = true
            application_button_organization.isEnabled = false
            if(application.organization != nil){
                application_button_organization.isHidden = false
                application_button_organization.isEnabled = true
                application_button_organization.title = (application.organization?.name)!
            }
            if(application.website != nil && !(application.website?.isEmpty)!){
                application_website_view.isHidden = false
                application_button_website_link.isHidden = false
            }
            

        }
    }
    
    
    @IBAction func clickActionToCategoryController(sender: AnyObject) {
        print("Button pressed Category ")
        actionToOrganizationController(taskName: "category")

    }
    
    @IBAction func clickActionToOrganizationController(sender: AnyObject) {
        print("click button Organization")
        actionToOrganizationController(taskName: "organization")
    }
    
    @IBAction func clickActionToWebsiteController(sender: AnyObject) {
        print("click button Website")
        NSWorkspace.shared.open(URL(string: application.website!)!)
    }
    
    func actionToOrganizationController(taskName: String) {
        
        self.view.wantsLayer = true
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let productViewController = mainStoryboard.instantiateController(withIdentifier: "productViewController") as! ProductController
        productViewController.taskName = taskName
        if(application.organization != nil){
            productViewController.organizationId = (application.organization?.id)!
        }
        if(application.category != nil){
            productViewController.categoryId = (application.category?.id)!
        }
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.insertChild(productViewController, at: 0)
        self.view.addSubview(productViewController.view)
        self.view.frame = productViewController.view.frame
        
    }



    @IBAction func btnDownload(sender: AnyObject){
        print("Button pressed 👍 ")
        
        getDownload(downloadLink: (application.download_link)!, appName: (application.name)!)
        
    }
    
    @IBAction func selectOption(sender: AnyObject){
        
        print("PopUp Button pressed 👍 ")
        
        let selectedNumber = sender.indexOfSelectedItem
        
        if(selectedNumber==0){
            
            if let url = URL(string: (application.download_link)!), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        } else if (selectedNumber==1) {
            let pasteBoard = NSPasteboard.general
            pasteBoard.clearContents()
            pasteBoard.setString((application.download_link)!, forType: .string)
        }
        
    }
    
    func getDownload(downloadLink: String, appName: String){
        
        application_link.isEnabled = false
        application_link.title = "downloading..."
        
        let downloadUrl = NSURL(string: downloadLink)
        
        let downloadService = DownloadService(url: downloadUrl!)
        
        downloadService.downloadData(completion: { (data) in
            
            let fileDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            
            let fileNameUrl = NSURL(fileURLWithPath: (downloadUrl?.absoluteString)!).lastPathComponent!
            
            var fileName = fileNameUrl.removingPercentEncoding
            
            if(self.application.file_format?.contains("zip"))!{
                print("zip")
                fileName = appName+".zip"
            } else if(self.application.file_format?.contains("dmg"))!{
                fileName = appName+".dmg"
            } else if(!(fileName?.contains(".dmg"))! && !(fileName?.contains(".zip"))! && !(fileName?.contains(".app"))!){
                print("dmg")
                fileName = appName+".dmg"
            }
            
            let fileUrl = fileDirectory.appendingPathComponent(fileName!, isDirectory: false)
            
            try? data.write(to: fileUrl)
            
            let messageService = MessageService()
            messageService.showNotification(title: appName, informativeText: "Download completed successfully")
            
            self.application_link.title = "download"
            self.application_link.isEnabled = true
            
        })
    }
    
    //tracking buttons
    func trackingAreaButton(){
        let areaButtonCategory = NSTrackingArea.init(rect: application_button_category.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        application_button_category.addTrackingArea(areaButtonCategory)
        let areaButtonOrganization = NSTrackingArea.init(rect: application_button_organization.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        application_button_organization.addTrackingArea(areaButtonOrganization)
        let areaButtonWebsite = NSTrackingArea.init(rect: application_button_website_link.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        application_button_website_link.addTrackingArea(areaButtonWebsite)

    }
    
    override func mouseExited(with event: NSEvent) {
        print("Mouse Exited")
        
        let pstyle = NSMutableParagraphStyle()
        application_button_category.attributedTitle = NSAttributedString(string: application_button_category.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.secondaryLabelColor, NSAttributedString.Key.paragraphStyle : pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 11), NSFontDescriptor.AttributeName.size: 11 ] as? [NSAttributedString.Key : Any])
        application_button_organization.attributedTitle = NSAttributedString(string: application_button_organization.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.secondaryLabelColor, NSAttributedString.Key.paragraphStyle : pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 11), NSFontDescriptor.AttributeName.size: 11 ] as? [NSAttributedString.Key : Any])
        application_button_website_link.attributedTitle = NSAttributedString(string: application_button_website_link.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.secondaryLabelColor, NSAttributedString.Key.paragraphStyle : pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 13), NSFontDescriptor.AttributeName.size: 13 ] as? [NSAttributedString.Key : Any])
    }
    override func mouseEntered(with event: NSEvent) {
        print("Mouse Entered")
        
        let pstyle = NSMutableParagraphStyle()
        
        if(event.trackingArea?.rect.equalTo((application_button_category.trackingAreas.first?.rect)!))!{
            application_button_category.attributedTitle = NSAttributedString(string: application_button_category.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.linkColor, NSAttributedString.Key.paragraphStyle : pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 11), NSFontDescriptor.AttributeName.size: 11 ] as? [NSAttributedString.Key : Any])
        }
        if(event.trackingArea?.rect.equalTo((application_button_organization.trackingAreas.first?.rect)!))!{
            application_button_organization.attributedTitle = NSAttributedString(string: application_button_organization.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.linkColor, NSAttributedString.Key.paragraphStyle : pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 11), NSFontDescriptor.AttributeName.size: 11 ] as? [NSAttributedString.Key : Any])
        }
        if(event.trackingArea?.rect.equalTo((application_button_website_link.trackingAreas.first?.rect)!))!{
            application_button_website_link.attributedTitle = NSAttributedString(string: application_button_website_link.title, attributes: [ NSAttributedString.Key.foregroundColor : NSColor.linkColor, NSAttributedString.Key.paragraphStyle : pstyle, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 13), NSFontDescriptor.AttributeName.size: 13,             NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue as AnyObject ] as? [NSAttributedString.Key : Any])
        }
    }

    
}
