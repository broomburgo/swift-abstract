// MARK: - Definition

struct Ring<A>: RingLike, WithOne, WithNegate {
    let first: AbelianGroup<A>
    let second: Monoid<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .distributivityOfSecondOverFirst,
        .negation,
        .oneIdentity,
        .zeroIdentity,
    ] }
}

// MARK: - Initializers

extension Ring {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithOne & WithNegate,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension Ring where A: Wrapper {
  init(wrapping original: Ring<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}
