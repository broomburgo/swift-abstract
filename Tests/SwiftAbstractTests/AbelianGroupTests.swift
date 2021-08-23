@testable import SwiftAbstract
import SwiftCheck
import XCTest
//import TSCUtility

final class AbelianGroupTests: XCTestCase {
  func testProperties() {
      _verifyAllProperties(
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

func _verifyAllProperties<Structure: AlgebraicStructure, OutputStructure: AlgebraicStructure, Input>(
  ofFunctionBasedStructure algebraicStructure: Structure.Type,
  onInstances instances: [(instance: String, value: OutputStructure)],
  constructedBy getStructure: @escaping (OutputStructure) -> Structure,
  equating: @escaping (Input) -> (Structure.A, Structure.A) -> Bool,
  file: StaticString = #file,
  line: UInt = #line
) where Structure.A == (Input) -> OutputStructure.A, Input: Hashable & CoArbitrary & Arbitrary, OutputStructure.A: Arbitrary {
    property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: ArrowOf<Input,  OutputStructure.A>, b: ArrowOf<Input,  OutputStructure.A>, c: ArrowOf<Input,  OutputStructure.A>, value: Input) in
    instances
      .flatMap { name, instance in
          Structure._properties.map {
              (name, _Verify(structure: getStructure(instance), equating: equating(value), property: $0))
          }
      }
      .map { name, verify in
        TestResult(
            require: "\(algebraicStructure).\(name) \(verify.property.name)",
            check: verify(a.getArrow, b.getArrow, c.getArrow)
        )
      }
      .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
  }
}
