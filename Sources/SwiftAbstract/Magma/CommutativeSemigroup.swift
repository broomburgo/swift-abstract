public struct CommutativeSemigroup<Value>: Associative, Commutative {
  public var apply: (Value, Value) -> Value

  public init(apply: @escaping (Value, Value) -> Value) {
    self.apply = apply
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
  ] }
}

// MARK: - Initializers

extension CommutativeSemigroup {
  public init(from root: some AlgebraicStructure<Value> & Associative & Commutative) {
    self.init(apply: root.apply)
  }
}

extension CommutativeSemigroup where Value: Wrapper {
  public init(wrapping original: CommutativeSemigroup<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
  }
}

// MARK: - Instances

extension CommutativeSemigroup /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: CommutativeSemigroup<Output>) -> Self where Value == (Input) -> Output {
    CommutativeSemigroup(
      apply: { f1, f2 in
        { input in
          output.apply(f1(input), f2(input))
        }
      }
    )
  }
}
