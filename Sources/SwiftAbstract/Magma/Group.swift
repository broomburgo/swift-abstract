public struct Group<Value>: Associative, Identity, Invertible {
  public var apply: (Value, Value) -> Value
  public var empty: Value
  public var inverse: (Value) -> Value

  public init(apply: @escaping (Value, Value) -> Value, empty: Value, inverse: @escaping (Value) -> Value) {
    self.apply = apply
    self.empty = empty
    self.inverse = inverse
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .identity,
    .invertibility,
  ] }
}

// MARK: - Initializers

extension Group {
  public init(from root: some AlgebraicStructure<Value> & Associative & Identity & Invertible) {
    self.init(apply: root.apply, empty: root.empty, inverse: root.inverse)
  }
}

extension Group where Value: Wrapper {
  public init(wrapping original: Group<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty),
      inverse: { .init(original.inverse($0.wrapped)) }
    )
  }
}

// MARK: - Instances

extension Group /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: Group<Output>) -> Self where Value == (Input) -> Output {
    Group(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty },
      inverse: { f in
        { output.inverse(f($0)) }
      }
    )
  }
}
