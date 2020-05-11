@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class BooleanTests: XCTestCase {
  func testProperties() {
    verifyAllProperties(
      ofStructure: Boolean<Bool>.self,
      checking: [
        ("absorbability", { $3.absorbability($0, $1) }),
        ("associativity", { $3.associativity($0, $1, $2) }),
        ("commutativity", { $3.commutativity($0, $1) }),
        ("distributivity", { $3.distributivity($0, $1, $2) }),
        ("excludedMiddle", { $3.excludedMiddle($0) }),
        ("idempotency", { $3.idempotency($0, $1) }),
        ("implication", { $3.implication($0, $1, $2) }),
        ("oneIdentity", { $3.oneIdentity($0) }),
        ("zeroIdentity", { $3.zeroIdentity($0) })
      ],
      onInstances: [
        ("bool", .bool)
      ]
    )
  }

  static var allTests = [
    ("testProperties", testProperties)
  ]
}
