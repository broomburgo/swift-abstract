public struct CommutativeMonoid<Value>: Associative, Commutative, Identity {
  public var apply: (Value, Value) -> Value
  public var empty: Value

  public init(apply: @escaping (Value, Value) -> Value, empty: Value) {
    self.apply = apply
    self.empty = empty
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
    .identity,
  ] }
}

// MARK: - Initializers

extension CommutativeMonoid {
  public init(from root: some AlgebraicStructure<Value> & Associative & Commutative & Identity) {
    self.init(apply: root.apply, empty: root.empty)
  }
}

extension CommutativeMonoid where Value: Wrapper {
  public init(wrapping original: CommutativeMonoid<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension CommutativeMonoid where Value: AdditiveArithmetic {
  public static var addition: Self {
    CommutativeMonoid(
      apply: { $0 + $1 },
      empty: .zero
    )
  }
}

extension CommutativeMonoid where Value: Numeric {
  public static var multiplication: Self {
    CommutativeMonoid(
      apply: { $0 * $1 },
      empty: 1
    )
  }
}

extension CommutativeMonoid /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: CommutativeMonoid<Output>) -> Self where Value == (Input) -> Output {
    CommutativeMonoid(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
