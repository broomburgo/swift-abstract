@testable import SwiftAbstract
import XCTest

extension Boolean where A == Bool {
  static var bool: Self {
    Boolean(
      first: BoundedSemilattice(
        apply: { $0 || $1 },
        empty: false
      ),
      second: BoundedSemilattice(
        apply: { $0 && $1 },
        empty: true
      ),
      implies: { !$0 || $1 }
    )
  }
}

final class SwiftAbstractTests: XCTestCase {
  func testExample() {
    let verify = VerifyTwo(operations: Boolean.bool)

    [
      (true, true, true),
      (false, true, true),
      (true, false, true),
      (false, false, true),
      (true, true, false),
      (false, true, false),
      (true, false, false),
      (false, false, false),
    ].forEach { a, b, c in
      XCTAssert(verify.absorbability(a, b), "\(a), \(b)")
      XCTAssert(verify.associativity(a, b, c), "\(a), \(b), \(c)")
      XCTAssert(verify.commutativity(a, b), "\(a), \(b)")
      XCTAssert(verify.distributivity(a, b, c), "\(a), \(b), \(c)")
      XCTAssert(verify.excludedMiddle(a), "\(a)")
      XCTAssert(verify.idempotency(a, b), "\(a), \(b)")
      XCTAssert(verify.implication(a, b, c), "\(a), \(b), \(c)")
      XCTAssert(verify.oneIdentity(a), "\(a)")
      XCTAssert(verify.zeroIdentity(a), "\(a)")
    }
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
