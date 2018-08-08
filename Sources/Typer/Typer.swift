import Foundation
import ShellOut

public final class Typer {
    private init() {}
    public static func type(_ text: String, typing: Rate = .natural) {
        do {
            for character in text {
                var toPrint: String
                if character == "'" {
                    toPrint = "\\'"
                } else if character == "\n" || character == "\r" {
                    toPrint = "return"
                } else if character == "\t" {
                    toPrint = "tab"
                } else {
                    toPrint = "\"\(character)\""
                }
                try shellOut(to: "osascript", arguments: ["-e", "'tell application \"System Events\" to keystroke \(toPrint)'"])
                switch typing {
                case .allAtOnce:
                    usleep(0001000)
                case .consistent:
                    usleep(0020000)
                case .natural:
                    let rand = arc4random()
                    var sleepTime = rand % 5
                    sleepTime *= 10000
                    usleep(0030000 + sleepTime)
                }
              //usleep(1000000) <- 1 second
//                usleep(0020000)
            }
        } catch let error as ShellOutError {
            print(error.message)
            print(error.output)
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
