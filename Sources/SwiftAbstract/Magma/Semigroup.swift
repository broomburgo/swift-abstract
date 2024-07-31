public struct Semigroup<Value>: Associative {
  public var apply: (Value, Value) -> Value

  public init(apply: @escaping (Value, Value) -> Value) {
    self.apply = apply
  }

  public static var laws: [Law<Self>] { [
    .associativity,
  ] }
}

// MARK: - Initializers

extension Semigroup {
  public init(from root: some Associative<Value>) {
    self.init(apply: root.apply)
  }
}

extension Semigroup where Value: Wrapper {
  public init(wrapping original: Semigroup<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
  }
}

// MARK: - Instances

extension Semigroup /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: Semigroup<Output>) -> Self where Value == (Input) -> Output {
    Semigroup(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
