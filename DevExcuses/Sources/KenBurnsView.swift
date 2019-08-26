import Cocoa

final class KenBurnsView: NSImageView {
    private let configs = Configs()

    private var duration: TimeInterval = 15

    func animate(image: NSImage?, alpha: CGFloat, duration: TimeInterval) {
        self.image      = image
        self.alphaValue = alpha
        self.duration   = duration
    }

    override var wantsUpdateLayer: Bool {
        return true
    }

    override func makeBackingLayer() -> CALayer {
        let width          = Double(self.frame.size.width)
        let height         = Double(self.frame.size.height)
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

        return layer
    }

    private static func randomTranslation(min: Double, max: Double, scale: Double) -> Double {
        return max * (scale - 1) * Double.random(min: min, max: 0)
    }
}
