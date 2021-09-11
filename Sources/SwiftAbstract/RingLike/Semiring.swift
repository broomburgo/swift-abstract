// MARK: - Definition

struct Semiring<A>: RingLike, WithOne {
    let first: CommutativeMonoid<A>
    let second: Monoid<A>

    static var laws: [Law<Self>] { [
        .annihilability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .distributivityOfSecondOverFirst,
        .oneIdentity,
        .zeroIdentity,
    ] }
}

extension Semiring {
  init<MoreSpecific>(from s: MoreSpecific) where
    MoreSpecific: RingLike & WithOne,
    MoreSpecific.A == A
  {
    self.init(
      first: .init(from: s.first),
      second: .init(from: s.second)
    )
  }
}

// MARK: - Instances

extension Semiring where A: AdditiveArithmetic & Comparable & WithMaximum {
    static var minTropical: Self {
        Semiring(
            first: CommutativeMonoid.min,
            second: Monoid.addition
        )
    }
}

extension Semiring where A: AdditiveArithmetic & Comparable & WithMinimum {
    static var maxTropical: Self {
        Semiring(
            first: CommutativeMonoid.max,
            second: Monoid.addition
        )
    }
}
