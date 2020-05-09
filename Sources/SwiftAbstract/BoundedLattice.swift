// MARK: - Definition

struct BoundedLattice<A>: LatticeLike, WithZero, WithOne {
  let first: BoundedSemilattice<A>
  let second: BoundedSemilattice<A>
}
