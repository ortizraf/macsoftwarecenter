//
//  AppDelegate.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSViewController, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var applications = [App]()
    var categories = [Category]()
    var organizations = [Organization]()
    var softwareInfos = [SoftwareInfo]()
    
    let baseURL = "https://raw.githubusercontent.com/ortizraf/macsoftwarecenter/master/files/macsoftwarecenter.json"

    func applicationWillFinishLaunching(_ notification: Notification) {
        createTable()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func createTable(){
        print("creating table")
        
        let dbCategory = CategoryDB()
        dbCategory.dropTable()
        
        let dbOrganization = OrganizationDB()
        dbOrganization.dropTable()
        
        let dbApp = AppDB()
        dbApp.dropTable()
        
        let dbSoftwareInfo = SoftwareInfoDB()
        dbSoftwareInfo.dropTable()
        
        dbCategory.createTable()
        dbOrganization.createTable()
        dbApp.createTable()
        dbSoftwareInfo.createTable()
        
        getRequestData()
        
        print("table created successfull")
        
    }
    
    func getRequestData(){
        
        let url = NSURL(string: baseURL)
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) -> Void in
            
            if error == nil {
                
                do {
                    if data?.count != 0 {
                                                
                        if let dataCategory = data,
                            let jsonCategories = try JSONSerialization.jsonObject(with: dataCategory) as? [String: Any],
                            let categories = jsonCategories["category"] as? [[String: Any]] {
                            for cat in categories {
                                
                                let category = Category()
                                if let catId = cat["id"] as? Int {
                                    category.id = catId
                                }
                                if let catName = cat["name"] as? String {
                                    category.name = catName
                                }
                                if let catActive = cat["isActive"] as? Bool {
                                    category.active = catActive
                                }
                                self.categories.append(category)
                            }
                        }
                        
                        if let dataOrganization = data,
                            let jsonOrganizations = try JSONSerialization.jsonObject(with: dataOrganization) as? [String: Any],
                            let organizations = jsonOrganizations["organization"] as? [[String: Any]] {
                            for org in organizations {
                                
                                let organization = Organization()
                                if let orgId = org["id"] as? Int {
                                    organization.id = orgId
                                }
                                if let orgName = org["name"] as? String {
                                    organization.name = orgName
                                }
                                self.organizations.append(organization)
                            }
                        }

                        if let dataApp = data,
                            let jsonApp = try JSONSerialization.jsonObject(with: dataApp) as? [String: Any],
                            let apps = jsonApp["app"] as? [[String: Any]] {
                            for app in apps {
                                
                                let application = App()
                                if let name = app["name"] as? String {
                                    application.name = name
                                }
                                if let image = app["url_image"] as? String {
                                    application.url_image = image
                                }
                                if let link = app["download_link"] as? String {
                                    application.download_link = link
                                }
                                if let categoryId = app["category_id"] as? Int {
                                    let category = Category()
                                    category.id = categoryId
                                    application.category = category
                                }
                                if let is_active = app["is_active"] as? Bool {
                                    application.is_active = is_active
                                }
                                if let description = app["description"] as? String {
                                    application.description = description
                                }
                                if let version = app["version"] as? String {
                                    application.version = version
                                }
                                if let last_update = app["last_update"] as? String {
                                    application.last_update_text = last_update
                                }
                                if let organizationId = app["organization_id"] as? Int {
                                    let organization = Organization()
                                    organization.id = organizationId
                                    application.organization = organization
                                }
                                if let website = app["website"] as? String {
                                    application.website = website
                                }
                                if let order_by = app["order_by"] as? Int {
                                    application.order_by = order_by
                                }
                                if let file_format = app["file_format"] as? String {
                                    application.file_format = file_format
                                }
                                self.applications.append(application)
                            }
                        }
                        
                        if let dataSoftwareInfo = data,
                            let jsonSoftwareInfos = try JSONSerialization.jsonObject(with: dataSoftwareInfo) as? [String: Any],
                            let softwareInfos = jsonSoftwareInfos["software_info"] as? [[String: Any]] {
                            for softinfo in softwareInfos {
                                
                                let softwareInfo = SoftwareInfo()
                                if let softinfoId = softinfo["id"] as? Int {
                                    softwareInfo.id = softinfoId
                                }
                                if let softinfoVersion = softinfo["version"] as? String {
                                    softwareInfo.version = softinfoVersion
                                }
                                if let softinfoVersionBuild = softinfo["versionBuild"] as? Int {
                                    softwareInfo.versionBuild = softinfoVersionBuild
                                }
                                if let softinfoDescription = softinfo["description"] as? String {
                                    softwareInfo.description = softinfoDescription
                                }
                                if let softinfoDownloadLink = softinfo["downloadLink"] as? String {
                                    softwareInfo.download_link = softinfoDownloadLink
                                }
                                if let softinfoInformationLink = softinfo["informationLink"] as? String {
                                    softwareInfo.information_link = softinfoInformationLink
                                }
                                if let softinfoLicenseLink = softinfo["licenseLink"] as? String {
                                    softwareInfo.license_link = softinfoLicenseLink
                                }
                                if let softindoDateUpdate = softinfo["dateUpdate"] as? String {
                                    softwareInfo.date_update_text = softindoDateUpdate
                                }
                                self.softwareInfos.append(softwareInfo)
                            }
                        }

                        
                    } else {
                        print("no data")
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
                for category in self.categories {
                    self.insertDataCategory(category: category)
                }
                for organization in self.organizations {
                    self.insertDataOrganization(organization: organization)
                }
                for app in self.applications {
                    self.insertDataApp(app: app)
                }
                for softwareInfo in self.softwareInfos {
                    self.insertDataSoftwareInfo(softwareInfo: softwareInfo)
                }
                
            } else{
                print("Error")
            }
        }
        task.resume()
    }
    
    func insertDataCategory(category: Category){
        let dbCategory = CategoryDB()
        dbCategory.save(category: category)
    }
    
    func insertDataOrganization(organization: Organization){
        let dbOrganization = OrganizationDB()
        dbOrganization.save(organization: organization)
    }
    
    func insertDataApp(app: App){
        let dbApp = AppDB()
        dbApp.save(app: app)
    }
    
    func insertDataSoftwareInfo(softwareInfo: SoftwareInfo){
        let dbSoftwareInfo = SoftwareInfoDB()
        dbSoftwareInfo.save(softwareInfo: softwareInfo)
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSUserNotificationCenter.default.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

}

