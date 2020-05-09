// MARK: - Definition

struct DistributiveLattice<A>: LatticeLike, Distributive {
  let first: Semilattice<A>
  let second: Semilattice<A>
}
