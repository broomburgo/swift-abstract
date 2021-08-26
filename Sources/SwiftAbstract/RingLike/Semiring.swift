// MARK: - Definition

struct Semiring<A>: RingLike, WithOne {
  let first: CommutativeMonoid<A>
  let second: Monoid<A>

//  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Semiring<A>>.Property] {
//    LawsOf(self, equating: equating).properties {
//      [
//        $0.annihilability,
//        $0.associativityOfFirst,
//        $0.associativityOfSecond,
//        $0.commutativityOfFirst,
//        $0.distributivityOfSecondOverFirst,
//        $0.oneIdentity,
//        $0.zeroIdentity
//      ]
//    }
//  }

    static var properties: [Property<Self>] {
        [
            .annihilability,
            .associativityOfFirst,
            .associativityOfSecond,
            .commutativityOfFirst,
            .distributivityOfSecondOverFirst,
            .oneIdentity,
            .zeroIdentity,
        ]
    }
}

// MARK: - Instances

extension Semiring where A: AdditiveArithmetic & Comparable & WithMaximum {
  static var minTropical: Self {
    Semiring(
      first: CommutativeMonoid.min,
      second: Monoid.sum
    )
  }
}

extension Semiring where A: AdditiveArithmetic & Comparable & WithMinimum {
  static var maxTropical: Self {
    Semiring(
      first: CommutativeMonoid.max,
      second: Monoid.sum
    )
  }
}
