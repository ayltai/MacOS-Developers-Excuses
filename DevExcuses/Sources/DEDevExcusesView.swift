import Cocoa
import RxSwift
import ScreenSaver

class DEDevExcusesView: ScreenSaverView {
    private struct Constants {
        let excuseStyle    : NSMutableParagraphStyle = NSMutableParagraphStyle()
        let userNameStyle  : NSMutableParagraphStyle = NSMutableParagraphStyle()
        let profileUrlStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        let excuseShadow   : NSShadow                = NSShadow()
        let creditShadow   : NSShadow                = NSShadow()
        
        var excuseFont: NSFont?
        var creditFont: NSFont?
        
        init(isPreview: Bool) {
            self.excuseFont = NSFont(name: DEConfigs.Excuse.Font.name, size: isPreview ? DEConfigs.Excuse.Font.preview : DEConfigs.Excuse.Font.size)
            self.creditFont = NSFont(name: DEConfigs.Credit.Font.name, size: isPreview ? DEConfigs.Credit.Font.preview : DEConfigs.Credit.Font.size)
            
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
    
    private var constants : Constants!
    private var excuse    : NSString?
    private var userName  : NSString?
    private var profileUrl: NSString?
    private var imageView : DEKenBurnsView?
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
                    self.excuse     = error.localizedDescription as NSString
                    self.userName   = nil
                    self.profileUrl = nil
                    
                    self.setNeedsDisplay(self.frame)
                } else if let photo = event.element {
                    photo.download()
                        .observeOn(MainScheduler.instance)
                        .subscribeOn(CurrentThreadScheduler.instance)
                        .subscribe{ event in
                            if let error = event.error {
                                self.excuse     = error.localizedDescription as NSString
                                self.userName   = nil
                                self.profileUrl = nil
                            } else if let data = event.element {
                                if let user = photo.user {
                                    self.userName = user.name as NSString?
                                    
                                    if let links = user.links {
                                        self.profileUrl = links.html as NSString?
                                    }
                                }
                                
                                self.excuse = DEConfigs.excuses[DEConfigs.excuses.count.random()] as NSString
                                
                                let imageView: DEKenBurnsView = DEKenBurnsView(frame: self.frame)
                                self.addSubview(imageView)
                                
                                imageView.image = NSImage(data: data)
                                imageView.animate(duration: DEConfigs.refreshTimeInterval)
                                
                                if let oldImageView = self.imageView {
                                    oldImageView.removeFromSuperview()
                                }
                                
                                self.imageView = imageView
                            }
                            
                            self.setNeedsDisplay(self.frame)
                        }
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let excuse = self.excuse, let constants = self.constants, let font = constants.excuseFont {
            let lineHeight = font.lineHeight
            
            excuse.draw(
                font  : font,
                drawIn: NSRect(x: self.frame.origin.x, y: CGFloat((Int(self.frame.size.height) - Int(lineHeight) * 4) / 2), width: self.frame.size.width, height: CGFloat(lineHeight) * 3),
                style : constants.excuseStyle,
                shadow: constants.excuseShadow
            )
        }
        
        if let constants = self.constants, let font = constants.creditFont {
            let lineHeight = font.lineHeight
            
            if let userName = self.userName {
                ((DEConfigs.Credit.userNamePrefix + String(userName)) as NSString).draw(
                    font  : font,
                    drawIn: NSRect(x: CGFloat(Int(self.frame.origin.x) + DEConfigs.textMargin), y: self.frame.origin.y, width: CGFloat(Int(self.frame.size.width) - DEConfigs.textMargin * 2), height: CGFloat(lineHeight) * 1.5),
                    style : constants.userNameStyle,
                    shadow: constants.creditShadow
                )
            }
            
            if let profileUrl = self.profileUrl {
                ((String(profileUrl) + DEConfigs.Credit.profileUrlSuffix) as NSString).draw(
                    font  : font,
                    drawIn: NSRect(x: CGFloat(Int(self.frame.origin.x) + DEConfigs.textMargin), y: self.frame.origin.y, width: CGFloat(Int(self.frame.size.width) - DEConfigs.textMargin * 2), height: CGFloat(lineHeight) * 1.5),
                    style : constants.profileUrlStyle,
                    shadow: constants.creditShadow
                )
            }
        }
    }
}
