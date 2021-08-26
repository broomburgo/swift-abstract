// MARK: - Definition

struct CommutativeSemiring<A>: RingLike, WithOne {
  let first: CommutativeMonoid<A>
  let second: CommutativeMonoid<A>

//  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<CommutativeSemiring<A>>.Property] {
//    LawsOf(self, equating: equating).properties {
//      [
////        $0.annihilability,
////        $0.associativityOfFirst,
////        $0.associativityOfSecond,
//        $0.commutativityOfFirst,
//        $0.commutativityOfSecond,
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
            .commutativityOfSecond,
            .distributivityOfSecondOverFirst,
            .oneIdentity,
            .zeroIdentity,
        ]
    }
}
