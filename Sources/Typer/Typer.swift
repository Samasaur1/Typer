import Foundation
import ShellOut

public final class Typer {
    private init() {}
    public static func type(_ text: String) {
        do {
            try shellOut(to: "osascript", arguments: ["-e", "tell application \"System Events\" to keystroke \"\(text)\""])
        } catch let error as ShellOutError {
            print(error.message)
            print(error.output)
        } catch {
            fatalError("THis is really bad")
        }
    }
}
