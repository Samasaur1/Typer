import Foundation
import ShellOut

public final class Typer {
    private init() {}
    public static func type(_ text: String) {
        try? shellOut(to: "osascript", arguments: ["-e", "tell application \"System Events\" to keystroke \"\(text)\""])
    }
}
