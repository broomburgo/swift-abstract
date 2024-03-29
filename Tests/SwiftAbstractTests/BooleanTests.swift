@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class BooleanTests: XCTestCase {
  func testLaws() {
    verifyAllLaws(
      ofStructure: Boolean<Bool>.self,
      onInstances: [
        ("bool", .bool)
      ],
      equating: ==
    )
  }

  static var allTests = [
    ("testLaws", testLaws)
  ]
}
