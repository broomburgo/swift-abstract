@testable import SwiftAbstract
import SwiftCheck

struct Verify<Structure: AlgebraicStructure> {
  let law: Law<Structure>
  let structure: Structure
  let equating: (Structure.Value, Structure.Value) -> Bool

  func callAsFunction(_ a: Structure.Value, _ b: Structure.Value, _ c: Structure.Value) -> Bool {
    switch law.getCheck(structure, equating) {
    case .fromOne(let f):
      return f(a)

    case .fromTwo(let f):
      return f(a, b)

    case .fromThree(let f):
      return f(a, b, c)
    }
  }
}

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

func verifyAllLaws<Structure: AlgebraicStructure, Generated: Arbitrary, Extra: Arbitrary>(
  ofStructure algebraicStructure: Structure.Type,
  onInstances instances: [(instance: String, value: Structure)],
  equating: @escaping (Extra) -> (Structure.Value, Structure.Value) -> Bool,
  generating: @escaping (Generated) -> Structure.Value,
  arguments: CheckerArguments? = nil,
  file: StaticString = #file,
  line: UInt = #line
) {
  property("\(algebraicStructure) instances respect some laws", arguments: arguments, file: file, line: line) <- forAll { (ag: Generated, bg: Generated, cg: Generated, extra: Extra) in
    instances
      .flatMap { instance, value in
        Structure.laws.map {
          (instance, Verify(law: $0, structure: value, equating: equating(extra)))
        }
      }
      .map { instance, verify in
        TestResult(
          require: "\(algebraicStructure).\(instance) \(verify.law.name)",
          check: verify(generating(ag), generating(bg), generating(cg))
        )
      }
      .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
  }
}

func verifyAllLaws<Structure: AlgebraicStructure>(
  ofStructure algebraicStructure: Structure.Type,
  onInstances instances: [(instance: String, value: Structure)],
  equating: @escaping (Structure.Value, Structure.Value) -> Bool,
  arguments: CheckerArguments? = nil,
  file: StaticString = #file,
  line: UInt = #line
) where Structure.Value: Arbitrary {
  verifyAllLaws(
    ofStructure: algebraicStructure,
    onInstances: instances,
    equating: { (_: ArbitraryVoid) in equating },
    generating: { $0 },
    arguments: arguments,
    file: file,
    line: line
  )
}

func verifyAllLaws<Structure: AlgebraicStructure, OutputStructure: AlgebraicStructure, Input>(
  ofFunctionBasedStructure algebraicStructure: Structure.Type,
  onInstances instances: [(instance: String, value: OutputStructure)],
  constructedBy getStructure: @escaping (OutputStructure) -> Structure,
  equating: @escaping (Input) -> (Structure.Value, Structure.Value) -> Bool,
  arguments: CheckerArguments? = nil,
  file: StaticString = #file,
  line: UInt = #line
) where Structure.Value == (Input) -> OutputStructure.Value, Input: Hashable & CoArbitrary & Arbitrary, OutputStructure.Value: Arbitrary {
  verifyAllLaws(
    ofStructure: algebraicStructure,
    onInstances: instances.map { ($0, getStructure($1)) },
    equating: equating,
    generating: { (generated: ArrowOf<Input, OutputStructure.Value>) in generated.getArrow },
    arguments: arguments,
    file: file,
    line: line
  )
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
    if self == .infinity, other == .infinity {
      return true
    }

    if self == -.infinity, other == -.infinity {
      return true
    }

    guard self != 0 else {
      return abs(other.distance(to: 0)) < tolerance
    }

    guard other != 0 else {
      return abs(distance(to: 0)) < tolerance
    }

    return abs((self / other).distance(to: 1)) < tolerance
  }
}

private struct ArbitraryVoid: Arbitrary {
  static let arbitrary = Gen.pure(ArbitraryVoid())
}
