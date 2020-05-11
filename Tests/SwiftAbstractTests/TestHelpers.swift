@testable import SwiftAbstract
import SwiftCheck

extension Ordering: Arbitrary {
  public static var arbitrary: Gen<Ordering> {
    Gen.fromElements(of: Ordering.allCases)
  }
}

extension TestResult {
  init(require: String, check: Bool) {
    self = check ? .succeeded : .failed(require)
  }
}

func cartesian<AS: Sequence, BS: Sequence>(_ as: AS, _ bs: BS) -> [(AS.Element, BS.Element)] {
  `as`.flatMap { a in bs.map { b in (a, b) } }
}

func verifyAllProperties<Algebraic: WithOneBinaryOperation>(
  ofStructure algebraicStructure: Algebraic.Type,
  checking checks: [(name: String, property: (Algebraic.A, Algebraic.A, Algebraic.A, VerifyOne<Algebraic>) -> Bool)],
  onInstances instances: [(name: String, instance: Algebraic)],
  file: StaticString = #file,
  line: UInt = #line
) where Algebraic.A: Equatable & Arbitrary {
  property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: Algebraic.A, b: Algebraic.A, c: Algebraic.A) in
    cartesian(instances, checks)
      .map {
        TestResult(
          require: "\(algebraicStructure).\($0.name) \($1.name)",
          check: $1.property(a, b, c, VerifyOne($0.instance, equating: ==))
        )
      }
      .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
  }
}

func verifyAllProperties<Algebraic: WithTwoBinaryOperations>(
  ofStructure algebraicStructure: Algebraic.Type,
  checking checks: [(name: String, property: (Algebraic.A, Algebraic.A, Algebraic.A, VerifyTwo<Algebraic>) -> Bool)],
  onInstances instances: [(name: String, instance: Algebraic)],
  file: StaticString = #file,
  line: UInt = #line
) where Algebraic.A: Equatable & Arbitrary {
  property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: Algebraic.A, b: Algebraic.A, c: Algebraic.A) in
    cartesian(instances, checks)
      .map {
        TestResult(
          require: "\(algebraicStructure).\($0.name) \($1.name)",
          check: $1.property(a, b, c, VerifyTwo($0.instance, equating: ==))
        )
      }
      .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
  }
}
