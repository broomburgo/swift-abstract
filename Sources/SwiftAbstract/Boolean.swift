// MARK: - Definition

struct Boolean<A>: LatticeLike, Distributive, WithZero, WithOne, WithImplies, ExcludedMiddle {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
  let implies: (A, A) -> A

  func properties(equating: @escaping (A, A) -> Bool) -> [LawsOf<Boolean<A>>.Property] {
    LawsOf(self, equating: equating).properties {
      [
        $0.absorbability,
        $0.associativityOfFirst,
        $0.associativityOfSecond,
        $0.commutativityOfFirst,
        $0.commutativityOfSecond,
        $0.distributivityOfFirstOverSecond,
        $0.distributivityOfSecondOverFirst,
        $0.excludedMiddle,
        $0.idempotencyOfFirst,
        $0.idempotencyOfSecond,
        $0.implication,
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}

// MARK: - Instances

extension Boolean where A == Bool {
  static var bool: Self {
    Boolean(
      first: .or,
      second: .and,
      implies: { !$0 || $1 }
    )
  }
}
