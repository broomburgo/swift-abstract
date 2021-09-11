// MARK: - Definition

struct Rng<A>: RingLike, WithNegate {
    let first: AbelianGroup<A>
    let second: Semigroup<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .distributivityOfSecondOverFirst,
        .negation,
        .zeroIdentity,
    ] }
}

extension Rng {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithNegate,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}
