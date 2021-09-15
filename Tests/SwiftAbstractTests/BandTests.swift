@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class BandTests: XCTestCase {
  func testLawsOfRegularStructure() {
    verifyAllLaws(
      ofStructure: Band<Int>.self,
      onInstances: [
        ("first", .first),
        ("last", .last),
      ],
      equating: ==
    )
  }

  func testLawsOfFunctionBasedStructure() {
      verifyAllLaws(
        ofFunctionBasedStructure: Band<(String) -> Int>.self,
        onInstances: [
          ("first", .first),
          ("last", .last),
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
