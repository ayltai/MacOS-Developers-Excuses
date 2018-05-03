import AppKit

final class DEConfigSheetController: NSWindowController {
    override var windowNibName: NSNib.Name! {
        return NSNib.Name(rawValue: "ConfigSheet")
    }
    
    @IBAction func ok(sender: Any?) {
        if let window = self.window, let parent = window.sheetParent {
            parent.endSheet(window)
        }
    }
}
