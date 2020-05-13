@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class AbelianGroupTests: XCTestCase {
  func testProperties() {
    property("AbelianGroup instances respect some laws") <- forAll { (a: NonZero<Float>, b: NonZero<Float>, c: NonZero<Float>) in
      [AbelianGroup<Float>.product
        .properties(equating: { $0.isAlmostEqual(to: $1) })
        .map { property in
          TestResult(
            require: "AbelianGroup.product \(property.name)",
            check: property.verify(a.rawValue, b.rawValue, c.rawValue)
          )
        },
       AbelianGroup<Float>.sum
          .properties(equating: { $0.isAlmostEqual(to: $1) })
          .map { property in
            TestResult(
              require: "AbelianGroup.sum \(property.name)",
              check: property.verify(a.rawValue, b.rawValue, c.rawValue)
            )
          }].flatMap { $0 }
        .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
    }
  }

  func testFunctionInstancesProperties() {
    struct GeneratedStructure: Arbitrary {
      let get: AbelianGroup<Float>

      static var arbitrary: Gen<GeneratedStructure> {
        Gen<AbelianGroup<Float>>.fromElements(of: [
          .product,
          .sum
        ]).map {
          GeneratedStructure(get: $0)
        }
      }
    }

    property("AbelianGroup.function respects some laws") <- forAll {
      (
        a: ArrowOf<String, NonZero<Float>>,
        b: ArrowOf<String, NonZero<Float>>,
        c: ArrowOf<String, NonZero<Float>>,
        structure: GeneratedStructure,
        value: String
      ) in
      AbelianGroup<(String) -> Float>.function(over: structure.get)
        .properties(equating: { $0(value).isAlmostEqual(to: $1(value)) })
        .map { property in
          TestResult(
            require: "AbelianGroup.function \(property.name)",
            check: property.verify(
              { a.getArrow($0).rawValue },
              { b.getArrow($0).rawValue },
              { c.getArrow($0).rawValue }
            )
          )
        }
        .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
    }
  }

  static var allTests = [
    ("testProperties", testProperties),
    ("testFunctionInstancesProperties", testFunctionInstancesProperties)
  ]
}
