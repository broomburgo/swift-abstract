struct CommutativeRing<A>: RingLike, WithOne, WithNegate {
  let first: AbelianGroup<A>
  let second: CommutativeMonoid<A>

  static var laws: [Law<Self>] { [
    .annihilability,
    .associativityOfFirst,
    .associativityOfSecond,
    .commutativityOfFirst,
    .commutativityOfSecond,
    .distributivityOfSecondOverFirst,
    .negation,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension CommutativeRing {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithOne & WithNegate,
    MoreSpecific.Second: Commutative,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension CommutativeRing where A: Wrapper {
  init(wrapping original: CommutativeRing<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
