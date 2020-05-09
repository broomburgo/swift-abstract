// MARK: - Definition

struct Ring<A>: RingLike, WithOne, WithNegate {
  let first: AbelianGroup<A>
  let second: Monoid<A>
}
