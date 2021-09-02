//
//  SoftwareUpdate.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class SoftwareUpdateController: NSViewController {
    
    @IBOutlet weak var software_message: NSTextField!
    @IBOutlet weak var software_version: NSTextField!
    @IBOutlet weak var software_description: NSTextField!
    @IBOutlet weak var software_button_download: NSButton!
    
    static func instantiate() -> SoftwareUpdateController {
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let updateViewController = mainStoryboard.instantiateController(withIdentifier: "updateViewController") as! SoftwareUpdateController
        
        return updateViewController
    }

    
    var softwareInfo : SoftwareInfo? = SoftwareInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLastUpdateSoftware()
        showInformation();
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        layoutWindowPopup();

    }
    
    func layoutWindowPopup(){
        self.view.window?.titleVisibility = NSWindow.TitleVisibility.hidden
        self.view.window?.titlebarAppearsTransparent = true
        
        self.view.window?.styleMask.remove(.resizable)
        
        self.view.window?.styleMask.insert(.fullSizeContentView)
        self.view.window?.styleMask.insert(.closable)

    }
    
    @IBAction func btnDownload(sender: AnyObject){
        print("Button download pressed 👍 ")
        
        getDownload(downloadLink: (softwareInfo?.download_link)!)
        
    }
    
    func showInformation(){
        let applicationVersionBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String        

        if(softwareInfo != nil && (softwareInfo?.versionBuild)! > Int(applicationVersionBuild!)!){
            showUpdateSoftware()
        } else {
            showNoUpdateSoftware()
        }
    }
    
    func showUpdateSoftware(){
        software_message.stringValue = "A new version of Mac Software Center has been released! Version " + (softwareInfo?.version)! + " is available"
        software_description.stringValue = (softwareInfo?.description)!
    }
    
    func showNoUpdateSoftware(){
        let applicationShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        software_message.stringValue = "You are up to date! Mac Software Center version " + applicationShortVersion! + " is the latest version."
        software_description.isHidden = true
        software_button_download.isHidden = true
    }
    
    func getLastUpdateSoftware(){
        let dbSoftwareInfo = SoftwareInfoDB()
        self.softwareInfo =  dbSoftwareInfo.getLastSoftwareInfo()
        
    }
    
    func getDownload(downloadLink: String){
        
        software_button_download.isEnabled = false
        software_button_download.title = "Downloading..."
        
        let downloadUrl = NSURL(string: downloadLink)
        
        let downloadService = DownloadService(url: downloadUrl!)
        
        
        downloadService.downloadData(completion: { (data) in
            
            let fileDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            
            let fileNameUrl = NSURL(fileURLWithPath: (downloadUrl?.absoluteString)!).lastPathComponent!
            
            var fileName = fileNameUrl.removingPercentEncoding
            
            let fileUrl = fileDirectory.appendingPathComponent(fileName!, isDirectory: false)
            
            try? data.write(to: fileUrl)
 
            self.software_button_download.isEnabled = true
            self.software_button_download.title = "Download"
            
            let nsDocumentDirectory = FileManager.SearchPathDirectory.downloadsDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first{
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: dirPath)
                NSWorkspace.shared.openFile("/Applications")
            }
            NSApplication.shared.terminate(self)
            
        })
        
    }

    
}
