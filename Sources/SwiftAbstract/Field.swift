// MARK: - Definition

struct Field<A>: RingLike, WithOne, WithNegate, CommutativeSecond, WithReciprocal {
  let first: AbelianGroup<A>
  let second: AbelianGroup<A>
}
