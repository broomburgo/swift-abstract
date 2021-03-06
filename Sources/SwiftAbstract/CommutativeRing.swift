// MARK: - Definition

struct CommutativeRing<A>: RingLike, WithOne, WithNegate, CommutativeSecond {
  let first: AbelianGroup<A>
  let second: CommutativeMonoid<A>

  func properties(equating: @escaping (A, A) -> Bool) -> [LawsOf<CommutativeRing<A>>.Property] {
    LawsOf(self, equating: equating).properties {
      [
        $0.annihilability,
        $0.associativityOfFirst,
        $0.associativityOfSecond,
        $0.commutativityOfFirst,
        $0.commutativityOfSecond,
        $0.distributivityOfSecondOverFirst,
        $0.negation,
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}
