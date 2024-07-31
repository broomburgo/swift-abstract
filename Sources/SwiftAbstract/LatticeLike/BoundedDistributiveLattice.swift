public struct BoundedDistributiveLattice<Value>: LatticeLike, Distributive, WithZero, WithOne {
  public var first: BoundedSemilattice<Value>
  public var second: BoundedSemilattice<Value>

  public init(first: BoundedSemilattice<Value>, second: BoundedSemilattice<Value>) {
    self.first = first
    self.second = second
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
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension BoundedDistributiveLattice {
  public init(from root: some AlgebraicStructure<Value> & LatticeLike & Distributive & WithZero & WithOne) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension BoundedDistributiveLattice where Value: Wrapper {
  public init(wrapping original: BoundedDistributiveLattice<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
