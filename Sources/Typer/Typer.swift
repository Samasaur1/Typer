import Foundation
import ShellOut

public final class Typer {
    private init() {}
    #if os(Linux)
        static var initialized = false
    #endif
    public static func type(_ text: String, typing: Rate = .natural, printAlongWith printing: Bool = false) {
        do {
            for character in text {
                var toPrint: String
                if character == "'" {
                    toPrint = "\"'\"'\"'\""
                } else if character == "\n" || character == "\r" {
                    toPrint = "return"
                } else if character == "\t" {
                    toPrint = "tab"
                } else if character == "\\" {
                    toPrint = "\"\\\""
                } else {
                    toPrint = "\"\(character)\""
                }
                try shellOut(to: "osascript", arguments: ["-e", "'tell application \"System Events\" to keystroke \(toPrint)'"])
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
                    usleep(0020000 + sleepTime)
                }
              //usleep(1000000) <- 1 second
//                usleep(0020000)
            }
        } catch let error as ShellOutError {
            print(error.message)
            print(error.output)
            exit(1)
        } catch {
            fatalError("This is really bad: Unknown error")
        }
    }
    public enum Rate {
        case allAtOnce
        case consistent
        case natural
    }
}
