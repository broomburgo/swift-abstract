// MARK: - Algebraic structure

public protocol AlgebraicStructure {
  associatedtype A

  func properties(equating: @escaping (A, A) -> Bool) -> [Verify<Self>.Property]
}

@dynamicMemberLookup
public struct Verify<Algebraic: AlgebraicStructure> {
  public struct Property {
    public let name: String
    public let verification: Verification

    public func verify(_ a: Algebraic.A, _ b: Algebraic.A, _ c: Algebraic.A) -> Bool {
      switch verification {
      case let .fromOne(f):
        return f(a)

      case let .fromTwo(f):
        return f(a, b)

      case let .fromThree(f):
        return f(a, b, c)
      }
    }

//    public func callAsFunction(_ a: Algebraic.A, _ b: Algebraic.A, _ c: Algebraic.A) -> Bool {
//
//    }
  }

  public enum Verification {
    case fromOne((Algebraic.A) -> Bool)
    case fromTwo((Algebraic.A, Algebraic.A) -> Bool)
    case fromThree((Algebraic.A, Algebraic.A, Algebraic.A) -> Bool)
  }

  public let operation: Algebraic
  public let equating: (Algebraic.A, Algebraic.A) -> Bool

  public init(_ operation: Algebraic, equating: @escaping (Algebraic.A, Algebraic.A) -> Bool) {
    self.operation = operation
    self.equating = equating
  }

  subscript<T>(dynamicMember kp: KeyPath<Algebraic, T>) -> T {
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
