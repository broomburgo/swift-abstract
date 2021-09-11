struct BoundedLattice<A>: LatticeLike, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>

  static var laws: [Law<Self>] { [
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
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: LatticeLike & WithZero & WithOne,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension BoundedLattice where A: Wrapper {
  init(wrapping original: BoundedLattice<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
