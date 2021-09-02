//
//  WindowController.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Cocoa

class WindowPopupController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.titleVisibility = NSWindow.TitleVisibility.hidden;
        window?.titlebarAppearsTransparent = true;        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }

    
}
