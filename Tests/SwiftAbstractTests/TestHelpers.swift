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

//func verifyAllProperties<Structure: AlgebraicStructure>(
//  ofStructure algebraicStructure: Structure.Type,
//  onInstances instances: [(instance: String, value: Structure)],
//  equating: @escaping (Structure.A, Structure.A) -> Bool,
//  file: StaticString = #file,
//  line: UInt = #line
//) where Structure.A: Arbitrary {
//  property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: Structure.A, b: Structure.A, c: Structure.A) in
//    instances
//      .flatMap { instance, value in
//        value.getProperties(equating: equating).map { (instance, $0) }
//      }
//      .map { instance, property in
//        TestResult(
//          require: "\(algebraicStructure).\(instance) \(property.name)",
//          check: property.verify(a, b, c)
//        )
//      }
//      .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
//  }
//}

func _verifyAllProperties<Structure: AlgebraicStructure>(
  ofStructure algebraicStructure: Structure.Type,
  onInstances instances: [(instance: String, value: Structure)],
  equating: @escaping (Structure.A, Structure.A) -> Bool,
  file: StaticString = #file,
  line: UInt = #line
) where Structure.A: Arbitrary {
  property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: Structure.A, b: Structure.A, c: Structure.A) in
    instances
      .flatMap { instance, value in
          Structure._properties.map {
              (instance, _Verify(structure: value, equating: equating, property: $0))
          }
      }
      .map { instance, verify in
        TestResult(
            require: "\(algebraicStructure).\(instance) \(verify.property.name)",
          check: verify(a, b, c)
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

struct NonZero<RawValue: FloatingPoint>: RawRepresentable {
  let rawValue: RawValue

  init?(rawValue: RawValue) {
    guard rawValue != 0 else {
      return nil
    }

    self.rawValue = rawValue
  }

  init?(_ rawValue: RawValue) {
    self.init(rawValue: rawValue)
  }
}

extension NonZero: Arbitrary where RawValue: Arbitrary {
  static var arbitrary: Gen<Self> {
    RawValue.arbitrary
      .map { NonZero($0) }
      .suchThat { $0 != nil }
      .map { $0! }
  }
}
