//
//  LabelCollectionViewItem.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class LabelCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var application_label_name: NSTextField!
    @IBOutlet weak var application_imageview_image: NSImageView!
    @IBOutlet weak var application_link: NSButton!
    @IBOutlet weak var application_option: NSPopUpButton!
    @IBOutlet weak var application_category: NSTextField!
    
    var productItem: App?
    
    var buildProduct: App? {
        
        didSet{
                        
            application_label_name.stringValue = (buildProduct?.name)!
            
            if((buildProduct?.url_image?.contains("http"))! && (buildProduct?.url_image?.contains("png"))!){
                
                application_imageview_image.image = NSImage(named: "no-image")
                if let checkedUrl = URL(string: (buildProduct?.url_image)!) {
                    downloadImage(url: checkedUrl)
                }
            } else {
                let image = buildProduct?.url_image
                application_imageview_image.image = NSImage(named: image!)
            }
            

            application_link.target = self
            application_link.action = #selector(LabelCollectionViewItem.btnDownload)
            
            application_option.isEnabled = true
            application_option.target = self
            application_option.action = #selector(LabelCollectionViewItem.selectOption)
            
            application_category.stringValue = (buildProduct?.category?.name)!

        }
    }
    
    func downloadImage(url: URL) {
        print("Download Started", url)
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished", url)
            DispatchQueue.main.async() { () -> Void in
                self.application_imageview_image.image = NSImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func btnDownload(sender: NSButton){
        print("Button pressed 👍 ")
        
        getDownload(downloadLink: (self.buildProduct?.download_link)!, appName: (self.buildProduct?.name)!)
                
    }
    
    @IBAction func selectOption(sender: NSPopUpButton){
        
        print("PopUp Button pressed 👍 ")
        
        let selectedNumber = sender.indexOfSelectedItem

        if(selectedNumber==0){
            if let url = URL(string: (self.buildProduct?.download_link)!), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        } else if (selectedNumber==1) {
            let pasteBoard = NSPasteboard.general
            pasteBoard.clearContents()
            pasteBoard.setString((self.buildProduct?.download_link)!, forType: .string)
        }
        
    }
    

    
    func getDownload(downloadLink: String, appName: String){
        
        self.application_link.isEnabled = false
        self.application_link.title = "downloading..."
        
        let downloadUrl = NSURL(string: downloadLink)
        
        let downloadService = DownloadService(url: downloadUrl!)
        
        print(downloadLink)
        
        downloadService.downloadData(completion: { (data) in
            
            let fileDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            
            let fileNameUrl = NSURL(fileURLWithPath: (downloadUrl?.absoluteString)!).lastPathComponent!
            
            var fileName = fileNameUrl.removingPercentEncoding
            
            if(self.buildProduct?.file_format?.contains("zip"))!{
                print("zip")
                fileName = appName+".zip"
            } else if(self.buildProduct?.file_format?.contains("dmg"))!{
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
    
}
