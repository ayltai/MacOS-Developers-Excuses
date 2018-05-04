import AppKit

final class DEConfigSheetController: NSWindowController {
    private let configs: DEConfigs = DEConfigs()
    
    private var fontName: String?
    private var fontSize: Float?
    
    @IBOutlet weak var apiKey         : NSTextField?
    @IBOutlet weak var darken         : NSSlider?
    @IBOutlet weak var maxZoom        : NSSlider?
    @IBOutlet weak var font           : NSTextField?
    @IBOutlet weak var duration       : NSPopUpButton?
    @IBOutlet weak var videoEnabled   : NSButton?
    @IBOutlet weak var cameraAppPicker: NSButton?
    @IBOutlet weak var cameraAppPath  : NSTextField?
    @IBOutlet weak var videoSavePicker: NSButton?
    @IBOutlet weak var videoSavePath  : NSTextField?
    @IBOutlet weak var imageTopics    : NSTextView?
    
    override var windowNibName: NSNib.Name! {
        return NSNib.Name(rawValue: "ConfigSheet")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let apiKey: NSTextField = self.apiKey {
            apiKey.stringValue = self.configs.apiKey
        }
        
        if let darken: NSSlider = self.darken {
            darken.integerValue = self.configs.darken
        }
        
        if let maxZoom: NSSlider = self.maxZoom {
            maxZoom.integerValue = self.configs.maxZoom
        }
        
        self.fontName = self.configs.fontName
        self.fontSize = self.configs.fontSize
        
        self.displayFont(name: self.configs.fontName, size: self.configs.fontSize)
        
        if let duration: NSPopUpButton = self.duration {
            if self.configs.duration == 15 {
                duration.selectItem(at: 0)
            } else if self.configs.duration == 30 {
                duration.selectItem(at: 1)
            } else if self.configs.duration == 60 {
                duration.selectItem(at: 2)
            } else if self.configs.duration == 120 {
                duration.selectItem(at: 3)
            } else if self.configs.duration == 300 {
                duration.selectItem(at: 4)
            } else {
                duration.selectItem(at: 0)
            }
        }
        
        if let videoEnabled: NSButton = self.videoEnabled {
            videoEnabled.state = self.configs.videoEnabled ? .on : .off
            
            self.toggleVideoConfigs(sender: videoEnabled)
        }
        
        if let cameraAppPath: NSTextField = self.cameraAppPath {
            cameraAppPath.stringValue = self.configs.cameraAppPath
        }
        
        if let videoSavePath: NSTextField = self.videoSavePath {
            videoSavePath.stringValue = self.configs.videoSavePath + DEConfigs.videoSavePathSuffix
        }
        
        if let imageTopics: NSTextView = self.imageTopics {
            imageTopics.string = self.configs.imageTopics.joined(separator: "\n")
        }
    }
    
    @IBAction func showFontPicker(sender: Any?) {
        if let window: NSWindow = self.window {
            window.makeFirstResponder(self)
            
            let panel: NSFontPanel = NSFontManager.shared.fontPanel(true)!
            panel.showsResizeIndicator = true
            
            if let oldFont: NSFont = NSFont(name: self.fontName!, size: CGFloat(self.fontSize!)) {
                panel.setPanelFont(oldFont, isMultiple: false)
            }
            
            panel.orderFront(self)
        }
    }
    
    override func changeFont(_ sender: Any?) {
        let manager = sender as! NSFontManager
        
        if let oldFont: NSFont = NSFont(name: self.fontName!, size: CGFloat(self.fontSize!)) {
            let newFont: NSFont = manager.convert(oldFont)
            
            self.fontName = newFont.fontName
            self.fontSize = Float(newFont.pointSize)
            
            self.displayFont(name: self.fontName!, size: self.fontSize!)
        }
    }
    
    private func displayFont(name: String, size: Float) {
        if let font: NSTextField = self.font {
            font.stringValue = name + ", " + String(Int(size)) + " pt."
        }
    }
    
