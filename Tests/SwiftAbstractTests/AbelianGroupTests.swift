@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class AbelianGroupTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: AbelianGroup<Double>.self,
      onInstances: [
        ("addition", .addition),
        ("multiplication", .multiplication)
      ],
      equating: { $0.isAlmostEqual(to: $1) }
    )
  }

  func testLawsOfFunctionBasedStructure() {
      verifyAllLaws(
        ofFunctionBasedStructure: AbelianGroup<(String) -> Double>.self,
        onInstances: [
          ("addition", .addition),
          ("multiplication", .multiplication)
        ],
        constructedBy: { .function(over: $0) },
        equating: { input in { $0(input).isAlmostEqual(to: $1(input)) } }
      )
  }

  static var allTests = [
    ("testLawsOfRegularStructure", testLawsOfRegularStructure),
    ("testLawsOfFunctionBasedStructure", testLawsOfFunctionBasedStructure),
  ]
}
