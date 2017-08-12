//
//  SoftwareInfo.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz on 14/05/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Foundation

class SoftwareInfo {
    
    var id: Int?
    var version: String?
    var versionBuild: Int?
    var date_update : Date?
    var description: String?
    var download_link: String?
    var information_link: String?
    var license_link: String?
    
    var date_update_text : String?

    
    init() {
        
    }
    
}
