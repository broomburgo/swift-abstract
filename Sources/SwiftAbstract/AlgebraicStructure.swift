// MARK: - Algebraic structure

public protocol AlgebraicStructure {
  associatedtype A

  func verifyProperties(equating: @escaping (A, A) -> Bool) -> [(property: String, verify: (A, A, A) -> Bool)]
}

extension AlgebraicStructure {
  func verifyProperties(equating: @escaping (A, A) -> Bool) -> [(property: String, verify: (A, A, A) -> Bool)] {
    []
  }
}

// MARK: - One binary operation

public protocol WithOneBinaryOperation: AlgebraicStructure {
  var apply: (A, A) -> A { get }
}

public struct VerifyOne<OneBO: WithOneBinaryOperation> {
  public let operation: OneBO
  public let equating: (OneBO.A, OneBO.A) -> Bool

  public init(_ operation: OneBO, equating: @escaping (OneBO.A, OneBO.A) -> Bool) {
    self.operation = operation
    self.equating = equating
  }

  public var run: (OneBO.A, OneBO.A) -> OneBO.A {
    operation.apply
  }
}

// MARK: - Two binary operations

public protocol WithTwoBinaryOperations: AlgebraicStructure {
  associatedtype FirstBinaryOperation: WithOneBinaryOperation where FirstBinaryOperation.A == A
  associatedtype SecondBinaryOperation: WithOneBinaryOperation where SecondBinaryOperation.A == A

  var first: FirstBinaryOperation { get }
  var second: SecondBinaryOperation { get }
}

public struct VerifyTwo<TwoBO: WithTwoBinaryOperations> {
  public let operations: TwoBO
  public let equating: (TwoBO.A, TwoBO.A) -> Bool

  public init(_ operations: TwoBO, equating: @escaping (TwoBO.A, TwoBO.A) -> Bool) {
    self.operations = operations
    self.equating = equating
  }

  public var runFirst: (TwoBO.A, TwoBO.A) -> TwoBO.A {
    operations.first.apply
  }

  public var runSecond: (TwoBO.A, TwoBO.A) -> TwoBO.A {
    operations.second.apply
  }
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
