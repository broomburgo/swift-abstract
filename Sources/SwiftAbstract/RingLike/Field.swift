// MARK: - Definition

struct Field<A>: RingLike, WithOne, WithNegate, WithReciprocal {
    let first: AbelianGroup<A>
    let second: AbelianGroup<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .commutativityOfSecond,
        .distributivityOfSecondOverFirst,
        .negation,
        .oneIdentity,
        .reciprocity,
        .zeroIdentity,
    ] }
}

// MARK: - Initializers

extension Field {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithOne & WithNegate & WithReciprocal,
    MoreSpecific.Second: Commutative,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension Field where A: Wrapper {
  init(wrapping original: Field<A.Wrapped>) {
    self.init(
      first: .init(wrapping: original.first),
      second: .init(wrapping: original.second)
    )
  }
}

// MARK: - Instances

extension Field where A: FloatingPoint {
    static var real: Self {
        .init(
            first: .addition,
            second: .multiplication
        )
    }
}
