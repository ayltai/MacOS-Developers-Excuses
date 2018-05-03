import Cocoa

final class DEKenBurnsView: NSImageView {
    private let configs: DEConfigs = DEConfigs()
    
    func animate(image: NSImage?, alpha: CGFloat, duration: TimeInterval) {
        self.image = image
        
        if let image = self.image {
            let width         : Double = Double(image.size.width)
            let height        : Double = Double(image.size.height)
            let maxScale      : Double = Double(self.configs.maxZoom) / 100
            let fromScale     : Double = Double.random(min: 1, max: maxScale)
            let toScale       : Double = Double.random(min: 1, max: maxScale)
            let minTranslation: Double = -(maxScale - 1)

            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.autoreverses = true
            scaleAnimation.duration     = duration
            scaleAnimation.fromValue    = fromScale
            scaleAnimation.toValue      = toScale
            
            let xAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
            xAnimation.autoreverses = true
            xAnimation.duration     = duration
            xAnimation.fromValue    = DEKenBurnsView.randomTranslation(min: minTranslation, max: width, scale: fromScale)
            xAnimation.toValue      = DEKenBurnsView.randomTranslation(min: minTranslation, max: width, scale: toScale)
            
            let yAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            yAnimation.autoreverses = true
            yAnimation.duration     = duration
            yAnimation.fromValue    = DEKenBurnsView.randomTranslation(min: minTranslation, max: height, scale: fromScale)
            yAnimation.toValue      = DEKenBurnsView.randomTranslation(min: minTranslation, max: height, scale: toScale)
            
            let layer = CALayer()
            layer.add(scaleAnimation, forKey: scaleAnimation.keyPath)
            layer.add(xAnimation,     forKey: xAnimation.keyPath)
            layer.add(yAnimation,     forKey: yAnimation.keyPath)
            
            self.layer      = layer
            self.alphaValue = alpha
        }
    }
    
    private static func randomTranslation(min: Double, max: Double, scale: Double) -> Double {
        return max * (scale - 1) * Double.random(min: min, max: 0)
    }
}
