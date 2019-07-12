import XCTest
@testable import SwiftCoreText

final class SwiftCoreTextTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftCoreText().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
