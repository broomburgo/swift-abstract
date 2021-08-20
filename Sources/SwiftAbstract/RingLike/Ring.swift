// MARK: - Definition

struct Ring<A>: RingLike, WithOne, WithNegate {
  let first: AbelianGroup<A>
  let second: Monoid<A>

  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Ring<A>>.Property] {
    LawsOf(self, equating: equating).properties {
      [
        $0.annihilability,
        $0.associativityOfFirst,
        $0.associativityOfSecond,
        $0.commutativityOfFirst,
        $0.distributivityOfSecondOverFirst,
        $0.negation,
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}
