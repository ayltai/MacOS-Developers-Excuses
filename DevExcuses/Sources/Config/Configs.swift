import ScreenSaver

final class Configs: NSObject {
    public static let videoSavePathSuffix = "/SecurityCamera-%timestamp%.mov"

    private static let backgroundEnabledKey = "backgroundEnabled"
    private static let animationEnabledKey  = "animationEnabled"
    private static let darkenKey            = "darken"
    private static let maxZoomKey           = "maxZoom"
    private static let durationKey          = "duration"
    private static let videoEnabledKey      = "videoEnabled"
    private static let cameraAppPathKey     = "cameraAppPath"
    private static let videoSavePathKey     = "videoSavePath"
    private static let imageTopicsKey       = "imageTopics"

    private let defaults: ScreenSaverDefaults = Configs.defaults()

    override init() {
        super.init()

        self.register()
    }

    var backgroundEnabled: Bool {
        get {
            return self.defaults.bool(forKey: Configs.backgroundEnabledKey)
        }

        set {
            self.set(newValue, forKey: Configs.backgroundEnabledKey)
        }
    }

    var animationEnabled: Bool {
        get {
            return self.defaults.bool(forKey: Configs.animationEnabledKey)
        }

        set {
            self.set(newValue, forKey: Configs.animationEnabledKey)
        }
    }

    var darken: Int {
        get {
            return self.defaults.integer(forKey: Configs.darkenKey)
        }

        set {
            self.set(newValue, forKey: Configs.darkenKey)
        }
    }

    var maxZoom: Int {
        get {
            return self.defaults.integer(forKey: Configs.maxZoomKey)
        }

        set {
            self.set(newValue, forKey: Configs.maxZoomKey)
        }
    }

    var duration: Int {
        get {
            return self.defaults.integer(forKey: Configs.durationKey)
        }

        set {
            self.set(newValue, forKey: Configs.durationKey)
        }
    }

    var videoEnabled: Bool {
        get {
            return self.defaults.bool(forKey: Configs.videoEnabledKey)
        }

        set {
            self.set(newValue, forKey: Configs.videoEnabledKey)
        }
    }

    var cameraAppPath: String {
        get {
            guard let value = self.defaults.string(forKey: Configs.cameraAppPathKey) else {
                return ""
            }

            return value
        }

        set {
            self.set(newValue, forKey: Configs.cameraAppPathKey)
        }
    }

    var videoSavePath: String {
        get {
            guard let value = self.defaults.string(forKey: Configs.videoSavePathKey) else {
                return ""
            }

            return value
        }

        set {
            self.set(newValue, forKey: Configs.videoSavePathKey)
        }
    }

    var imageTopics: [String] {
        get {
            guard let values = self.defaults.stringArray(forKey: Configs.imageTopicsKey) else {
                return []
            }

            return values
        }

        set {
            self.set(newValue, forKey: Configs.imageTopicsKey)
        }
    }

    func register() {
        let defaults: [String: Any] = [
            Configs.backgroundEnabledKey: true,
            Configs.animationEnabledKey : true,
            Configs.darkenKey           : 15,
            Configs.maxZoomKey          : 175,
            Configs.durationKey         : 15,
            Configs.videoEnabledKey     : true,
            Configs.cameraAppPathKey    : "SecurityCamera",
            Configs.videoSavePathKey    : "~/Movies",
            Configs.imageTopicsKey      : [
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
                "animal",
            ]
        ]

        self.defaults.register(defaults: defaults)
    }

    private func set(_ newValue: Any?, forKey: String) {
        self.defaults.set(newValue, forKey: forKey)
        self.defaults.synchronize()
    }

    private static func defaults() -> ScreenSaverDefaults {
        guard let bundleId = Bundle(for: Configs.self).bundleIdentifier else {
            fatalError("Could not find a bundle identifier")
        }

        guard let defaults = ScreenSaverDefaults(forModuleWithName: bundleId) else {
            fatalError("Could not create ScreenSaverDefaults instance")
        }

        return defaults
    }
}
