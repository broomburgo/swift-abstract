public struct Boolean<Value>: LatticeLike, Distributive, WithZero, WithOne, WithImplies, ExcludedMiddle {
  public var first: BoundedSemilattice<Value>
  public var second: BoundedSemilattice<Value>
  public var implies: (Value, Value) -> Value

  public init(first: BoundedSemilattice<Value>, second: BoundedSemilattice<Value>, implies: @escaping (Value, Value) -> Value) {
    self.first = first
    self.second = second
    self.implies = implies
  }

  public static var laws: [Law<Self>] { [
    .absorbability,
    .associativityOfFirst,
    .associativityOfSecond,
    .commutativityOfFirst,
    .commutativityOfSecond,
    .distributivityOfFirstOverSecond,
    .distributivityOfSecondOverFirst,
    .excludedMiddle,
    .idempotencyOfFirst,
    .idempotencyOfSecond,
    .implication,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension Boolean {
  public init(from root: some AlgebraicStructure<Value> & LatticeLike & Distributive & WithZero & WithOne & WithImplies & ExcludedMiddle) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second),
      implies: root.implies
    )
  }
}

extension Boolean where Value: Wrapper {
  public init(wrapping original: Boolean<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second),
      implies: { .init(original.implies($0.wrapped, $1.wrapped)) }
    )
  }
}

// MARK: - Instances

extension Boolean<Bool> {
  public static var bool: Self {
    Boolean(
      first: .or,
      second: .and,
      implies: { !$0 || $1 }
    )
  }
}
