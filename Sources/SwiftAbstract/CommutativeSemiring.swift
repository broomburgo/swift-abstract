// MARK: - Definition

struct CommutativeSemiring<A>: RingLike, WithOne, CommutativeSecond {
  let first: CommutativeMonoid<A>
  let second: CommutativeMonoid<A>
}
