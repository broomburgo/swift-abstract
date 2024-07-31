public struct BoundedLattice<Value>: LatticeLike, WithZero, WithOne {
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
    .idempotencyOfFirst,
    .idempotencyOfSecond,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension BoundedLattice {
  public init(from root: some AlgebraicStructure<Value> & LatticeLike & WithZero & WithOne) {
    self.init(
      first: .init(from: root.first),
      second: .init(from: root.second)
    )
  }
}

extension BoundedLattice where Value: Wrapper {
  public init(wrapping original: BoundedLattice<Value.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
