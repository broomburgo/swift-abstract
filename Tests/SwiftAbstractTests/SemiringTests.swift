@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class SemiringTests: XCTestCase {
  func testLaws() {
    verifyAllLaws(
      ofStructure: Semiring<Float>.self,
      onInstances: [
        ("max tropical", .maxTropical),
        ("min tropical", .minTropical)
      ],
      equating: {
        $0.isAlmostEqual(to: $1)
      }
    )
  }

  static var allTests = [
    ("testLaws", testLaws)
  ]
}
