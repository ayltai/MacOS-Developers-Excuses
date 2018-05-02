import Cocoa
import RxSwift
import ScreenSaver

class DEDevExcusesView: ScreenSaverView {
    private struct Constants {
        let excuseStyle     : NSMutableParagraphStyle = NSMutableParagraphStyle()
        let userNameStyle   : NSMutableParagraphStyle = NSMutableParagraphStyle()
        let profileUrlStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        let excuseShadow    : NSShadow                = NSShadow()
        let creditShadow    : NSShadow                = NSShadow()
        let excuseFont      : NSFont!
        let creditFont      : NSFont!
        let excuseLineHeight: Float
        let creditLineHeight: Float
        
        init(isPreview: Bool) {
            self.excuseFont       = NSFont(name: DEConfigs.Excuse.Font.name, size: isPreview ? DEConfigs.Excuse.Font.preview : DEConfigs.Excuse.Font.size)
            self.creditFont       = NSFont(name: DEConfigs.Credit.Font.name, size: isPreview ? DEConfigs.Credit.Font.preview : DEConfigs.Credit.Font.size)
            self.excuseLineHeight = self.excuseFont.lineHeight
            self.creditLineHeight = self.creditFont.lineHeight
            
            self.excuseStyle.alignment     = NSTextAlignment.center
            self.userNameStyle.alignment   = NSTextAlignment.left
            self.profileUrlStyle.alignment = NSTextAlignment.right
            
            self.excuseShadow.shadowColor      = NSColor.black
            self.excuseShadow.shadowOffset     = CGSize(width: DEConfigs.Excuse.Shadow.offset, height: -DEConfigs.Excuse.Shadow.offset)
            self.excuseShadow.shadowBlurRadius = DEConfigs.Excuse.Shadow.radius
            
            self.creditShadow.shadowColor      = NSColor.black
            self.creditShadow.shadowOffset     = CGSize(width: DEConfigs.Credit.Shadow.offset, height: -DEConfigs.Credit.Shadow.offset)
            self.creditShadow.shadowBlurRadius = DEConfigs.Credit.Shadow.radius
        }
    }
    
    private var imageView     : DEKenBurnsView?
    private var excuseView    : NSTextField?
    private var userNameView  : NSTextField?
    private var profileUrlView: NSTextField?
    
    private var constants : Constants!
    private var client    : DEClient!
    private var process   : Process    = Process()
    private var disposeBag: DisposeBag = DisposeBag()
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        self.animationTimeInterval = DEConfigs.refreshTimeInterval
        self.constants             = Constants(isPreview: isPreview)
        self.client                = DEClient(apiKey: DEConfigs.Image.apiKey)
        
        self.process.launchPath = "SecurityCamera"
        self.process.arguments  = ["/tmp/security-"]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func startAnimation() {
        if !self.isPreview && !self.process.isRunning {
            self.process.launch()
        }
        
        super.startAnimation()
    }
    
    override func stopAnimation() {
        if !self.isPreview && self.process.isRunning {
            self.process.terminate()
        }
        
        super.stopAnimation()
    }
    
    override func animateOneFrame() {
        self.client.random(size: self.frame.size, query: DEConfigs.Image.topics)
            .subscribe{ event in
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
                        .subscribe{ event in
                            if let error = event.error {
                                self.update(
                                    excuse    : error.localizedDescription,
                                    background: nil,
                                    userName  : nil,
                                    profileUrl: nil
                                )
                            } else if let data       = event.element,
                                      let user       = photo.user,
                                      let userName   = user.name,
                                      let links      = user.links,
                                      let profileUrl = links.html {
                                self.update(
                                    excuse    : DEConfigs.excuses[DEConfigs.excuses.count.random()],
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
    
    private func update(excuse: String, background: Data?, userName: String?, profileUrl: String?) {
        if let background = background {
            self.updateImageView(data: background)
        }
        
        if let userName = userName {
            let userNameView: NSTextField = self.updateTextField(
                string   : DEConfigs.Credit.userNamePrefix + userName,
                alignment: self.constants.userNameStyle.alignment,
                font     : self.constants.creditFont,
                shadow   : self.constants.creditShadow,
                frame    : NSRect(
                    x     : CGFloat(Int(self.frame.origin.x) + DEConfigs.textMargin),
                    y     : self.frame.origin.y,
                    width : CGFloat(Int(self.frame.size.width) - DEConfigs.textMargin * 2),
                    height: CGFloat(self.constants.creditLineHeight) * 1.5))
            
            if let oldUserNameView = self.userNameView {
                oldUserNameView.removeFromSuperview()
            }
            
            self.userNameView = userNameView
        }
        
        if let profileUrl = profileUrl {
            let profileUrlView: NSTextField = self.updateTextField(
                string   : profileUrl + DEConfigs.Credit.profileUrlSuffix,
                alignment: self.constants.profileUrlStyle.alignment,
                font     : self.constants.creditFont,
                shadow   : self.constants.creditShadow,
                frame    : NSRect(
                    x     : CGFloat(Int(self.frame.origin.x) + DEConfigs.textMargin),
                    y     : self.frame.origin.y,
                    width : CGFloat(Int(self.frame.size.width) - DEConfigs.textMargin * 2),
                    height: CGFloat(self.constants.creditLineHeight) * 1.5))
            
            if let oldProfileUrlView = self.profileUrlView {
                oldProfileUrlView.removeFromSuperview()
            }
            
            self.profileUrlView = profileUrlView
        }
        
        let excuseView: NSTextField = self.updateTextField(
            string   : excuse,
            alignment: self.constants.excuseStyle.alignment,
            font     : self.constants.excuseFont,
            shadow   : self.constants.excuseShadow,
            frame    : NSRect(
                x     : self.frame.origin.x,
                y     : CGFloat((Int(self.frame.size.height) - Int(self.constants.excuseLineHeight) * 4) / 2),
                width : self.frame.size.width,
                height: CGFloat(self.constants.excuseLineHeight) * 3))
        
        if let oldExcuseView = self.excuseView {
            oldExcuseView.removeFromSuperview()
        }
        
        self.excuseView = excuseView
    }
    
    private func updateImageView(data: Data) {
        let imageView: DEKenBurnsView = DEKenBurnsView(frame: self.frame)
        self.addSubview(imageView)
        
        imageView.animate(
            image   : NSImage(data: data),
            alpha   : DEConfigs.Image.alpha,
            duration: DEConfigs.refreshTimeInterval)
        
        if let oldImageView = self.imageView {
            oldImageView.removeFromSuperview()
        }
        
        self.imageView = imageView
    }
    
    private func updateTextField(string: String, alignment: NSTextAlignment, font: NSFont, shadow: NSShadow, frame: NSRect) -> NSTextField {
        let textField: NSTextField = NSTextField(frame: frame)
        
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
