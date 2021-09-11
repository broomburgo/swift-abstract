struct Lattice<A>: LatticeLike {
  let first: Semilattice<A>
  let second: Semilattice<A>

  static var laws: [Law<Self>] { [
    .absorbability,
    .associativityOfFirst,
    .associativityOfSecond,
    .commutativityOfFirst,
    .commutativityOfSecond,
    .idempotencyOfFirst,
    .idempotencyOfSecond,
  ] }
}

// MARK: - Initializers

extension Lattice {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: LatticeLike,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension Lattice where A: Wrapper {
  init(wrapping original: Lattice<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
