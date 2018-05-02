import Cocoa

final class DEKenBurnsView: NSImageView {
    func animate(image: NSImage?, alpha: CGFloat, duration: TimeInterval) {
        self.image = image
        
        if let image = self.image {
            let width    : Double = Double(image.size.width)
            let height   : Double = Double(image.size.height)
            let fromScale: Double = DEKenBurnsView.randomScale
            let toScale  : Double = DEKenBurnsView.randomScale

            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.autoreverses = true
            scaleAnimation.duration     = duration
            scaleAnimation.fromValue    = fromScale
            scaleAnimation.toValue      = toScale
            
            let xAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
            xAnimation.autoreverses = true
            xAnimation.duration     = duration
            xAnimation.fromValue    = DEKenBurnsView.randomTranslation(max: Double(width), scale: fromScale)
            xAnimation.toValue      = DEKenBurnsView.randomTranslation(max: Double(width), scale: toScale)
            
            let yAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            yAnimation.autoreverses = true
            yAnimation.duration     = duration
            yAnimation.fromValue    = DEKenBurnsView.randomTranslation(max: Double(height), scale: fromScale)
            yAnimation.toValue      = DEKenBurnsView.randomTranslation(max: Double(height), scale: toScale)
            
            let layer = CALayer()
            layer.add(scaleAnimation, forKey: scaleAnimation.keyPath)
            layer.add(xAnimation,     forKey: xAnimation.keyPath)
            layer.add(yAnimation,     forKey: yAnimation.keyPath)
            
            self.layer      = layer
            self.alphaValue = alpha
        }
    }
    
    private static var randomScale: Double {
        return Double.random(min: DEConfigs.Effect.minScale, max: DEConfigs.Effect.maxScale)
    }
    
    private static func randomTranslation(max: Double, scale: Double) -> Double {
        return max * (scale - 1) * Double.random(min: DEConfigs.Effect.minTranslation, max: DEConfigs.Effect.maxTranslation)
    }
}
