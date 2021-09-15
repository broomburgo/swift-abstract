@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class IdempotentMonoidTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: IdempotentMonoid<Ordering>.self,
      onInstances: [
        ("ordering", .ordering),
      ],
      equating: ==
    )

    verifyAllLaws(
      ofStructure: IdempotentMonoid<Int?>.self,
      onInstances: [
        ("firstIfPossible", .firstIfPossible()),
        ("lastIfPossible", .lastIfPossible()),
      ],
      equating: ==
    )
  }

  func testLawsOfFunctionBasedStructure() {
    verifyAllLaws(
      ofFunctionBasedStructure: IdempotentMonoid<(String) -> Ordering>.self,
      onInstances: [
        ("ordering", .ordering),
      ],
      constructedBy: { .function(over: $0) },
      equating: { input in { $0(input) == $1(input) } }
    )

    verifyAllLaws(
      ofFunctionBasedStructure: IdempotentMonoid<(String) -> Int?>.self,
      onInstances: [
        ("firstIfPossible", .firstIfPossible()),
        ("lastIfPossible", .lastIfPossible()),
      ],
      constructedBy: { .function(over: $0) },
      equating: { input in { $0(input) == $1(input) } }
    )
  }

  static var allTests = [
    ("testLawsOfRegularStructure", testLawsOfRegularStructure),
    ("testLawsOfFunctionBasedStructure", testLawsOfFunctionBasedStructure),
  ]
}
