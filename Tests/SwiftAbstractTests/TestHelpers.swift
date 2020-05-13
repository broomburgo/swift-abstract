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

func verifyAllProperties<Algebraic: AlgebraicStructure>(
  ofStructure algebraicStructure: Algebraic.Type,
  onInstances instances: [(instance: String, value: Algebraic)],
  equating: @escaping (Algebraic.A, Algebraic.A) -> Bool,
  file: StaticString = #file,
  line: UInt = #line
) where Algebraic.A: Arbitrary {
  property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: Algebraic.A, b: Algebraic.A, c: Algebraic.A) in
    instances
      .flatMap { instance, value in
        value.properties(equating: equating).map { (instance, $0) }
      }
      .map { instance, property in
        TestResult(
          require: "\(algebraicStructure).\(instance) \(property.name)",
          check: property.verify(a, b, c)
        )
      }
      .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
  }
}

extension CheckerArguments {
  static func seedDescription(_ replayString: String) -> CheckerArguments {
    /// Expected format: "Replay with 711250669 9042 and size 7"
    let arguments = replayString
      .split(separator: " ")
      .compactMap { Int($0) }

    return CheckerArguments(replay: (StdGen(arguments[0], arguments[1]), arguments[2]))
  }
}

extension FloatingPoint where Self.Stride: ExpressibleByFloatLiteral {
  func isAlmostEqual(to other: Self, tolerance: Self.Stride = 0.0001) -> Bool {
    if self == .infinity && other == .infinity {
      return true
    }

    if self == -.infinity && other == -.infinity {
      return true
    }

    guard self != 0 else {
      return abs(other.distance(to: 0)) < tolerance
    }

    guard other != 0 else {
      return abs(self.distance(to: 0)) < tolerance
    }

    return abs((self / other).distance(to: 1)) < tolerance
  }
}
