struct CommutativeSemiring<A>: RingLike, WithOne {
  let first: CommutativeMonoid<A>
  let second: CommutativeMonoid<A>

  static var laws: [Law<Self>] { [
    .annihilability,
    .associativityOfFirst,
    .associativityOfSecond,
    .commutativityOfFirst,
    .commutativityOfSecond,
    .distributivityOfSecondOverFirst,
    .oneIdentity,
    .zeroIdentity,
  ] }
}

// MARK: - Initializers

extension CommutativeSemiring {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithOne,
    MoreSpecific.SecondBinaryOperation: Commutative,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension CommutativeSemiring where A: Wrapper {
  init(wrapping original: CommutativeSemiring<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
