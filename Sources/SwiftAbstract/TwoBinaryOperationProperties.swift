// MARK: - Absorbability

public protocol Absorption: WithTwoBinaryOperations {}

extension VerifyTwo where TwoBO: Absorption {
  public func absorbability(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runSecond(a, runFirst(a, b)) == a && runFirst(a, runSecond(a, b)) == a
  }
}

// MARK: - Annihilability

protocol WithAnnihilation: WithZero {}

extension VerifyTwo where TwoBO: WithAnnihilation {
  func annihilability(_ a: TwoBO.A) -> Bool {
    runSecond(a, operations.zero) == operations.zero && runSecond(operations.zero, a) == operations.zero
  }
}

// MARK: - Distributivity

public protocol DistributiveFirstOverSecond: WithTwoBinaryOperations {}
public protocol DistributiveSecondOverFirst: WithTwoBinaryOperations {}
public typealias Distributive = DistributiveFirstOverSecond & DistributiveSecondOverFirst

extension VerifyTwo where TwoBO: DistributiveFirstOverSecond {
  public func distributivityOfFirstOverSecond(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runFirst(a, runSecond(b, c)) == runSecond(runFirst(a, b), runFirst(a, c))
  }
}

extension VerifyTwo where TwoBO: DistributiveSecondOverFirst {
  public func distributivityOfSecondOverFirst(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runSecond(a, runFirst(b, c)) == runFirst(runSecond(a, b), runSecond(a, c))
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
    runFirst(a, operations.implies(a, operations.zero)) == operations.one
  }
}

// MARK: - Implication

public protocol WithImplies: LatticeLike, WithOne {
  var implies: (A, A) -> A { get }
}

extension VerifyTwo where TwoBO: WithImplies {
  public func implication(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    operations.implies(a, a) == operations.one
      && runSecond(a, operations.implies(a, b)) == runSecond(a, b)
      && runSecond(b, operations.implies(a, b)) == b
      && operations.implies(a, runSecond(b, c)) == runSecond(operations.implies(a, b), operations.implies(a, c))
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
    runFirst(a, operations.negate(a)) == operations.zero && runFirst(operations.negate(a), a) == operations.zero
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
    runSecond(a, operations.one) == a && runSecond(operations.one, a) == a
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
    runSecond(a, operations.reciprocal(a)) == operations.one && runSecond(operations.reciprocal(a), a) == operations.one
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
    runFirst(a, operations.zero) == a && runFirst(operations.zero, a) == a
  }
}