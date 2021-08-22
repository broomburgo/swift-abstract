// MARK: - Definition

struct CommutativeRing<A>: RingLike, WithOne, WithNegate {
  let first: AbelianGroup<A>
  let second: CommutativeMonoid<A>

//  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<CommutativeRing<A>>.Property] {
//    LawsOf(self, equating: equating).properties {
//      [
//        $0.annihilability,
//        $0.associativityOfFirst,
//        $0.associativityOfSecond,
//        $0.commutativityOfFirst,
//        $0.commutativityOfSecond,
//        $0.distributivityOfSecondOverFirst,
//        $0.negation,
//        $0.oneIdentity,
//        $0.zeroIdentity
//      ]
//    }
//  }

    static var _properties: [_Property<Self>] {
        [
            .annihilability,
            .associativityOfFirst,
            .associativityOfSecond,
            .commutativityOfFirst,
            .commutativityOfSecond,
            .distributivityOfSecondOverFirst,
            .negation,
            .oneIdentity,
            .zeroIdentity,
        ]
    }
}
