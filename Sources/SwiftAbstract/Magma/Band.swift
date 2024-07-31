public struct Band<Value>: Associative, Idempotent {
  public var apply: (Value, Value) -> Value

  public init(apply: @escaping (Value, Value) -> Value) {
    self.apply = apply
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .idempotency,
  ] }
}

// MARK: - Initializers

extension Band {
  public init(from root: some AlgebraicStructure<Value> & Associative & Idempotent) {
    self.init(apply: root.apply)
  }
}

extension Band where Value: Wrapper {
  public init(wrapping original: Band<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
  }
}

// MARK: - Instances

extension Band {
  public static var first: Self {
    Band(
      apply: { a, _ in a }
    )
  }

  public static var last: Self {
    Band(
      apply: { _, b in b }
    )
  }
}

extension Band /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: Band<Output>) -> Self where Value == (Input) -> Output {
    Band(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
