public struct IdempotentMonoid<Value>: Associative, Idempotent, Identity {
  public var apply: (Value, Value) -> Value
  public var empty: Value

  public init(apply: @escaping (Value, Value) -> Value, empty: Value) {
    self.apply = apply
    self.empty = empty
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .idempotency,
    .idempotency,
  ] }
}

// MARK: - Initializers

extension IdempotentMonoid {
  public init(from root: some AlgebraicStructure<Value> & Associative & Idempotent & Identity) {
    self.init(apply: root.apply, empty: root.empty)
  }
}

extension IdempotentMonoid where Value: Wrapper {
  public init(wrapping original: IdempotentMonoid<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension IdempotentMonoid<Ordering> {
  public static var ordering: Self {
    IdempotentMonoid(
      apply: { Value.merge($0, $1) },
      empty: .equalTo
    )
  }
}

extension IdempotentMonoid /* where<Wrapped> A == Optional<Wrapped> */ {
  public static func firstIfPossible<Wrapped>() -> Self where Value == Wrapped? {
    IdempotentMonoid(
      apply: { $0 ?? $1 },
      empty: nil
    )
  }

  public static func lastIfPossible<Wrapped>() -> Self where Value == Wrapped? {
    IdempotentMonoid(
      apply: { $1 ?? $0 },
      empty: nil
    )
  }
}

extension IdempotentMonoid /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: IdempotentMonoid<Output>) -> Self where Value == (Input) -> Output {
    IdempotentMonoid(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
