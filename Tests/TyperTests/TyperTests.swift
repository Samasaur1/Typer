import XCTest
@testable import Typer

final class TyperTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Typer().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
