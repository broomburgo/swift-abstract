struct Boolean<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies, ExcludedMiddle {
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
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: LatticeLike & Distributive & WithZero & WithOne & WithImplies & ExcludedMiddle,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second),
      implies: s.implies
    )
  }
}

extension Boolean where A: Wrapper {
  init(wrapping original: Boolean<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second),
      implies: { .init(original.implies($0.wrapped, $1.wrapped)) }
    )
  }
}

// MARK: - Instances

extension Boolean where A == Bool {
  static var bool: Self {
    Boolean(
      first: .or,
      second: .and,
      implies: { !$0 || $1 }
    )
  }
}
