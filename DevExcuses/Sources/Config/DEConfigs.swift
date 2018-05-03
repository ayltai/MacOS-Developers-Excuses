import ScreenSaver

final class DEConfigs: NSObject {
    private static let apiKey                : String = "api"
    private static let darkenKey             : String = "darken"
    private static let maxZoomKey            : String = "maxZoom"
    private static let excuseFontKey         : String = "excuseFont"
    private static let refreshTimeIntervalKey: String = "refreshTimeInterval"
    
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
    
    var excuseFont: NSFont {
        get {
            return self.defaults.object(forKey: DEConfigs.excuseFontKey) as! NSFont
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.excuseFontKey)
            self.defaults.synchronize()
        }
    }
    
    var refreshTimeInterval: Int {
        get {
            return self.defaults.integer(forKey: DEConfigs.refreshTimeIntervalKey)
        }
        
        set {
            self.defaults.set(newValue, forKey: DEConfigs.refreshTimeIntervalKey)
            self.defaults.synchronize()
        }
    }
    
    func register() {
        let defaults: [String: Any] = [
            DEConfigs.apiKey                : "3104011282514ae1ada27658f215704a7f44913a8c04cc2345f39c71c5cb24aa",
            DEConfigs.darkenKey             : 15,
            DEConfigs.maxZoomKey            : 175,
            DEConfigs.excuseFontKey         : NSFont(name: "Menlo", size: 45)!,
            DEConfigs.refreshTimeIntervalKey: 15
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
