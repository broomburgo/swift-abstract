@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class BoundedSemilatticeTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: BoundedSemilattice<Int>.self,
      onInstances: [
        ("min", .min),
        ("max", .max),
      ],
      equating: ==
    )

    verifyAllLaws(
      ofStructure: BoundedSemilattice<Bool>.self,
      onInstances: [
        ("and", .and),
        ("or", .or),
      ],
      equating: ==
    )
  }

  func testLawsOfFunctionBasedStructure() {
    verifyAllLaws(
      ofFunctionBasedStructure: BoundedSemilattice<(String) -> Int>.self,
      onInstances: [
        ("min", .min),
        ("max", .max),
      ],
      constructedBy: { .function(over: $0) },
      equating: { input in { $0(input) == $1(input) } }
    )

    verifyAllLaws(
      ofFunctionBasedStructure: BoundedSemilattice<(String) -> Bool>.self,
      onInstances: [
        ("and", .and),
        ("or", .or),
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
