@testable import SwiftAbstract
import SwiftCheck
import XCTest

final class AbelianGroupTests: XCTestCase {
  func testProperties() {}

  func testFunctionInstancesProperties() {
    struct GeneratedStructure: Arbitrary {
      let get: AbelianGroup<Int>

      static var arbitrary: Gen<GeneratedStructure> {
        Gen<AbelianGroup<Int>>.fromElements(of: [
          .sum
        ]).map {
          GeneratedStructure(get: $0)
        }
      }
    }

    property("AbelianGroup.function respects some laws") <- forAll {
      (
        a: ArrowOf<String, Int>,
        b: ArrowOf<String, Int>,
        c: ArrowOf<String, Int>,
        structure: GeneratedStructure,
        value: String
      ) in
      AbelianGroup<(String) -> Int>.function(over: structure.get)
        .properties(equating: { $0(value) == $1(value) })
        .map { property in
          TestResult(
            require: "AbelianGroup.function \(property.name)",
            check: property.verify(a.getArrow, b.getArrow, c.getArrow)
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
