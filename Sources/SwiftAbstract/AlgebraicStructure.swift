// MARK: - Algebraic structure

public protocol AlgebraicStructure {
  associatedtype A

  func properties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Self>.Property]
}

// MARK: - Laws

@dynamicMemberLookup
public struct LawsOf<Structure: AlgebraicStructure> {
  public struct Property {
    public let name: String
    public let verification: Verification

    public func verify(_ a: Structure.A, _ b: Structure.A, _ c: Structure.A) -> Bool {
      switch verification {
      case let .fromOne(f):
        return f(a)

      case let .fromTwo(f):
        return f(a, b)

      case let .fromThree(f):
        return f(a, b, c)
      }
    }
  }

  public enum Verification {
    case fromOne((Structure.A) -> Bool)
    case fromTwo((Structure.A, Structure.A) -> Bool)
    case fromThree((Structure.A, Structure.A, Structure.A) -> Bool)
  }

  public let operation: Structure
  public let equating: (Structure.A, Structure.A) -> Bool

  public init(_ operation: Structure, equating: @escaping (Structure.A, Structure.A) -> Bool) {
    self.operation = operation
    self.equating = equating
  }

  subscript<T>(dynamicMember kp: KeyPath<Structure, T>) -> T {
    operation[keyPath: kp]
  }

  public func properties(_ f: (Self) -> [Property]) -> [Property] {
    f(self)
  }
}

// MARK: - One binary operation

public protocol WithOneBinaryOperation: AlgebraicStructure {
  var apply: (A, A) -> A { get }
}

// MARK: - Two binary operations

public protocol WithTwoBinaryOperations: AlgebraicStructure {
  associatedtype FirstBinaryOperation: WithOneBinaryOperation where FirstBinaryOperation.A == A
  associatedtype SecondBinaryOperation: WithOneBinaryOperation where SecondBinaryOperation.A == A

  var first: FirstBinaryOperation { get }
  var second: SecondBinaryOperation { get }
}

// MARK: - Ring-like

typealias RingLike = WithTwoBinaryOperations
  & AssociativeBoth
  & CommutativeFirst
  & DistributiveSecondOverFirst
  & WithZero
  & WithAnnihilation

extension WithTwoBinaryOperations where Self: RingLike {
  typealias Plus = FirstBinaryOperation
  typealias Times = SecondBinaryOperation

  var plus: (A, A) -> A { first.apply }
  var times: (A, A) -> A { second.apply }
}

// MARK: - Lattice-like

public typealias LatticeLike = WithTwoBinaryOperations
  & AssociativeBoth
  & CommutativeBoth
  & IdempotentBoth
  & Absorption

extension WithTwoBinaryOperations where Self: LatticeLike {
  typealias Join = FirstBinaryOperation
  typealias Meet = SecondBinaryOperation

  var join: (A, A) -> A { first.apply } /// ~ OR ; ~ MAX
  var meet: (A, A) -> A { second.apply } /// ~ AND; ~ MIN
}
