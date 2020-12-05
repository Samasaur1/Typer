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
                var sleepTime: UInt32 = 0080000
                sleepTime += arc4random_uniform(5) * 10000
                sleepTime = additionalVariance(baseRate: sleepTime)
                if debug {
                    print("Sleeping for \(sleepTime) µseconds")
                }
                usleep(sleepTime)
            case .customConsistent(let µsecondDelay):
                if debug {
                    print("Sleeping for custom time: \(µsecondDelay) µseconds")
                }
                usleep(µsecondDelay)
            case let .customVarying(µsecondBaseDelay, maxVariance, additionalRandomness):
                var sleepTime = arc4random_uniform(5)
                sleepTime *= (maxVariance / 2)
                let preSubtraction = µsecondBaseDelay + sleepTime
                let initialDelay = preSubtraction - min(preSubtraction, maxVariance) //ensures that delay is not negative
                let µsecondDelay = (additionalRandomness ? additionalVariance(baseRate:) : identity(_:))(initialDelay)
                if debug {
                    print("Sleeping for custom time (with variance): \(µsecondDelay) µseconds")
                }
                usleep(µsecondDelay)
            }
            //usleep(1000000) <- 1 second
//            usleep(0020000)
        }
    }

    private static func additionalVariance(baseRate: UInt32) -> UInt32 {
        var base = Int64(baseRate)
        base += Int64(arc4random_uniform(5) * 1000)
        base += Int64(arc4random_uniform(11) * 100)
        base += Int64(arc4random_uniform(21) * 10)
        base += Int64(arc4random_uniform(21))
        base -= 2610
        if base < 0 { return 0 }
        if base > UInt32.max { return .max }
        return UInt32(base)
    }
    /// An enum representing possible typing rates.
    ///
    /// - allAtOnce: All the text should be typed at once.
    /// - consistent: The text should be typed at a reasonable speed, but with no variance in delay.
    /// - natural: The text should be typed so that it appears natural.
    /// - customConsistent: The text should be typed at a consistent speed, specified by the associated value.
    /// - customVarying: The text should be typed around a given speed, with 5 possible ranges of variation. Both the base speed and the maximum variance are specified by associated values.
    public enum Rate {
        /// All the text should be typed at once.
        case allAtOnce
        /// The text should be typed at a reasonable speed, but with no variance in delay.
        case consistent
        /// The text should be typed so that it appears natural.
        case natural
        /// The text should be typed at a specified consistent speed.
        /// - µsecondDelay: The delay between each key typed.
        case customConsistent(µsecondDelay: UInt32)
        /// The text should be typed around a specified given speed, with specified variation. The base delay should be the average delay time, and the max variance is the maximum distance from the average to the fastest/slowest possible delay.
        /// - µsecondBaseDelay: The base delay between each key typed.
        /// - maxVariance: The delay between each key typed.
        /// - additionalRandomness: Whether or not to add additional randomness. This randomness has a maximum variance of 2610 µseconds.
        case customVarying(µsecondBaseDelay: UInt32, maxVariance: UInt32, additionalRandomness: Bool)

        /// The text should be typed around a specified given speed, with specified variation. The base delay should be the average delay time, and the max variance is the maximum distance from the average to the fastest/slowest possible delay.
        /// - Parameters:
        ///   - µsecondBaseDelay: The base delay between each key typed.
        ///   - maxVariance: The delay between each key typed.
        @available(*, deprecated, message: "Specify whether or not to have additional randomness")
        static func customVarying(µsecondBaseDelay: UInt32, maxVariance: UInt32) -> Rate {
            return .customVarying(µsecondBaseDelay: µsecondBaseDelay, maxVariance: maxVariance, additionalRandomness: false)
        }
    }
}

private func identity<T>(_ el: T) -> T {
    return el
}
