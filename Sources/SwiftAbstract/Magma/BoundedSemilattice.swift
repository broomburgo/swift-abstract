public struct BoundedSemilattice<Value>: Associative, Commutative, Idempotent, Identity {
  public var apply: (Value, Value) -> Value
  public var empty: Value

  public init(apply: @escaping (Value, Value) -> Value, empty: Value) {
    self.apply = apply
    self.empty = empty
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
    .idempotency,
    .identity,
  ] }
}

// MARK: - Initializers

extension BoundedSemilattice {
  public init(from root: some AlgebraicStructure<Value> & Associative & Commutative & Idempotent & Identity) {
    self.init(apply: root.apply, empty: root.empty)
  }
}

extension BoundedSemilattice where Value: Wrapper {
  public init(wrapping original: BoundedSemilattice<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      },
      empty: .init(original.empty)
    )
  }
}

// MARK: - Instances

extension BoundedSemilattice where Value: Comparable & WithMinimum {
  public static var max: Self {
    BoundedSemilattice(
      apply: { Swift.max($0, $1) },
      empty: .minimum
    )
  }
}

extension BoundedSemilattice where Value: Comparable & WithMaximum {
  public static var min: Self {
    BoundedSemilattice(
      apply: { Swift.min($0, $1) },
      empty: .maximum
    )
  }
}

extension BoundedSemilattice<Bool> {
  public static var and: Self {
    BoundedSemilattice(
      apply: { $0 && $1 },
      empty: true
    )
  }

  public static var or: Self {
    BoundedSemilattice(
      apply: { $0 || $1 },
      empty: false
    )
  }
}

extension BoundedSemilattice /* where A == Set */ {
  /// While this can be useful as the free bounded semilattice, to truly express the algebraic properties of sets, and define a boolean algebra based on them, we actually need `PredicateSet`.
  public static func setUnion<Element>() -> Self where Value == Set<Element> {
    BoundedSemilattice(
      apply: { $0.union($1) },
      empty: []
    )
  }
}

extension BoundedSemilattice /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: BoundedSemilattice<Output>) -> Self where Value == (Input) -> Output {
    BoundedSemilattice(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      },
      empty: { _ in output.empty }
    )
  }
}