    @IBAction func toggleVideoConfigs(sender: Any?) {
        if let videoEnabled   : NSButton    = self.videoEnabled,
           let cameraAppPicker: NSButton    = self.cameraAppPicker,
           let cameraAppPath  : NSTextField = self.cameraAppPath,
           let videoSavePicker: NSButton    = self.videoSavePicker,
           let videoSavePath  : NSTextField = self.videoSavePath {
            if videoEnabled.state == .on {
                cameraAppPicker.isEnabled = true
                cameraAppPath.isEnabled   = true
                videoSavePicker.isEnabled = true
                videoSavePath.isEnabled   = true
            } else if videoEnabled.state == .off {
                cameraAppPicker.isEnabled = false
                cameraAppPath.isEnabled   = false
                videoSavePicker.isEnabled = false
                videoSavePath.isEnabled   = false
            }
        }
    }
    
    @IBAction func showCameraAppPathPicker(sender: Any?) {
        if let cameraAppPath: NSTextField = self.cameraAppPath {
            let panel: NSOpenPanel = NSOpenPanel()
            
            panel.title                   = "Choose SecurityCamera app"
            panel.showsResizeIndicator    = true
            panel.showsToolbarButton      = true
            panel.showsHiddenFiles        = true
            panel.canChooseFiles          = true
            panel.canChooseDirectories    = false
            panel.allowsMultipleSelection = false
            
            if panel.runModal() == NSApplication.ModalResponse.OK, let url = panel.url {
                cameraAppPath.stringValue = url.path
            }
        }
    }
    
    @IBAction func showVideoSavePathPicker(sender: Any?) {
        if let videoSavePath: NSTextField = self.videoSavePath {
            let panel: NSOpenPanel = NSOpenPanel()
            
            panel.title                   = "Choose video save path"
            panel.showsResizeIndicator    = true
            panel.showsToolbarButton      = true
            panel.showsHiddenFiles        = true
            panel.canChooseFiles          = false
            panel.canChooseDirectories    = true
            panel.allowsMultipleSelection = false
            
            if panel.runModal() == NSApplication.ModalResponse.OK, let url = panel.url {
                videoSavePath.stringValue = url.path + DEConfigs.videoSavePathSuffix
            }
        }
    }
    
    @IBAction func cancel(sender: Any?) {
        self.dismiss()
    }
    
    @IBAction func ok(sender: Any?) {
        if let apiKey: NSTextField = self.apiKey {
            self.configs.apiKey = apiKey.stringValue
        }
        
        if let darken: NSSlider = self.darken {
            self.configs.darken = darken.integerValue
        }
        
        if let maxZoom: NSSlider = self.maxZoom {
            self.configs.maxZoom = maxZoom.integerValue
        }
        
        if let duration: NSPopUpButton = self.duration {
            if duration.indexOfSelectedItem == 0 {
                self.configs.duration = 15
            } else if duration.indexOfSelectedItem == 1 {
                self.configs.duration = 30
            } else if duration.indexOfSelectedItem == 2 {
                self.configs.duration = 60
            } else if duration.indexOfSelectedItem == 3 {
                self.configs.duration = 120
            } else if duration.indexOfSelectedItem == 4 {
                self.configs.duration = 300
            }
        }
        
        if let videoEnabled: NSButton = self.videoEnabled {
            self.configs.videoEnabled = videoEnabled.state == .on
        }
        
        if let cameraAppPath: NSTextField = self.cameraAppPath {
            self.configs.cameraAppPath = cameraAppPath.stringValue
        }
        
        if let videoSavePath: NSTextField = self.videoSavePath,
           let range: Range = videoSavePath.stringValue.range(of: DEConfigs.videoSavePathSuffix) {
            self.configs.videoSavePath = String(videoSavePath.stringValue[..<range.lowerBound])
        }
        
        if let imageTopics: NSTextView = self.imageTopics {
            self.configs.imageTopics = imageTopics.string.lines
        }
        
        self.dismiss()
    }
    
    private func dismiss() {
        if let window: NSWindow = self.window,
           let parent: NSWindow = window.sheetParent {
            parent.endSheet(window)
        }
    }
}
