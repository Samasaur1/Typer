import XCTest
@testable import Typer

final class TyperTests: XCTestCase {
    func typeEmptyString() {
        type("")
    }


    static var allTests = [
        ("typeEmptyString", typeEmptyString),
    ]
}
