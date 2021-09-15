@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class MonoidTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: Monoid<String>.self,
      onInstances: [
        ("string", .string),
      ],
      equating: ==
    )

    verifyAllLaws(
      ofStructure: Monoid<[Int]>.self,
      onInstances: [
        ("array", .array()),
      ],
      equating: ==
    )

    verifyAllLaws(
      ofStructure: Monoid<(Int) -> Int>.self,
      onInstances: [
        ("endo", .endo())
      ],
      equating: { (input: Int) in { $0(input) == $1(input) } },
      generating: { (generated: ArrowOf<Int, Int>) in generated.getArrow }
    )
  }

  func testLawsOfFunctionBasedStructure() {
    verifyAllLaws(
      ofFunctionBasedStructure: Monoid<(String) -> String>.self,
      onInstances: [
        ("string", .string),
      ],
      constructedBy: { .function(over: $0) },
      equating: { input in { $0(input) == $1(input) } }
    )

    verifyAllLaws(
      ofFunctionBasedStructure: Monoid<(String) -> [Int]>.self,
      onInstances: [
        ("array", .array()),
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
