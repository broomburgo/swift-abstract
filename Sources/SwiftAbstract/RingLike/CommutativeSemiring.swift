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
