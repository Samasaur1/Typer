import Foundation
import ShellOut

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
                toPrint = "'"
            } else if character == "\n" || character == "\r" {
                toPrint = "return"
            } else if character == "\t" {
                toPrint = "tab"
            } else if character == "\\" {
                toPrint = "\\\\\\\\"
            } else if character == "\"" {
                toPrint = "\\\\\\\\\\\\\""
            } else {
                toPrint = "\(character)"
            }
            if debug {
                print("toPrint:")
                print(toPrint)
            }
            var osascriptCommand = """
            \\"tell application \\\\\\"System Events\\\\\\" to keystroke \\\\\\"\(toPrint)\\\\\\"\\"
            """
            if debug {
                print("Shell command:")
                print("/bin/bash -c \"\(osascriptCommand)\"")
                print("AppleScript (osascript) command:")
                print(osascriptCommand)
            }
            do {
                try shellOut(to: "osascript", arguments: ["-e", osascriptCommand])
            } catch let error {
                print("Error")
                print(error)
                print(error.localizedDescription)
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
            }
            //usleep(1000000) <- 1 second
//            usleep(0020000)
        }
    }
    public enum Rate {
        case allAtOnce
        case consistent
        case natural
    }
}
