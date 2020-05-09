// MARK: - Definition

struct Rng<A>: RingLike, WithNegate {
  let first: AbelianGroup<A>
  let second: Semigroup<A>
}
