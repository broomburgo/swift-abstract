@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class SwiftAbstractTests: XCTestCase {
  func testExample() {
    let verify = VerifyTwo(operations: Boolean.bool)

    property("Boolean.bool respects laws") <- forAll { (a: Bool, b: Bool, c: Bool) in
      verify.absorbability(a, b) <?> "absorbability"
        ^&&^ verify.associativity(a, b, c) <?> "associativity"
        ^&&^ verify.commutativity(a, b) <?> "commutativity"
        ^&&^ verify.distributivity(a, b, c) <?> "distributivity"
        ^&&^ verify.excludedMiddle(a) <?> "excludedMiddle"
        ^&&^ verify.idempotency(a, b) <?> "idempotency"
        ^&&^ verify.implication(a, b, c) <?> "implication"
        ^&&^ verify.oneIdentity(a) <?> "oneIdentity"
        ^&&^ verify.zeroIdentity(a) <?> "zeroIdentity"
    }
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
