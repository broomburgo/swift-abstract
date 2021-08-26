// MARK: - Definition

struct Rng<A>: RingLike, WithNegate {
  let first: AbelianGroup<A>
  let second: Semigroup<A>

//  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Rng<A>>.Property] {
//    LawsOf(self, equating: equating).properties {
//      [
//        $0.annihilability,
//        $0.associativityOfFirst,
//        $0.associativityOfSecond,
//        $0.commutativityOfFirst,
//        $0.distributivityOfSecondOverFirst,
//        $0.negation,
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
        .negation,
        .zeroIdentity,
        ]
    }
}
