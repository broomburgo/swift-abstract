public struct Semilattice<Value>: Associative, Commutative, Idempotent {
  public var apply: (Value, Value) -> Value

  public init(apply: @escaping (Value, Value) -> Value) {
    self.apply = apply
  }

  public static var laws: [Law<Self>] { [
    .associativity,
    .commutativity,
    .idempotency,
  ] }
}

// MARK: - Initializers

extension Semilattice {
  public init(from root: some AlgebraicStructure<Value> & Associative & Commutative & Idempotent) {
    self.init(apply: root.apply)
  }
}

extension Semilattice where Value: Wrapper {
  public init(wrapping original: Semilattice<Value.Wrapped>) {
    self.init(
      apply: {
        .init(original.apply($0.wrapped, $1.wrapped))
      }
    )
  }
}

// MARK: - Instances

extension Semilattice where Value: Comparable {
  public static var max: Self {
    Semilattice(
      apply: { Swift.max($0, $1) }
    )
  }

  public static var min: Self {
    Semilattice(
      apply: { Swift.min($0, $1) }
    )
  }
}

extension Semilattice /* where A == Set */ {
  /// This cannot be suitable for `WithEmpty` types, because there not such thing as the "universe" set, but it could be done with `PredicateSet`.
  public static func setIntersection<Element>() -> Self where Value == Set<Element> {
    Semilattice(
      apply: { $0.intersection($1) }
    )
  }
}

extension Semilattice /* where A == (Input) -> Output */ {
  public static func function<Input, Output>(over output: Semilattice<Output>) -> Self where Value == (Input) -> Output {
    Semilattice(
      apply: { f1, f2 in
        { output.apply(f1($0), f2($0)) }
      }
    )
  }
}
