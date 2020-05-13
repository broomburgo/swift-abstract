@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class BooleanTests: XCTestCase {
  func testProperties() {
    verifyAllProperties(
      ofStructure: Boolean<Bool>.self,
      onInstances: [
        ("bool", .bool)
      ],
      equating: ==
    )
  }

  static var allTests = [
    ("testProperties", testProperties)
  ]
}
