import Foundation
import ShellOut

public final class Typer {
    private init() {}
    public static func type(_ text: String) {
        do {
            for character in text {
                try shellOut(to: "osascript", arguments: ["-e", "'tell application \"System Events\" to keystroke \"\(character)\"'"])
              //usleep(1000000) <- 1 second
                usleep(0999000)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { print("Success!'") }
        } catch let error as ShellOutError {
            print(error.message)
            print(error.output)
        } catch {
            fatalError("This is really bad: Unknown error")
        }
    }
}
