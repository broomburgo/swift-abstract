@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class FieldTests: XCTestCase {
  func testLaws() {
    verifyAllLaws(
      ofStructure: Field<Double>.self,
      onInstances: [
        ("real", .real)
      ],
      equating: ==
    )
  }

  static var allTests = [
    ("testLaws", testLaws)
  ]
}

