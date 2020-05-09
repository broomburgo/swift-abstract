// MARK: - Algebraic structure

public protocol AlgebraicStructure {
  associatedtype A
}

// MARK: - One binary operation

public protocol WithOneBinaryOperation: AlgebraicStructure {
  var apply: (A, A) -> A { get }
}

public struct VerifyOne<OneBO: WithOneBinaryOperation> where OneBO.A: Equatable {
  public let operation: OneBO

  public init(operation: OneBO) {
    self.operation = operation
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

public struct VerifyTwo<TwoBO: WithTwoBinaryOperations> where TwoBO.A: Equatable {
  public let operations: TwoBO

  public init(operations: TwoBO) {
    self.operations = operations
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
  typealias PlusBinaryOperation = FirstBinaryOperation
  typealias TimesBinaryOperation = SecondBinaryOperation

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
  typealias MeetBinaryOperation = FirstBinaryOperation
  typealias JoinBinaryOperation = SecondBinaryOperation

  var join: (A, A) -> A { first.apply } /// ~ OR
  var meet: (A, A) -> A { second.apply } /// ~ AND
}
