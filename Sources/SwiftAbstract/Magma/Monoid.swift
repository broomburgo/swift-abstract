public struct Monoid<Value>: Associative, Identity {
  public var apply: (Value, Value) -> Value
  public var empty: Value

  public init(apply: @escaping (Value, Value) -> Value, empty: Value) {
    self.apply = apply
    self.empty = empty
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .identity,
  ] }
}

// MARK: - Initializers

extension Monoid {
  public init(from root: some AlgebraicStructure<Value> & Associative & Identity) {
    self.init(apply: root.apply, empty: root.empty)
  }
}

extension Monoid where Value: Wrapper {
  public init(wrapping original: Monoid<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension Monoid<String> {
  public static var string: Self {
    Monoid(
      apply: { $0 + $1 },
      empty: ""
    )
  }
}

extension Monoid /* where A == Array */ {
  public static func array<Element>() -> Self where Value == [Element] {
    Monoid(
      apply: { $1 + $0 },
      empty: []
    )
  }
}

extension Monoid /* where A == (T) -> T */ {
  public static func endo<T>() -> Self where Value == (T) -> T {
    Monoid(
      apply: { f1, f2 in
        { f2(f1($0)) }
      },
      empty: { $0 }
    )
  }
}

extension Monoid /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: Monoid<Output>) -> Self where Value == (Input) -> Output {
    Monoid(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
