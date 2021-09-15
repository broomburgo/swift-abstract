@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class SemilatticeTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: Semilattice<Int>.self,
      onInstances: [
        ("max", .max),
        ("min", .min),
      ],
      equating: ==
    )
  }

  func testLawsOfFunctionBasedStructure() {
      verifyAllLaws(
        ofFunctionBasedStructure: Semilattice<(String) -> Int>.self,
        onInstances: [
          ("max", .max),
          ("min", .min),
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
