// MARK: - Definition

struct BoundedDistributiveLattice<A>: LatticeLike, Distributive, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>

  func properties(equating: @escaping (A, A) -> Bool) -> [LawsOf<BoundedDistributiveLattice<A>>.Property] {
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
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}
