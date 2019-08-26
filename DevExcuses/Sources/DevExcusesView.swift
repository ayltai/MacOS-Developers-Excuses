import Cocoa
import RxSwift
import ScreenSaver

class DevExcusesView: ScreenSaverView {
    private static let userNamePrefix   = "Unsplash > "
    private static let profileUrlSuffix = "?utm_source=Developers%20Excuses&utm_medium=referral"

    private static let excuses = [
        "I thought you signed off on that.",
        "That feature was slated for phase two.",
        "That feature would be outside the scope.",
        "It must be a hardware problem.",
        "It's never shown unexpected behavior like this before.",
        "There must be something strange in your data.",
        "Well, that's a first.",
        "I haven't touched that code in weeks.",
        "Oh, you said you DIDN'T want that to happen?",
        "That's already fixed. It just hasn't taken effect yet.",
        "I couldn't find any library that can even do that.",
        "I usually get a notification when that happens.",
        "Oh, that was just a temporary fix.",
        "It's never done that before.",
        "It's a compatibility issue.",
        "Everything looks fine on my end.",
        "That error means it was successful.",
        "I forgot to commit the code that fixes that.",
        "You must have done something wrong.",
        "That wasn't in the original specification.",
        "I haven't had any experience with that before.",
        "That's the fault of the graphic designer.",
        "I'll have to fix that at a later date.",
        "I told you yesterday it would be done by the end of today.",
        "I haven't been able to reproduce that.",
        "It's just some unlucky coincidence.",
        "I thought you signed off on that.",
        "That wouldn't be economically feasible.",
        "I didn't create that part of the program.",
        "It probably won't happen again.",
        "Actually, that's a feature.",
        "I have too many other high priority things to do right now.",
        "Our internet connection must not be working.",
        "It's always been like that.",
        "What did you type in wrong to get it to crash?",
        "I thought I finished that.",
        "The request must have dropped some packets.",
        "It is working on my computer.",
        "It was working yesterday.",
        "You are working with the wrong version.",
        "The third party application is causing the problem.",
        "Right now I am doing the analysis, so I haven't started the work yet.",
        "Please raise a defect, I will check it.",
        "Try restarting your machine.",
        "I don't think there's fault with my code.",
        "Someone must have changed my code.",
        "I had too many projects so I had to rush that feature.",
        "I'm still working on that.",
        "That's a character encoding issue.",
        "There must have been a miscommunication on the requirements.",
        "We weren't given enough time to write unit tests.",
        "Our code quality is up to industry standards.",
        "That is a known bug with the framework.",
        "That feature is a nice to have.",
        "Have you cleared your cache?",
        "That's been fixed, but the code still has to be released.",
        "That's been fixed on another branch.",
        "The developer who coded that doesn't work here anymore.",
        "That is part of the old system.",
        "It was probably a race condition.",
        "That is how we were asked to build it.",
        "There must be a problem with the virtual machine.",
        "We have to do it that way for security reasons.",
        "I just need one more day to work on that.",
        "That code was written by the last guy.",
        "It was such a simple change I didn't think it needed testing.",
        "The file must have corrupted.",
        "There is nothing in my error logs.",
        "That's an industry best practice.",
        "It must be an issue with the firewall.",
        "It's just a warning, not an error.",
        "There's only a one in a million chance of that error occurring.",
        "That software should have been updated ages ago.",
        "Are you sure you want it to work that way?",
        "I'm pretty sure that works most of the time.",
        "I was busy fixing more important issues.",
        "I'm not familiar with it so I didn't fix it in case I made it worse",
        "How is that possible",
        "The third party documentation is wrong",
        "The project manager told me to do it that way",
        "My time was split in a way that meant I couldn't do either project properly",
        "The existing design makes it difficult to do the right thing",
    ]

    private static let duration  : TimeInterval = 15
    private static let textMargin: Int          = 8

    private lazy var configSheetController: ConfigSheetController = {
        return ConfigSheetController()
    }()

    private let configs = Configs()

    private let excuseStyle     = NSMutableParagraphStyle()
    private let userNameStyle   = NSMutableParagraphStyle()
    private let profileUrlStyle = NSMutableParagraphStyle()
    private let excuseShadow    = NSShadow()
    private let creditShadow    = NSShadow()

    private var excuseLineHeight: Float = 0
    private var creditLineHeight: Float = 0
    private var excuseFont      : NSFont?
    private var creditFont      : NSFont?

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
            name: self.configs.fontName,
            size: isPreview
                ? CGFloat(self.configs.fontSize) / 3.75
                : CGFloat(self.configs.fontSize)) {
            self.excuseLineHeight = excuseFont.lineHeight
            self.excuseFont       = excuseFont
        }

        if let creditFont = NSFont(
            name: self.configs.fontName,
            size: isPreview
                ? CGFloat(self.configs.fontSize) / 7.5
                : CGFloat(self.configs.fontSize / 3.75)) {
            self.creditLineHeight = creditFont.lineHeight
            self.creditFont       = creditFont
        }

        self.excuseStyle.alignment     = NSTextAlignment.center
        self.userNameStyle.alignment   = NSTextAlignment.left
        self.profileUrlStyle.alignment = NSTextAlignment.right

        self.excuseShadow.shadowColor      = NSColor.black
        self.excuseShadow.shadowBlurRadius = CGFloat(self.configs.fontSize / 4)

        self.creditShadow.shadowColor      = NSColor.black
        self.creditShadow.shadowBlurRadius = CGFloat(self.configs.fontSize / 8)

        self.client                = UnsplashClient(apiKey: self.configs.apiKey)
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
                                    excuse    : DevExcusesView.excuses[DevExcusesView.excuses.count.random()],
                                    background: data,
                                    userName  : userName,
                                    profileUrl: profileUrl)
                            }

                            self.setNeedsDisplay(self.frame)
                        }
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func update(
        excuse    : String,
        background: Data?,
        userName  : String?,
        profileUrl: String?) {
        if let background = background {
            self.updateImageView(data: background)
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
            image   : NSImage(data: data),
            alpha   : CGFloat(1 - Float(self.configs.darken) / 100),
            duration: self.isPreview ? DevExcusesView.duration : Double(self.configs.duration))

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
