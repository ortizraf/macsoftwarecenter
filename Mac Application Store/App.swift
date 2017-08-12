//
//  Application.swift
//  Mac Application Store
//
//  Created by Rafael Ortiz on 07/01/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Foundation

class App {
    
    var id: Int?
    var name: String?
    var url_image: String?
    var download_link: String?
    var is_active: Bool?
    var description : String?
    var last_update : Date?
    var version : String?
    var category: Category?
    var organization: Organization?
    
    var website: String?
    var order_by: Int?
    var file_format : String?

    
    var last_update_text : String?

    
    init() {
        
    }

    
}

