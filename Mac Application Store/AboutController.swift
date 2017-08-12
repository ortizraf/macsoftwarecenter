//
//  AboutController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class AboutController: NSViewController {
    
    @IBOutlet weak var application_name: NSTextField!
    @IBOutlet weak var application_version: NSTextField!
    @IBOutlet weak var application_description: NSTextField!

    var softwareInfo : SoftwareInfo? = SoftwareInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLastUpdateSoftware()
        
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            application_name.stringValue = appName
        }
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            application_version.stringValue = "Version " + appVersion
        }
        application_description.stringValue = "Mac Software Center is free software designed to help users find software in one place."

    }
    
    func getLastUpdateSoftware(){
        let dbSoftwareInfo = SoftwareInfoDB()
        self.softwareInfo =  dbSoftwareInfo.getLastSoftwareInfo()
    }
    
    @IBAction func btnInformationLink(sender: AnyObject){
        print("Button pressed Information Link ")
        NSWorkspace.shared().open(URL(string: (softwareInfo?.information_link!)!)!)
    }

    @IBAction func btnLicenseLink(sender: AnyObject){
        print("Button pressed License Link ")
        NSWorkspace.shared().open(URL(string: (softwareInfo?.license_link!)!)!)
    }


}
