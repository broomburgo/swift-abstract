@testable import SwiftAbstract
import SwiftCheck

struct Verify<Structure: AlgebraicStructure> {
    let law: Law<Structure>
    let structure: Structure
    let equating: (Structure.A, Structure.A) -> Bool

    func callAsFunction(_ a: Structure.A, _ b: Structure.A, _ c: Structure.A) -> Bool {
        switch law.getCheck(structure, equating) {
        case let .fromOne(f):
            return f(a)

        case let .fromTwo(f):
            return f(a, b)

        case let .fromThree(f):
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

func verifyAllLaws<Structure: AlgebraicStructure>(
    ofStructure algebraicStructure: Structure.Type,
    onInstances instances: [(instance: String, value: Structure)],
    equating: @escaping (Structure.A, Structure.A) -> Bool,
    file: StaticString = #file,
    line: UInt = #line
) where Structure.A: Arbitrary {
    property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: Structure.A, b: Structure.A, c: Structure.A) in
        instances
            .flatMap { instance, value in
                Structure.laws.map {
                    (instance, Verify(law: $0, structure: value, equating: equating))
                }
            }
            .map { instance, verify in
                TestResult(
                    require: "\(algebraicStructure).\(instance) \(verify.law.name)",
                    check: verify(a, b, c)
                )
            }
            .reduce(TestResult.succeeded.property) { conjoin($0, $1) }
    }
}

func verifyAllLaws<Structure: AlgebraicStructure, OutputStructure: AlgebraicStructure, Input>(
    ofFunctionBasedStructure algebraicStructure: Structure.Type,
    onInstances instances: [(instance: String, value: OutputStructure)],
    constructedBy getStructure: @escaping (OutputStructure) -> Structure,
    equating: @escaping (Input) -> (Structure.A, Structure.A) -> Bool,
    file: StaticString = #file,
    line: UInt = #line
) where Structure.A == (Input) -> OutputStructure.A, Input: Hashable & CoArbitrary & Arbitrary, OutputStructure.A: Arbitrary {
    property("\(algebraicStructure) instances respect some laws", file: file, line: line) <- forAll { (a: ArrowOf<Input, OutputStructure.A>, b: ArrowOf<Input, OutputStructure.A>, c: ArrowOf<Input, OutputStructure.A>, value: Input) in
        instances
            .flatMap { name, instance in
                Structure.laws.map {
                    (name, Verify(law: $0, structure: getStructure(instance), equating: equating(value)))
                }
            }
            .map { name, verify in
                TestResult(
                    require: "\(algebraicStructure).\(name) \(verify.law.name)",
                    check: verify(a.getArrow, b.getArrow, c.getArrow)
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
