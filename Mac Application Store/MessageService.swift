//
//  StringUtils.swift
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//
import Cocoa

class MessageService {
    
    func showNotification(title: String, informativeText: String){
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = informativeText

        
        NSUserNotificationCenter.default.deliver(notification)
        
        print("show notification")
        
    }

}
