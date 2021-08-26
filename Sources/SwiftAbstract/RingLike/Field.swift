// MARK: - Definition

struct Field<A>: RingLike, WithOne, WithNegate, WithReciprocal {
  let first: AbelianGroup<A>
  let second: AbelianGroup<A>

//  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Field<A>>.Property] {
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
//        $0.reciprocity,
//        $0.zeroIdentity,
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
            .negation,
            .oneIdentity,
            .reciprocity,
            .zeroIdentity,
        ]
    }
}
