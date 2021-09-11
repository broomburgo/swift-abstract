struct DistributiveLattice<A>: LatticeLike, Distributive {
  let first: Semilattice<A>
  let second: Semilattice<A>

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
  ] }
}

// MARK: - Initializers

extension DistributiveLattice {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: LatticeLike & Distributive,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension DistributiveLattice where A: Wrapper {
  init(wrapping original: DistributiveLattice<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
