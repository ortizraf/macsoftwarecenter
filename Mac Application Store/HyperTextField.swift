import Cocoa

@IBDesignable
class HyperTextField: NSTextField {
    @IBInspectable var href: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: NSColor.black,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleDouble.rawValue as AnyObject
        ]
        self.attributedStringValue = NSAttributedString(string: self.stringValue, attributes: attributes)
    }
    
    override func mouseDown(with event: NSEvent) {
        NSWorkspace.shared().open(URL(string: self.href)!)
    }
}
