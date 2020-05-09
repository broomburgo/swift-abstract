// MARK: - Definition

struct Lattice<A>: LatticeLike {
  let first: Semilattice<A>
  let second: Semilattice<A>
}
