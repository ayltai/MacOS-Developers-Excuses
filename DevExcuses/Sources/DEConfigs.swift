import Foundation

struct DEConfigs {
    struct Excuse {
        struct Font {
            static let name   : String  = "Menlo"
            static let size   : CGFloat = 45
            static let preview: CGFloat = 10
        }
        
        struct Shadow {
            static let offset: CGFloat = 0
            static let radius: CGFloat = 10
        }
    }
    
    struct Credit {
        struct Font {
            static let name   : String  = "Menlo"
            static let size   : CGFloat = 12
            static let preview: CGFloat = 6
        }
        
        struct Shadow {
            static let offset: CGFloat = 0
            static let radius: CGFloat = 5
        }
        
        static let userNamePrefix  : String = "Unsplash > "
        static let profileUrlSuffix: String = "?utm_source=Developers%20Excuses&utm_medium=referral"
    }
    
    struct Image {
        static let apiKey: String   = ""
        static let alpha : CGFloat  = 0.85
        static let topics: [String] = [
            "nature",
            "landscape",
            "water",
            "outdoor",
            "indoor",
            "interior",
            "wallpaper",
            "urban",
            "city",
            "street",
            "tropical",
            "rock",
            "abandoned",
            "adventure",
            "architecture",
            "retro",
            "vintage",
            "coffee",
            "espresso",
            "cafe",
            "mac",
            "imac",
            "macbook",
            "iphone",
            "ipad",
            "android",
            "computer",
            "programming",
            "technology",
            "animal"
        ]
    }
    
    struct Effect {
        static let maxScale      : Double = 1.75
        static let minScale      : Double = 1
        static let maxTranslation: Double = 0
        static let minTranslation: Double = -(DEConfigs.Effect.maxScale - DEConfigs.Effect.minScale)
    }
    
    static let refreshTimeInterval: Double = 15.0
    static let frameDuraion       : Double = 1 / 30
    static let textMargin         : Int    = 16
    
    static let excuses: [String] = [
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
        "I was busy fixing more important issues."
    ]
}
