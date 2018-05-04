import ScreenSaver

final class DEConfigs: NSObject {
    public static let videoSavePathSuffix = "/SecurityCamera-%timestamp%.mov"
    
    private static let apiKey          : String = "api"
    private static let darkenKey       : String = "darken"
    private static let maxZoomKey      : String = "maxZoom"
    private static let fontNameKey     : String = "fontName"
    private static let fontSizeKey     : String = "fontSize"
    private static let durationKey     : String = "duration"
    private static let videoEnabledKey : String = "videoEnabled"
    private static let cameraAppPathKey: String = "cameraAppPath"
    private static let videoSavePathKey: String = "videoSavePath"
    private static let imageTopicsKey  : String = "imageTopics"
    
    private let defaults: ScreenSaverDefaults = DEConfigs.defaults()
    
    override init() {
        super.init()
        
        self.register()
    }
    
    var apiKey: String {
        get {
            return self.defaults.string(forKey: DEConfigs.apiKey)!
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.apiKey)
            self.defaults.synchronize()
        }
    }
    
    var darken: Int {
        get {
            return self.defaults.integer(forKey: DEConfigs.darkenKey)
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.darkenKey)
            self.defaults.synchronize()
        }
    }
    
    var maxZoom: Int {
        get {
            return self.defaults.integer(forKey: DEConfigs.maxZoomKey)
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.maxZoomKey)
            self.defaults.synchronize()
        }
    }
    
    var fontName: String {
        get {
            return self.defaults.string(forKey: DEConfigs.fontNameKey)!
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.fontNameKey)
            self.defaults.synchronize()
        }
    }
    
    var fontSize: Float {
        get {
            return self.defaults.float(forKey: DEConfigs.fontSizeKey)
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.fontSizeKey)
            self.defaults.synchronize()
        }
    }
    
    var duration: Int {
        get {
            return self.defaults.integer(forKey: DEConfigs.durationKey)
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.durationKey)
            self.defaults.synchronize()
        }
    }
    
    var videoEnabled: Bool {
        get {
            return self.defaults.bool(forKey: DEConfigs.videoEnabledKey)
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.videoEnabledKey)
            self.defaults.synchronize()
        }
    }
    
    var cameraAppPath: String {
        get {
            return self.defaults.string(forKey: DEConfigs.cameraAppPathKey)!
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.cameraAppPathKey)
            self.defaults.synchronize()
        }
    }
    
    var videoSavePath: String {
        get {
            return self.defaults.string(forKey: DEConfigs.videoSavePathKey)!
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.videoSavePathKey)
            self.defaults.synchronize()
        }
    }
    
    var imageTopics: [String] {
        get {
            return self.defaults.stringArray(forKey: DEConfigs.imageTopicsKey)!
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.imageTopicsKey)
            self.defaults.synchronize()
        }
    }
    
    func register() {
        let defaults: [String: Any] = [
            DEConfigs.apiKey          : "",
            DEConfigs.darkenKey       : 15,
            DEConfigs.maxZoomKey      : 175,
            DEConfigs.fontNameKey     : "Menlo-Regular",
            DEConfigs.fontSizeKey     : 45,
            DEConfigs.durationKey     : 15,
            DEConfigs.videoEnabledKey : true,
            DEConfigs.cameraAppPathKey: "SecurityCamera",
            DEConfigs.videoSavePathKey: "~/Movies",
            DEConfigs.imageTopicsKey  : [
                "nature",
                "landscape",
                "water",
                "sea",
                "forest",
                "outdoor",
                "indoor",
                "interior",
                "wallpaper",
                "urban",
                "city",
                "street",
                "tropical",
                "rock",
                "abandoned",
                "adventure",
                "architecture",
                "retro",
                "vintage",
                "coffee",
                "espresso",
                "cafe",
                "mac",
                "imac",
                "macbook",
                "iphone",
                "ipad",
                "android",
                "computer",
                "programming",
                "technology",
                "animal"
            ]
        ]
        
        self.defaults.register(defaults: defaults)
    }
    
    private static func defaults() -> ScreenSaverDefaults {
        guard let bundleId: String = Bundle(for: DEConfigs.self).bundleIdentifier else {
            fatalError("Could not find a bundle identifier")
        }
        
        guard let defaults: ScreenSaverDefaults = ScreenSaverDefaults(forModuleWithName: bundleId) else {
            fatalError("Could not create ScreenSaverDefaults instance")
        }
        
        return defaults
    }
}
