struct Heyting<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
  let implies: (A, A) -> A

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
    .implication,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension Heyting {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: LatticeLike & Distributive & WithZero & WithOne & WithImplies,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second),
      implies: s.implies
    )
  }
}

extension Heyting where A: Wrapper {
  init(wrapping original: Heyting<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second),
      implies: { .init(original.implies($0.wrapped, $1.wrapped)) }
    )
  }
}
