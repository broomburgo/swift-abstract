@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class AbelianGroupTests: XCTestCase {
  func testLaws() {
      verifyAllLaws(
        ofFunctionBasedStructure: AbelianGroup<(String) -> Int>.self,
        onInstances: [("addition", .addition)],
        constructedBy: { .function(over: $0) },
        equating: { input in { $0(input) == $1(input) } }
      )
  }

  static var allTests = [
    ("testLaws", testLaws),
  ]
}
