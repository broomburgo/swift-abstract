// MARK: - Definition

struct DistributiveLattice<A>: LatticeLike, Distributive {
  let first: Semilattice<A>
  let second: Semilattice<A>

  func getProperties(equating: @escaping (A, A) -> Bool) -> [LawsOf<DistributiveLattice<A>>.Property] {
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
        $0.idempotencyOfSecond
      ]
    }
  }
}
