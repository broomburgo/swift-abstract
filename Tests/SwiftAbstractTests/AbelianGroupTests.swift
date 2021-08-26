@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class AbelianGroupTests: XCTestCase {
  func testProperties() {
      verifyAllLaws(
        ofFunctionBasedStructure: AbelianGroup<(String) -> Int>.self,
        onInstances: [("sum", .sum)],
        constructedBy: { .function(over: $0) },
        equating: { input in { $0(input) == $1(input) } }
      )
  }

  static var allTests = [
    ("testProperties", testProperties),
  ]
}
