// MARK: - Definition

struct CommutativeSemiring<A>: RingLike, WithOne, CommutativeSecond {
  let first: CommutativeMonoid<A>
  let second: CommutativeMonoid<A>

  func properties(equating: @escaping (A, A) -> Bool) -> [Verify<CommutativeSemiring<A>>.Property] {
    Verify(self, equating: equating).properties {
      [
        $0.annihilability,
        $0.associativityOfFirst,
        $0.associativityOfSecond,
        $0.commutativityOfFirst,
        $0.commutativityOfSecond,
        $0.distributivityOfSecondOverFirst,
        $0.oneIdentity,
        $0.zeroIdentity
      ]
    }
  }
}
