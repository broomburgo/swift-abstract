// MARK: - Associativity

public protocol Associative: WithOneBinaryOperation {}

extension VerifyOne where OneBO: Associative {
  public func associativity(_ a: OneBO.A, _ b: OneBO.A, _ c: OneBO.A) -> Bool {
    equating(
      run(run(a, b), c),
      run(a, run(b, c))
    )
  }
}

public protocol AssociativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Associative {}
public protocol AssociativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Associative {}
public typealias AssociativeBoth = AssociativeFirst & AssociativeSecond

extension VerifyTwo where TwoBO: AssociativeFirst {
  public func associativityOfFirst(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runFirst(runFirst(a, b), c) == runFirst(a, runFirst(b, c))
  }
}

extension VerifyTwo where TwoBO: AssociativeSecond {
  public func associativityOfSecond(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    runSecond(runSecond(a, b), c) == runSecond(a, runSecond(b, c))
  }
}

extension VerifyTwo where TwoBO: AssociativeBoth {
  public func associativity(_ a: TwoBO.A, _ b: TwoBO.A, _ c: TwoBO.A) -> Bool {
    associativityOfFirst(a, b, c) && associativityOfSecond(a, b, c)
  }
}

// MARK: - Commutativity

public protocol Commutative: WithOneBinaryOperation {}

extension VerifyOne where OneBO: Commutative {
  public func commutativity(_ a: OneBO.A, _ b: OneBO.A) -> Bool {
    equating(
      run(a, b),
      run(b, a)
    )
  }
}

public protocol CommutativeFirst: WithTwoBinaryOperations where FirstBinaryOperation: Commutative {}
public protocol CommutativeSecond: WithTwoBinaryOperations where SecondBinaryOperation: Commutative {}
public typealias CommutativeBoth = CommutativeFirst & CommutativeSecond

extension VerifyTwo where TwoBO: CommutativeFirst {
  public func commutativityOfFirst(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runFirst(a, b) == runFirst(b, a)
  }
}

extension VerifyTwo where TwoBO: CommutativeSecond {
  public func commutativityOfSecond(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runSecond(a, b) == runSecond(b, a)
  }
}

extension VerifyTwo where TwoBO: CommutativeBoth {
  public func commutativity(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    commutativityOfFirst(a, b) && commutativityOfSecond(a, b)
  }
}

// MARK: - Idempotency

public protocol Idempotent: WithOneBinaryOperation {}

extension VerifyOne where OneBO: Idempotent {
  public func idempotency(_ a: OneBO.A, _ b: OneBO.A) -> Bool {
    equating(
      run(run(a, b), b),
      run(a, b)
    )
  }
}

public protocol IdempotentFirst: WithTwoBinaryOperations where FirstBinaryOperation: Idempotent {}
public protocol IdempotentSecond: WithTwoBinaryOperations where SecondBinaryOperation: Idempotent {}
public typealias IdempotentBoth = IdempotentFirst & IdempotentSecond

extension VerifyTwo where TwoBO: IdempotentFirst {
  public func idempotencyOfFirst(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runFirst(runFirst(a, b), b) == runFirst(a, b)
  }
}

extension VerifyTwo where TwoBO: IdempotentSecond {
  public func idempotencyOfSecond(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    runSecond(runSecond(a, b), b) == runSecond(a, b)
  }
}

extension VerifyTwo where TwoBO: IdempotentBoth {
  public func idempotency(_ a: TwoBO.A, _ b: TwoBO.A) -> Bool {
    idempotencyOfFirst(a, b) && idempotencyOfSecond(a, b)
  }
}

// MARK: - Identity

public protocol WithIdentity: WithOneBinaryOperation {
  var empty: A { get }
}

extension VerifyOne where OneBO: WithIdentity {
  public func identity(_ a: OneBO.A) -> Bool {
    equating(
      run(a, operation.empty),
      a
    ) && equating(
      run(operation.empty, a),
      a
    )
  }
}

// MARK: - Invertibility

public protocol WithInverse: WithIdentity {
  var inverse: (A) -> A { get }
}

extension VerifyOne where OneBO: WithInverse {
  public func inverse(_ a: OneBO.A) -> Bool {
    equating(
      run(a, operation.inverse(a)),
      operation.empty
    )
  }
}
