// MARK: - Absorption

public protocol Absorption: WithTwoBinaryOperations {}

extension VerifyTwo where TwoBO: Absorption {
  public func absorbability(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    equating(
      runSecond(a, runFirst(a, b)),
      a
    ) && equating(
      runFirst(a, runSecond(a, b)),
      a
    )
  }
}

// MARK: - Annihilation

protocol WithAnnihilation: WithZero {}

extension VerifyTwo where TwoBO: WithAnnihilation {
  func annihilability(_ a: TwoBO.A) -> Bool {
    equating(
      runSecond(a, operations.zero),
      operations.zero
    ) && equating(
      runSecond(operations.zero, a),
      operations.zero
    )
  }
}

// MARK: - Associativity

public protocol AssociativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Associative {}
public protocol AssociativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Associative {}
public typealias AssociativeBoth = AssociativeFirst & AssociativeSecond

extension VerifyTwo where TwoBO: AssociativeFirst {
  public func associativityOfFirst(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    equating(
      runFirst(runFirst(a, b), c),
      runFirst(a, runFirst(b, c))
    )
  }
}

extension VerifyTwo where TwoBO: AssociativeSecond {
  public func associativityOfSecond(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    equating(
      runSecond(runSecond(a, b), c),
      runSecond(a, runSecond(b, c))
    )
  }
}

extension VerifyTwo where TwoBO: AssociativeBoth {
  public func associativity(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    associativityOfFirst(a, b, c) && associativityOfSecond(a, b, c)
  }
}

// MARK: - Commutativity

public protocol CommutativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Commutative {}
public protocol CommutativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Commutative {}
public typealias CommutativeBoth = CommutativeFirst & CommutativeSecond

extension VerifyTwo where TwoBO: CommutativeFirst {
  public func commutativityOfFirst(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    equating(
      runFirst(a, b),
      runFirst(b, a)
    )
  }
}

extension VerifyTwo where TwoBO: CommutativeSecond {
  public func commutativityOfSecond(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    equating(
      runSecond(a, b),
      runSecond(b, a)
    )
  }
}

extension VerifyTwo where TwoBO: CommutativeBoth {
  public func commutativity(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    commutativityOfFirst(a, b) && commutativityOfSecond(a, b)
  }
}

// MARK: - Distributivity

public protocol DistributiveFirstOverSecond: WithTwoBinaryOperations {}
public protocol DistributiveSecondOverFirst: WithTwoBinaryOperations {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

extension VerifyTwo where TwoBO: DistributiveFirstOverSecond {
  public func distributivityOfFirstOverSecond(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    equating(
      runFirst(a, runSecond(b, c)),
      runSecond(runFirst(a, b), runFirst(a, c))
    )
  }
}

extension VerifyTwo where TwoBO: DistributiveSecondOverFirst {
  public func distributivityOfSecondOverFirst(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    equating(
      runSecond(a, runFirst(b, c)),
      runFirst(runSecond(a, b), runSecond(a, c))
    )
  }
}

extension VerifyTwo where TwoBO: Distributive {
  public func distributivity(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    distributivityOfFirstOverSecond(a, b, c) && distributivityOfSecondOverFirst(a, b, c)
  }
}

// MARK: - Excluded middle

public protocol ExcludedMiddle: WithImplies, WithZero {}

extension VerifyTwo where TwoBO: ExcludedMiddle {
  public func excludedMiddle(_ a: TwoBO.A) -> Bool {
    equating(
      runFirst(a, operations.implies(a, operations.zero)),
      operations.one
    )
  }
}

// MARK: - Implication

public protocol WithImplies: LatticeLike, WithOne {
  var implies: (A, A) -> A { get }
}

extension VerifyTwo where TwoBO: WithImplies {
  public func implication(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    equating(
      operations.implies(a, a),
      operations.one
    ) && equating(
      runSecond(a, operations.implies(a, b)),
      runSecond(a, b)
    ) && equating(
      runSecond(b, operations.implies(a, b)),
      b
    ) && equating(
      operations.implies(a, runSecond(b, c)),
      runSecond(operations.implies(a, b), operations.implies(a, c))
    )
  }
}

// MARK: - Idempotency

public protocol IdempotentFirst: WithTwoBinaryOperations where FirstBinaryOperation: Idempotent {}
public protocol IdempotentSecond: WithTwoBinaryOperations where SecondBinaryOperation: Idempotent {}
public typealias IdempotentBoth = IdempotentFirst & IdempotentSecond

extension VerifyTwo where TwoBO: IdempotentFirst {
  public func idempotencyOfFirst(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    equating(
      runFirst(runFirst(a, b), b),
      runFirst(a, b)
    )
  }
}

extension VerifyTwo where TwoBO: IdempotentSecond {
  public func idempotencyOfSecond(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    equating(
      runSecond(runSecond(a, b), b),
      runSecond(a, b)
    )
  }
}

extension VerifyTwo where TwoBO: IdempotentBoth {
  public func idempotency(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    idempotencyOfFirst(a, b) && idempotencyOfSecond(a, b)
  }
}

// MARK: - Negation

public protocol WithNegate: WithZero where FirstBinaryOperation: WithInverse {}

extension WithNegate {
  public var negate: (A) -> A {
    first.inverse
  }
}

extension VerifyTwo where TwoBO: WithNegate {
  public func negation(_ a: TwoBO.A) -> Bool {
    equating(
      runFirst(a, operations.negate(a)),
      operations.zero
    ) && equating(
      runFirst(operations.negate(a), a),
      operations.zero
    )
  }
}

// MARK: - One identity

public protocol WithOne: WithTwoBinaryOperations where SecondBinaryOperation: WithIdentity {}

extension WithOne {
  public var one: A {
    second.empty
  }
}

extension VerifyTwo where TwoBO: WithOne {
  public func oneIdentity(_ a: TwoBO.A) -> Bool {
    equating(
      runSecond(a, operations.one),
      a
    ) && equating(
      runSecond(operations.one, a),
      a
    )
  }
}

// MARK: - Reciprocity

public protocol WithReciprocal: WithOne where SecondBinaryOperation: WithInverse {}

extension WithReciprocal {
  public var reciprocal: (A) -> A {
    second.inverse
  }
}

extension VerifyTwo where TwoBO: WithReciprocal {
  public func reciprocity(_ a: TwoBO.A) -> Bool {
    equating(
      runSecond(a, operations.reciprocal(a)),
      operations.one
    ) && equating(
      runSecond(operations.reciprocal(a), a),
      operations.one
    )
  }
}

// MARK: - Zero identity

public protocol WithZero: WithTwoBinaryOperations where FirstBinaryOperation: WithIdentity {}

extension WithZero {
  public var zero: A {
    first.empty
  }
}

extension VerifyTwo where TwoBO: WithZero {
  public func zeroIdentity(_ a: TwoBO.A) -> Bool {
    equating(
      runFirst(a, operations.zero),
      a
    ) && equating(
      runFirst(operations.zero, a),
      a
    )
  }
}
