struct BoundedDistributiveLattice<A>: LatticeLike, Distributive, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>

  static var laws: [Law<Self>] { [
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
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: LatticeLike & Distributive & WithZero & WithOne,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension BoundedDistributiveLattice where A: Wrapper {
  init(wrapping original: BoundedDistributiveLattice<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
