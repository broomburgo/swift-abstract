// MARK: - Definition

struct BoundedLattice<A>: LatticeLike, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>

  func properties(equating: @escaping (A, A) -> Bool) -> [Verify<BoundedLattice<A>>.Property] {
    Verify(self, equating: equating).properties {
      [
        $0.absorbability,
        $0.associativityOfFirst,
        $0.associativityOfSecond,
        $0.commutativityOfFirst,
        $0.commutativityOfSecond,
        $0.idempotencyOfFirst,
        $0.idempotencyOfSecond,
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}
