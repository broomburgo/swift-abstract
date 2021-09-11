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

extension Field {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithOne & WithNegate & WithReciprocal,
    MoreSpecific.SecondBinaryOperation: Commutative,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

extension Field where A: FloatingPoint {
    static var real: Self {
        .init(
            first: .addition,
            second: .multiplication
        )
    }
}
