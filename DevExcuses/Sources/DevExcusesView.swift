import Cocoa
import RxSwift
import ScreenSaver

class DevExcusesView: ScreenSaverView {
    private static let userNamePrefix   = "Unsplash > "
    private static let profileUrlSuffix = "?utm_source=Developers%20Excuses&utm_medium=referral"

    private static let textMargin: Int = 8

    private lazy var configSheetController: ConfigSheetController = {
        return ConfigSheetController()
    }()

    private let configs = Configs()

    private let excuseStyle     = NSMutableParagraphStyle()
    private let userNameStyle   = NSMutableParagraphStyle()
    private let profileUrlStyle = NSMutableParagraphStyle()
    private let excuseShadow    = NSShadow()
    private let creditShadow    = NSShadow()
    private let fontName        = "Menlo-Regular"

    private var excuseFont      : NSFont?
    private var creditFont      : NSFont?
    private var excuseLineHeight: Float = 0
    private var creditLineHeight: Float = 0

    private var imageView     : KenBurnsView?
    private var excuseView    : NSTextField?
    private var userNameView  : NSTextField?
    private var profileUrlView: NSTextField?

    private var client : UnsplashClient?
    private var process: Process?

    private var disposeBag = DisposeBag()

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)

        if let excuseFont = NSFont(
            name: self.fontName,
            size: self.bounds.width / 40) {
            self.excuseLineHeight = excuseFont.lineHeight
            self.excuseFont       = excuseFont
        }

        if let creditFont = NSFont(
            name: self.fontName,
            size: self.bounds.width / 120) {
            self.creditLineHeight = creditFont.lineHeight
            self.creditFont       = creditFont
        }

        self.excuseStyle.alignment     = NSTextAlignment.center
        self.userNameStyle.alignment   = NSTextAlignment.left
        self.profileUrlStyle.alignment = NSTextAlignment.right

        self.excuseShadow.shadowColor      = NSColor.black
        self.excuseShadow.shadowBlurRadius = self.bounds.width / 384

        self.creditShadow.shadowColor      = NSColor.black
        self.creditShadow.shadowBlurRadius = self.bounds.width / 512

        self.client                = UnsplashClient()
        self.animationTimeInterval = Double(self.configs.duration)

        if self.configs.videoEnabled && !isPreview {
            let process = Process()
            process.launchPath = self.configs.cameraAppPath
            process.arguments  = [self.configs.videoSavePath + "/SecurityCamera-"]

            self.process = process
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var hasConfigureSheet: Bool {
        return true
    }

    override var configureSheet: NSWindow! {
        return self.configSheetController.window
    }

    override func startAnimation() {
        if let process = self.process {
            if !self.isPreview && !process.isRunning {
                process.launch()
            }
        }

        super.startAnimation()
    }

    override func stopAnimation() {
        super.stopAnimation()

        if let process = self.process {
            if !self.isPreview && process.isRunning {
                process.terminate()
            }
        }
    }

    override func animateOneFrame() {
        if self.configs.backgroundEnabled {
            guard let client = self.client else {
                return
            }

            client.random(size: self.frame.size, query: self.configs.imageTopics)
                .subscribe { event in
                    if let error = event.error {
                        self.update(
                            excuse    : error.localizedDescription,
                            background: nil,
                            userName  : nil,
                            profileUrl: nil
                        )

                        self.setNeedsDisplay(self.frame)
                    } else if let photo = event.element {
                        photo.download()
                        .observeOn(MainScheduler.instance)
                        .subscribeOn(CurrentThreadScheduler.instance)
                        .subscribe { event in
                            if let error = event.error {
                                self.update(
                                    excuse    : error.localizedDescription,
                                    background: nil,
                                    userName  : nil,
                                    profileUrl: nil
                                )
                            } else if
                                let data       = event.element,
                                let user       = photo.user,
                                let userName   = user.name,
                                let links      = user.links,
                                let profileUrl = links.html {
                                self.update(
                                    excuse    : Constants.excuses[Constants.excuses.count.random()],
                                    background: data,
                                    userName  : userName,
                                    profileUrl: profileUrl
                                )
                            }

                            self.setNeedsDisplay(self.frame)
                        }
                        .disposed(by: self.disposeBag)
                    }
                }
                .disposed(by: self.disposeBag)
        } else {
            self.update(
                excuse    : Constants.excuses[Constants.excuses.count.random()],
                background: nil,
                userName  : nil,
                profileUrl: nil
            )
        }
    }

    private func update(
        excuse    : String,
        background: Data?,
        userName  : String?,
        profileUrl: String?) {
        if self.configs.backgroundEnabled {
            if let background = background {
                self.updateImageView(data: background)
            }
        }

        if
            let userName     = userName,
            let font         = self.creditFont {
            let userNameView = self.updateTextField(
                string   : DevExcusesView.userNamePrefix + userName,
                alignment: self.userNameStyle.alignment,
                font     : font,
                shadow   : self.creditShadow,
                frame: NSRect(
                    x     : CGFloat(Int(self.frame.origin.x) + DevExcusesView.textMargin),
                    y     : self.frame.origin.y,
                    width : CGFloat(Int(self.frame.size.width) - DevExcusesView.textMargin * 2),
                    height: CGFloat(self.creditLineHeight) * 1.5))

            if let oldUserNameView = self.userNameView {
                oldUserNameView.removeFromSuperview()
            }

            self.userNameView = userNameView
        }

        if
            let profileUrl = profileUrl,
            let font       = self.creditFont {
            let profileUrlView = self.updateTextField(
                string   : profileUrl + DevExcusesView.profileUrlSuffix,
                alignment: self.profileUrlStyle.alignment,
                font     : font,
                shadow   : self.creditShadow,
                frame: NSRect(
                    x     : CGFloat(Int(self.frame.origin.x) + DevExcusesView.textMargin),
                    y     : self.frame.origin.y,
                    width : CGFloat(Int(self.frame.size.width) - DevExcusesView.textMargin * 2),
                    height: CGFloat(self.creditLineHeight) * 1.5))

            if let oldProfileUrlView = self.profileUrlView {
                oldProfileUrlView.removeFromSuperview()
            }

            self.profileUrlView = profileUrlView
        }

        if let font = self.excuseFont {
            let excuseView = self.updateTextField(
                string   : excuse,
                alignment: self.excuseStyle.alignment,
                font     : font,
                shadow   : self.excuseShadow,
                frame: NSRect(
                    x     : self.frame.origin.x,
                    y     : CGFloat((Int(self.frame.size.height) - Int(self.excuseLineHeight) * 4) / 2),
                    width : self.frame.size.width,
                    height: CGFloat(self.excuseLineHeight) * 3))

            if let oldExcuseView = self.excuseView {
                oldExcuseView.removeFromSuperview()
            }

            self.excuseView = excuseView
        }
    }

    private func updateImageView(data: Data) {
        let imageView = KenBurnsView(frame: self.frame)
        imageView.wantsLayer = true

        self.addSubview(imageView)

        imageView.animate(
            image: NSImage(data: data),
            alpha: CGFloat(1 - Float(self.configs.darken) / 100))

        if let oldImageView = self.imageView {
            oldImageView.removeFromSuperview()
        }

        self.imageView = imageView
    }

    private func updateTextField(
        string   : String,
        alignment: NSTextAlignment,
        font     : NSFont,
        shadow   : NSShadow,
        frame    : NSRect) -> NSTextField {
        let textField = NSTextField(frame: frame)

        textField.wantsLayer      = true
        textField.drawsBackground = false
        textField.backgroundColor = NSColor.clear
        textField.textColor       = NSColor.white
        textField.isBezeled       = false
        textField.isEditable      = false
        textField.alignment       = alignment
        textField.font            = font
        textField.stringValue     = string
        textField.shadow          = shadow

        self.addSubview(textField)

        return textField
    }
}
