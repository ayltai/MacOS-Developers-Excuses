import Cocoa

final class DEKenBurnsView: NSView {
    private var image           : NSImage?
    private var duration        : Double = DEConfigs.frameDuraion
    private var startTime       : Double = 0
    private var fromScale       : Double = 0
    private var toScale         : Double = 0
    private var fromTranslationX: Double = 0
    private var fromTranslationY: Double = 0
    private var toTranslationX  : Double = 0
    private var toTranslationY  : Double = 0
    
    func animate(image: NSImage?, duration: Double) {
        self.image     = image
        self.duration  = duration
        self.startTime = Date().timeIntervalSince1970
        self.fromScale = DEKenBurnsView.randomScale
        self.toScale   = DEKenBurnsView.randomScale
        
        if let image = self.image {
            self.fromTranslationX = DEKenBurnsView.randomTranslation(max: Double(image.size.width),  scale: fromScale)
            self.fromTranslationY = DEKenBurnsView.randomTranslation(max: Double(image.size.height), scale: fromScale)
            self.toTranslationX   = DEKenBurnsView.randomTranslation(max: Double(image.size.width),  scale: toScale)
            self.toTranslationY   = DEKenBurnsView.randomTranslation(max: Double(image.size.height), scale: toScale)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let image = self.image {
            let ratio       : Double = (Date().timeIntervalSince1970 - self.startTime) / self.duration
            let scale       : Double = (self.toScale - self.fromScale) * ratio + self.fromScale
            let translationX: Double = (self.toTranslationX - self.fromTranslationX) * ratio + self.fromTranslationX
            let translationY: Double = (self.toTranslationY - self.fromTranslationY) * ratio + self.fromTranslationY
            
            image.draw(
                in       : NSRect(x: CGFloat(translationX), y: CGFloat(translationY), width: CGFloat(Double(image.size.width) * scale), height: CGFloat(Double(image.size.height) * scale)),
                from     : NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height),
                operation: .sourceOver,
                fraction : DEConfigs.Image.alpha)
        }
    }
    
    private static var randomScale: Double {
        return Double.random(min: DEConfigs.Effect.minScale, max: DEConfigs.Effect.maxScale)
    }
    
    private static func randomTranslation(max: Double, scale: Double) -> Double {
        return max * (scale - 1) * Double.random(min: DEConfigs.Effect.minTranslation, max: DEConfigs.Effect.maxTranslation)
    }
}
