@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class CommutativeMonoidTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: CommutativeMonoid<Int>.self,
      onInstances: [
        ("addition", .addition),
        ("multiplication", .multiplication)
      ],
      equating: ==
    )
  }

  func testLawsOfFunctionBasedStructure() {
      verifyAllLaws(
        ofFunctionBasedStructure: CommutativeMonoid<(String) -> Int>.self,
        onInstances: [
          ("addition", .addition),
          ("multiplication", .multiplication)
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
