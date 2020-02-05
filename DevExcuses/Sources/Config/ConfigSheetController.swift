import AppKit

final class ConfigSheetController: NSWindowController {
    private let configs = Configs()

    @IBOutlet weak var apiKey         : NSTextField?
    @IBOutlet weak var darken         : NSSlider?
    @IBOutlet weak var maxZoom        : NSSlider?
    @IBOutlet weak var duration       : NSPopUpButton?
    @IBOutlet weak var videoEnabled   : NSButton?
    @IBOutlet weak var cameraAppPicker: NSButton?
    @IBOutlet weak var cameraAppPath  : NSTextField?
    @IBOutlet weak var videoSavePicker: NSButton?
    @IBOutlet weak var videoSavePath  : NSTextField?
    @IBOutlet weak var imageTopics    : NSTextView?

    override var windowNibName: NSNib.Name! {
        return "ConfigSheet"
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

        if let duration = self.duration {
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

        if let videoEnabled = self.videoEnabled {
            videoEnabled.state = self.configs.videoEnabled ? .on : .off

            self.toggleVideoConfigs(sender: videoEnabled)
        }

        if let cameraAppPath = self.cameraAppPath {
            cameraAppPath.stringValue = self.configs.cameraAppPath
        }

        if let videoSavePath = self.videoSavePath {
            videoSavePath.stringValue = self.configs.videoSavePath + Configs.videoSavePathSuffix
        }

        if let imageTopics = self.imageTopics {
            imageTopics.string = self.configs.imageTopics.joined(separator: "\n")
        }
    }

    @IBAction func toggleVideoConfigs(sender: Any?) {
        if
            let videoEnabled    = self.videoEnabled,
            let cameraAppPicker = self.cameraAppPicker,
            let cameraAppPath   = self.cameraAppPath,
            let videoSavePicker = self.videoSavePicker,
            let videoSavePath   = self.videoSavePath {
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
        guard let cameraAppPath = self.cameraAppPath else {
            return
        }

        let panel = NSOpenPanel()

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

    @IBAction func showVideoSavePathPicker(sender: Any?) {
        guard let videoSavePath = self.videoSavePath else {
            return
        }

        let panel = NSOpenPanel()

        panel.title                   = "Choose video save path"
        panel.showsResizeIndicator    = true
        panel.showsToolbarButton      = true
        panel.showsHiddenFiles        = true
        panel.canChooseFiles          = false
        panel.canChooseDirectories    = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == NSApplication.ModalResponse.OK, let url = panel.url {
            videoSavePath.stringValue = url.path + Configs.videoSavePathSuffix
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

        if let duration = self.duration {
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

        if let videoEnabled = self.videoEnabled {
            self.configs.videoEnabled = videoEnabled.state == .on
        }

        if let cameraAppPath = self.cameraAppPath {
            self.configs.cameraAppPath = cameraAppPath.stringValue
        }

        if let videoSavePath = self.videoSavePath,
           let range: Range = videoSavePath.stringValue.range(of: Configs.videoSavePathSuffix) {
            self.configs.videoSavePath = String(videoSavePath.stringValue[..<range.lowerBound])
        }

        if let imageTopics = self.imageTopics {
            self.configs.imageTopics = imageTopics.string.lines
        }

        self.dismiss()
    }

    private func dismiss() {
        if let window = self.window,
           let parent = window.sheetParent {
            parent.endSheet(window)
        }
    }
}
