import Foundation

/// A class that allows Swift programs to type, simulating using the keyboard.
public final class Typer {
    /// A private initializer so this class can't be instantiated.
    private init() {}
    /// Types the given text as if the user was doing so on the keyboard.
    ///
    /// - Parameters:
    ///   - text: The text to type.
    ///   - typing: The rate to type at. Default: `.natural`.
    ///   - printing: Whether the text should be printed to STDOUT as it is typed. Default: `false`.
    ///   - debug: Whether this is typing in debug mode (prints extra information). Default: `false`.
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
                usleep(0100000)
            case .natural:
                var sleepTime = arc4random_uniform(5)
                sleepTime *= 10000
                if debug {
                    print("Sleeping for \(0080000 + sleepTime) µseconds")
                }
                usleep(0080000 + sleepTime)
            case .customConsistent(let µsecondDelay):
                if debug {
                    print("Sleeping for custom time: \(µsecondDelay) µseconds")
                }
                usleep(µsecondDelay)
            case let .customVarying(µsecondBaseDelay, maxVariance):
                var sleepTime = arc4random_uniform(5)
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
    /// An enum representing possible typing rates.
    ///
    /// - allAtOnce: All the text should be typed at once.
    /// - consistent: The text should be typed at a reasonable speed, but with no variance in delay.
    /// - natural: The text should be typed so that it appears natural.
    /// - customConsistent: The text should be typed at a consistent speed, specified by the associated value.
    /// - customVarying: The text should be typed around a given speed, with 5 possible ranges of variation. Both the base speed and the maximum variance are specified by associated values.
    public enum Rate {
        case allAtOnce
        case consistent
        case natural
        case customConsistent(µsecondDelay: UInt32)
        case customVarying(µsecondBaseDelay: UInt32, maxVariance: UInt32)
    }
}
