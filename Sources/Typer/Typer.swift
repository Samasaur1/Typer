import Foundation

public final class Typer {
    private init() {}
    #if os(Linux)
        static var initialized = false
    #endif
    public static func type(_ text: String, typing: Rate = .natural, printAlongWith printing: Bool = false, debug: Bool = false) {
        for character in text {
            if debug {
                print("Character:")
                print(character)
            }
            var toPrint: String
            if character == "'" {
                toPrint = "\"'\""
            } else if character == "\n" || character == "\r" {
                toPrint = "return"
            } else if character == "\t" {
                toPrint = "tab"
            } else if character == "\\" {
                toPrint = "\"\\\\\""
            } else if character == "\"" {
                toPrint = "\"\\\"\""
            } else {
                toPrint = "\"\(character)\""
            }
            if debug {
                print("toPrint:")
                print(toPrint)
            }
            if let applescript = NSAppleScript(source: "tell app \"System Events\" to keystroke \(toPrint)") {
                applescript.compileAndReturnError(nil)
                applescript.executeAndReturnError(nil)
                if debug {
                    print("AppleScript:")
                    print(applescript.source!)
                }
            } else {
                print("AppleScript initialization error!")
                exit(1)
            }
            if printing { print(toPrint) }
            switch typing {
            case .allAtOnce:
                usleep(0001000)
            case .consistent:
                usleep(0020000)
            case .natural:
                #if os(Linux)
                if !initialized {
                    srandom(UInt32(time(nil)))
                    initialized = true
                }
                let rand = UInt32(random())
                #else
                let rand = arc4random()
                #endif
                var sleepTime = rand % 5
                sleepTime *= 15000
                if debug {
                    print("Sleeping for \(0020000 + sleepTime) µseconds")
                }
                usleep(0020000 + sleepTime)
            case .customConsistent(let µsecondDelay):
                if debug {
                    print("Sleeping for custom time: \(µsecondDelay) µseconds")
                }
                usleep(µsecondDelay)
            case let .customVarying(µsecondBaseDelay, maxVariance):
                #if os(Linux)
                if !initialized {
                    srandom(UInt32(time(nil)))
                    initialized = true
                }
                let rand = UInt32(random())
                #else
                let rand = arc4random()
                #endif
                var sleepTime = rand % 5
                let base = µsecondBaseDelay - maxVariance
                sleepTime *= (maxVariance / 2)
                let µsecondDelay = base + sleepTime
                if debug {
                    print("Sleeping for custom time (with variance): \(µsecondDelay) µseconds")
                }
                usleep(µsecondDelay)
            }
            //usleep(1000000) <- 1 second
//            usleep(0020000)
        }
    }
    public enum Rate {
        case allAtOnce
        case consistent
        case natural
        case customConsistent(µsecondDelay: UInt32)
        case customVarying(µsecondBaseDelay: UInt32, maxVariance: UInt32)
    }
}
