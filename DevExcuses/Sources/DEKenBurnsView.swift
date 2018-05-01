import Cocoa

final class DEKenBurnsView: NSView {
    private var image           : CIImage?
    private var imageWidth      : CGFloat = 0
    private var imageHeight     : CGFloat = 0
    private var duration        : Double  = DEConfigs.frameDuraion
    private var startTime       : Double  = 0
    private var fromScale       : Double  = 0
    private var toScale         : Double  = 0
    private var fromTranslationX: Double  = 0
    private var fromTranslationY: Double  = 0
    private var toTranslationX  : Double  = 0
    private var toTranslationY  : Double  = 0
    
    func animate(data: Data?, duration: Double) {
        self.duration  = duration
        self.startTime = Date().timeIntervalSince1970
        self.fromScale = DEKenBurnsView.randomScale
        self.toScale   = DEKenBurnsView.randomScale
        
        if let data: Data = data, let image: NSImage = NSImage(data: data) {
            self.image            = CIImage(data: data)
            self.imageWidth       = image.size.width
            self.imageHeight      = image.size.height
            self.fromTranslationX = DEKenBurnsView.randomTranslation(max: Double(self.imageWidth),  scale: fromScale)
            self.fromTranslationY = DEKenBurnsView.randomTranslation(max: Double(self.imageHeight), scale: fromScale)
            self.toTranslationX   = DEKenBurnsView.randomTranslation(max: Double(self.imageWidth),  scale: toScale)
            self.toTranslationY   = DEKenBurnsView.randomTranslation(max: Double(self.imageHeight), scale: toScale)
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
                in       : NSRect(x: CGFloat(translationX), y: CGFloat(translationY), width: CGFloat(Double(self.imageWidth) * scale), height: CGFloat(Double(self.imageHeight) * scale)),
                from     : NSRect(x: 0, y: 0, width: self.imageWidth, height: self.imageHeight),
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
