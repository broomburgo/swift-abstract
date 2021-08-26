// MARK: - Definition

struct Lattice<A>: LatticeLike {
    let first: Semilattice<A>
    let second: Semilattice<A>

    static var laws: [Law<Self>] { [
        .absorbability,
        .associativityOfFirst,
        .associativityOfSecond,
        .commutativityOfFirst,
        .commutativityOfSecond,
        .idempotencyOfFirst,
        .idempotencyOfSecond,
    ] }
}
