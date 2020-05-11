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
