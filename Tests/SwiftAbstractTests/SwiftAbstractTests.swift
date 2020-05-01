import XCTest
@testable import SwiftAbstract

final class SwiftAbstractTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftAbstract().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
