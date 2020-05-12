@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class SemigroupTests: XCTestCase {
  func testProperties() {
    verifyAllProperties(
      ofStructure: Semigroup<Int>.self,
      onInstances: [
        ("first", .first),
        ("last", .last),
        ("max", .max),
        ("min", .min),
        ("product", .product),
        ("sum", .sum)
      ]
    )

    verifyAllProperties(
      ofStructure: Semigroup<Bool>.self,
      onInstances: [
        ("and", .and),
        ("or", .or)
      ]
    )

    verifyAllProperties(
      ofStructure: Semigroup<String>.self,
      onInstances: [
        ("string", .string)
      ]
    )

    verifyAllProperties(
      ofStructure: Semigroup<Ordering>.self,
      onInstances: [
        ("ordering", .ordering)
      ]
    )

    verifyAllProperties(
      ofStructure: Semigroup<Int?>.self,
      onInstances: [
        ("firstIfPossible", .firstIfPossible()),
        ("lastIfPossible", .lastIfPossible())
      ]
    )

    verifyAllProperties(
      ofStructure: Semigroup<[Int]>.self,
      onInstances: [
        ("array", .array())
      ]
    )

    verifyAllProperties(
      ofStructure: Semigroup<Set<Int>>.self,
      onInstances: [
        ("setIntersection", .setIntersection()),
        ("setUnion", .setUnion())
      ]
    )

    verifyFunctionInstancesProperties()
  }

  private func verifyFunctionInstancesProperties(file: StaticString = #file, line: UInt = #line) {
    let endo = Semigroup<(Int) -> Int>.endo()

    property("Semigroup.endo respects some laws", file: file, line: line) <- forAll { (a: ArrowOf<Int, Int>, b: ArrowOf<Int, Int>, c: ArrowOf<Int, Int>, value: Int) in
      let verifyEndo = VerifyOne(endo) { $0(value) == $1(value) }

      return TestResult(
        require: "Semigroup.endo is associative",
        check: verifyEndo.associativity(a.getArrow, b.getArrow, c.getArrow)
      )
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
      let verifyFunction = VerifyOne(function) { $0(value) == $1(value) }

      return TestResult(
        require: "Semigroup.function is associative",
        check: verifyFunction.associativity(a.getArrow, b.getArrow, c.getArrow)
      )
    }
  }

  static var allTests = [
    ("testProperties", testProperties)
  ]
}
