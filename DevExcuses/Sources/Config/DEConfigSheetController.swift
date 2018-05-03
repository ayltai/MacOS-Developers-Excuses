import AppKit

final class DEConfigSheetController: NSWindowController {
    private let configs: DEConfigs = DEConfigs()
    
    private var font: NSFont?
    
    @IBOutlet weak var apiKey             : NSTextField?
    @IBOutlet weak var darken             : NSSlider?
    @IBOutlet weak var maxZoom            : NSSlider?
    @IBOutlet weak var excuseFont         : NSTextField?
    @IBOutlet weak var refreshTimeInterval: NSPopUpButton?
    
    override var windowNibName: NSNib.Name! {
        return NSNib.Name(rawValue: "ConfigSheet")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let apiKey = self.apiKey {
            apiKey.stringValue = self.configs.apiKey
        }
        
        if let darken = self.darken {
            darken.integerValue = self.configs.darken
        }
        
        if let maxZoom = self.maxZoom {
            maxZoom.integerValue = self.configs.maxZoom
        }
        
        self.font = self.configs.excuseFont
        self.displayFont(font: self.configs.excuseFont)
        
        if let refreshTimeInterval = self.refreshTimeInterval {
            if self.configs.refreshTimeInterval == 15 {
                refreshTimeInterval.selectItem(at: 0)
            } else if self.configs.refreshTimeInterval == 30 {
                refreshTimeInterval.selectItem(at: 1)
            } else if self.configs.refreshTimeInterval == 60 {
                refreshTimeInterval.selectItem(at: 2)
            } else if self.configs.refreshTimeInterval == 120 {
                refreshTimeInterval.selectItem(at: 3)
            } else if self.configs.refreshTimeInterval == 300 {
                refreshTimeInterval.selectItem(at: 4)
            } else {
                refreshTimeInterval.selectItem(at: 0)
            }
        }
    }
    
    @IBAction func showFontPicker(sender: Any?) {
        if let window = self.window {
            window.makeFirstResponder(self)
            
            let panel: NSFontPanel = NSFontManager.shared.fontPanel(true)!
            
            if let font = self.font {
                panel.setPanelFont(font, isMultiple: false)
            }
            
            panel.orderFront(self)
        }
    }
    
    override func changeFont(_ sender: Any?) {
        let manager = sender as! NSFontManager
        
        if let font = self.font {
            self.font = manager.convert(font)
            self.displayFont(font: font)
        }
    }
    
    private func displayFont(font: NSFont) {
        if let excuseFont = self.excuseFont {
            excuseFont.stringValue = font.fontName + ", " + String(Int(font.pointSize)) + " pt."
        }
    }
    
    @IBAction func cancel(sender: Any?) {
        self.dismiss()
    }
    
    @IBAction func ok(sender: Any?) {
        if let apiKey = self.apiKey {
            self.configs.apiKey = apiKey.stringValue
        }
        
        if let darken = self.darken {
            self.configs.darken = darken.integerValue
        }
        
        if let maxZoom = self.maxZoom {
            self.configs.maxZoom = maxZoom.integerValue
        }
        
        if let refreshTimeInterval = self.refreshTimeInterval {
            if refreshTimeInterval.indexOfSelectedItem == 0 {
                self.configs.refreshTimeInterval = 15
            } else if refreshTimeInterval.indexOfSelectedItem == 1 {
                self.configs.refreshTimeInterval = 30
            } else if refreshTimeInterval.indexOfSelectedItem == 2 {
                self.configs.refreshTimeInterval = 60
            } else if refreshTimeInterval.indexOfSelectedItem == 3 {
                self.configs.refreshTimeInterval = 120
            } else if refreshTimeInterval.indexOfSelectedItem == 4 {
                self.configs.refreshTimeInterval = 300
            }
        }
        
        self.dismiss()
    }
    
    private func dismiss() {
        if let window = self.window, let parent = window.sheetParent {
            parent.endSheet(window)
        }
    }
}
