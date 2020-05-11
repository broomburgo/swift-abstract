@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class SemigroupTests: XCTestCase {
  func testProperties() {
    verifyProperties(onValue: Int.self, ofInstances: [
      ("first", .first),
      ("last", .last),
      ("max", .max),
      ("min", .min),
      ("product", .product),
      ("sum", .sum)
    ])

    verifyProperties(onValue: Bool.self, ofInstances: [
      ("and", .and),
      ("or", .or)
    ])

    verifyProperties(onValue: String.self, ofInstances: [
      ("string", .string)
    ])

    verifyProperties(onValue: Ordering.self, ofInstances: [
      ("ordering", .ordering)
    ])

    verifyProperties(onValue: Int?.self, ofInstances: [
      ("firstIfPossible", .firstIfPossible()),
      ("lastIfPossible", .lastIfPossible())
    ])

    verifyProperties(onValue: [Int].self, ofInstances: [
      ("array", .array())
    ])

    verifyProperties(onValue: Set<Int>.self, ofInstances: [
      ("setIntersection", .setIntersection()),
      ("setUnion", .setUnion())
    ])

    verifyFunctionInstancesProperties()
  }

  private func verifyProperties<A: Equatable & Arbitrary>(
    onValue: A.Type,
    ofInstances semigroups: [(name: String, instance: Semigroup<A>)],
    file: StaticString = #file,
    line: UInt = #line
  ) {
    property("Semigroup instances respect some laws", file: file, line: line) <- forAll { (a: A, b: A, c: A) in
      semigroups.reduce(TestResult.succeeded.property) { $0
        ^&&^ VerifyOne($1.instance, equating: ==).associativity(a, b, c) <?> "Semigroup.\($1.name) is associative"
      }
    }
  }

  private func verifyFunctionInstancesProperties(file: StaticString = #file, line: UInt = #line) {
    let endo = Semigroup<(Int) -> Int>.endo()

    property("Semigroup.endo respects some laws", file: file, line: line) <- forAll { (a: ArrowOf<Int, Int>, b: ArrowOf<Int, Int>, c: ArrowOf<Int, Int>, value: Int) in
      let verifyEndo = VerifyOne(endo) { $0(value) == $1(value) }

      return verifyEndo.associativity(a.getArrow, b.getArrow, c.getArrow) <?> "Semigroup.endo is associative"
    }

    struct GeneratedSemigroup: Arbitrary {
      let get: Semigroup<Int>

      static var arbitrary: Gen<GeneratedSemigroup> {
        Gen<Semigroup<Int>>.fromElements(of: [
          .first,
          .last,
          .max,
          .min,
          .product,
          .sum
        ]).map {
          GeneratedSemigroup(get: $0)
        }
      }
    }

    property("Semigroup.function respects some laws", file: file, line: line) <- forAll { (a: ArrowOf<String, Int>, b: ArrowOf<String, Int>, c: ArrowOf<String, Int>, semigroup: GeneratedSemigroup, value: String) in
      let function = Semigroup<(String) -> Int>.function(over: semigroup.get)
      let verifyFunction = VerifyOne(function) { $0(value) == $1(value)  }

      return verifyFunction.associativity(a.getArrow, b.getArrow, c.getArrow) <?> "Semigroup.function is associative"
    }
  }

  static var allTests = [
    ("testProperties", testProperties)
  ]
}

extension Ordering: Arbitrary {
  public static var arbitrary: Gen<Ordering> {
    Gen.fromElements(of: Ordering.allCases)
  }
}
