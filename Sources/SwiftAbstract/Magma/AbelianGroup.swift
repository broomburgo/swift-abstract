public struct AbelianGroup<Value>: Associative, Commutative, Identity, Invertible {
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
    .commutativity,
    .identity,
    .invertibility,
  ] }
}

// MARK: - Initializers

extension AbelianGroup {
  public init(from root: some AlgebraicStructure<Value> & Associative & Commutative & Identity & Invertible) {
    self.init(apply: root.apply, empty: root.empty, inverse: root.inverse)
  }
}

extension AbelianGroup where Value: Wrapper {
  public init(wrapping original: AbelianGroup<Value.Wrapped>) {
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

extension AbelianGroup where Value: SignedNumeric {
  public static var addition: Self {
    AbelianGroup(
      apply: { $0 + $1 },
      empty: .zero,
      inverse: { -$0 }
    )
  }
}

extension AbelianGroup where Value: FloatingPoint {
  public static var multiplication: Self {
    AbelianGroup(
      apply: {
        if ($0 == .infinity && $1 == .zero) || ($0 == .zero && $1 == .infinity) {
          return 1
        }

        return $0 * $1
      },
      empty: 1,
      inverse: { 1 / $0 }
    )
  }
}

extension AbelianGroup /* where Value == (Input) -> Output */ {
  public static func function<Input, Output>(over output: AbelianGroup<Output>) -> Self where Value == (Input) -> Output {
    AbelianGroup(
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
