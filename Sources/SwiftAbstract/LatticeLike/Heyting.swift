public struct Heyting<Value>: LatticeLike, Distributive, WithZero, WithOne, WithImplies {
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
    .idempotencyOfFirst,
    .idempotencyOfSecond,
    .implication,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension Heyting {
  public init(from root: some AlgebraicStructure<Value> & LatticeLike & Distributive & WithZero & WithOne & WithImplies) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second),
      implies: root.implies
    )
  }
}

extension Heyting where Value: Wrapper {
  public init(wrapping original: Heyting<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second),
      implies: { .init(original.implies($0.wrapped, $1.wrapped)) }
    )
  }
}
