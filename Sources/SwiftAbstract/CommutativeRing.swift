// MARK: - Definition

struct CommutativeRing<A>: RingLike, WithOne, WithNegate, CommutativeSecond {
  let first: AbelianGroup<A>
  let second: CommutativeMonoid<A>
}
