// MARK: - Definition

struct Heyting<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
  let implies: (A, A) -> A

  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Heyting<A>>.Property] {
    LawsOf(self, equating: equating).properties {
      [
        $0.absorbability,
        $0.associativityOfFirst,
        $0.associativityOfSecond,
        $0.commutativityOfFirst,
        $0.commutativityOfSecond,
        $0.distributivityOfFirstOverSecond,
        $0.distributivityOfSecondOverFirst,
        $0.idempotencyOfFirst,
        $0.idempotencyOfSecond,
        $0.implication,
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}
