import Cocoa

final class KenBurnsView: NSImageView {
    private let configs = Configs()

    func animate(image: NSImage?, alpha: CGFloat, duration: TimeInterval) {
        self.image = image

        guard let image = self.image else {
            return
        }

        let width          = Double(image.size.width)
        let height         = Double(image.size.height)
        let maxScale       = Double(self.configs.maxZoom) / 100
        let fromScale      = Double.random(min: 1, max: maxScale)
        let toScale        = Double.random(min: 1, max: maxScale)
        let minTranslation = -(maxScale - 1)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.autoreverses = true
        scaleAnimation.duration     = duration
        scaleAnimation.fromValue    = fromScale
        scaleAnimation.toValue      = toScale

        let xAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        xAnimation.autoreverses = true
        xAnimation.duration     = duration
        xAnimation.fromValue    = KenBurnsView.randomTranslation(min: minTranslation, max: width, scale: fromScale)
        xAnimation.toValue      = KenBurnsView.randomTranslation(min: minTranslation, max: width, scale: toScale)

        let yAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        yAnimation.autoreverses = true
        yAnimation.duration     = duration
        yAnimation.fromValue    = KenBurnsView.randomTranslation(min: minTranslation, max: height, scale: fromScale)
        yAnimation.toValue      = KenBurnsView.randomTranslation(min: minTranslation, max: height, scale: toScale)

        let layer = CALayer()
        layer.add(scaleAnimation, forKey: scaleAnimation.keyPath)
        layer.add(xAnimation, forKey: xAnimation.keyPath)
        layer.add(yAnimation, forKey: yAnimation.keyPath)

        self.layer      = layer
        self.alphaValue = alpha
    }

    private static func randomTranslation(min: Double, max: Double, scale: Double) -> Double {
        return max * (scale - 1) * Double.random(min: min, max: 0)
    }
}
